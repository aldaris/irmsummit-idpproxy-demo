/*
 * The contents of this file are subject to the terms of the Common Development and
 * Distribution License (the License). You may not use this file except in compliance with the
 * License.
 *
 * You can obtain a copy of the License at legal/CDDLv1.0.txt. See the License for the
 * specific language governing permission and limitations under the License.
 *
 * When distributing Covered Software, include this CDDL Header Notice in each file and include
 * the License file at legal/CDDLv1.0.txt. If applicable, add the following below the CDDL
 * Header, with the fields enclosed by brackets [] replaced by your own identifying
 * information: "Portions copyright [year] [name of copyright owner]".
 *
 * Copyright 2014 ForgeRock AS.
 */
package org.forgerock.openam.saml2.plugins;

import com.sun.identity.saml2.common.SAML2Constants;
import com.sun.identity.saml2.common.SAML2Exception;
import com.sun.identity.saml2.common.SAML2Utils;
import com.sun.identity.saml2.jaxb.entityconfig.SPSSOConfigElement;
import com.sun.identity.saml2.meta.SAML2MetaManager;
import com.sun.identity.saml2.meta.SAML2MetaUtils;
import com.sun.identity.saml2.plugins.SAML2IDPFinder;
import com.sun.identity.saml2.profile.SPCache;
import com.sun.identity.saml2.protocol.AuthnRequest;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import static org.forgerock.openam.utils.CollectionUtils.*;

public class DefaultSAML2IdPFinder implements SAML2IDPFinder {

    private static final String USE_IDP_FINDER = "useIDPFinder";

    @Override
    public List<String> getPreferredIDP(AuthnRequest authnRequest, String hostedEntityID, String realm,
            HttpServletRequest request, HttpServletResponse response) throws SAML2Exception {
        String remoteSPEntityID = authnRequest.getIssuer().getValue();
        SAML2MetaManager metaManager = new SAML2MetaManager();

        SPSSOConfigElement spssoConfig = metaManager.getSPSSOConfig(realm, remoteSPEntityID);
        boolean useIdPFinder = Boolean.valueOf(SAML2Utils.getAttributeValueFromSPSSOConfig(spssoConfig,
                USE_IDP_FINDER));
        Map<String, List<String>> spSettings = SAML2MetaUtils.getAttributes(spssoConfig);
        List<String> proxyIdPs = spSettings.get(SAML2Constants.IDP_PROXY_LIST);
        if (proxyIdPs == null || proxyIdPs.isEmpty()) {
            return null;
        }

        if (useIdPFinder) {
            String idpFinderJsp = SAML2Utils.getAttributeValueFromSSOConfig(realm, hostedEntityID,
                    SAML2Constants.IDP_ROLE, SAML2Constants.PROXY_IDP_FINDER_JSP);

            // Generate the requestID
            String requestID = SAML2Utils.generateID();
            Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("authnReq", authnRequest);
            paramsMap.put("spSSODescriptor", metaManager.getSPSSODescriptor(realm, remoteSPEntityID));
            paramsMap.put("idpEntityID", hostedEntityID);
            paramsMap.put("realm", realm);
            paramsMap.put("relayState", request.getParameter(SAML2Constants.RELAY_STATE));
            paramsMap.put("binding", "POST".equals(request.getMethod()) ? SAML2Constants.HTTP_POST
                    : SAML2Constants.HTTP_REDIRECT);
            SPCache.reqParamHash.put(requestID, paramsMap);

            try {
                request.setAttribute("idpList", proxyIdPs);
                request.setAttribute("requestID", requestID);
                RequestDispatcher dispatcher = request.getRequestDispatcher(idpFinderJsp);
                dispatcher.forward(request, response);
            } catch (ServletException | IOException ex) {
                return null;
            }
            return asList(requestID);
        } else {
            return proxyIdPs.subList(0, 1);
        }
    }
}
