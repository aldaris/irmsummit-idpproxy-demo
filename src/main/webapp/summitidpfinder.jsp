<%--
   The contents of this file are subject to the terms of the Common Development and
   Distribution License (the License). You may not use this file except in compliance with the
   License.

   You can obtain a copy of the License at legal/CDDLv1.0.txt. See the License for the
   specific language governing permission and limitations under the License.
   When distributing Covered Software, include this CDDL Header Notice in each file and include
   the License file at legal/CDDLv1.0.txt. If applicable, add the following below the CDDL
   Header, with the fields enclosed by brackets [] replaced by your own identifying
   information: "Portions copyright [year] [name of copyright owner]".

   Copyright 2014 ForgeRock AS.
--%><!DOCTYPE html>
<%@page info="IdPFinder" language="java" contentType="text/html" %>
<%@page import="com.iplanet.am.util.SystemProperties" %>
<%@page import="com.sun.identity.shared.Constants" %>
<%@page import="com.sun.identity.shared.encode.Base64" %>
<%@page import="java.nio.charset.Charset" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ResourceBundle" %>
<%@page import="org.owasp.esapi.ESAPI" %>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Choose your destiny</title>
        <%
            String contextPath = SystemProperties.get(Constants.AM_SERVICES_DEPLOYMENT_DESCRIPTOR);
        %>
        <link rel="stylesheet/less" type="text/css" href="<%= contextPath %>/XUI/css/styles.less" />
        <script language="javascript" type="text/javascript" src="<%= contextPath %>/XUI/libs/less-1.5.1-min.js"></script>
        <script language="javascript" type="text/javascript">
            less.modifyVars({
                "@background-image": "url('../images/box-bg.png')",
                "@background-position": "950px -100px",
                "@footer-background-color": "rgba(238, 238, 238, 0.7)",
                "@content-background": "#f9f9f9"
            });
        </script>
    </head>
    <body>
        <div id="wrapper">
            <div id="login-base" class="base-wrapper">
                <div id="header">
                    <div id="logo" class="float-left">
                        <a href="" title="ForgeRock"><img src="<%= contextPath %>/XUI/images/logo.png" alt="ForgeRock" style="height: 80px" /></a>
                    </div>
                </div>
                <div id="content" class="content">
                    <div class="container-shadow" id="login-container">
                        <form action="<%= request.getAttribute("javax.servlet.forward.request_uri") %>" method="POST" class="form small">
                            <fieldset>
                                <div class="group-field-block">
                                    <label class="short" for="_saml_idp">Select IdP:</label>
                                    <select name="_saml_idp">
                                        <% for (String idp : (List<String>) request.getAttribute("idpList")) { %>
                                        <option value="<%= Base64.encode(idp.getBytes(Charset.forName("UTF-8"))) %>"><%= idp %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </div>
                                <div class="group-field-block float-right">
                                    <input type="hidden" name="requestID" value="<%= request.getAttribute("requestID")%>" />
                                    <input name="submit" type="submit" class="button" index="0" value="GO">
                                </div>
                            </fieldset>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div id="footer">
            <div class="container center">
                <p class="center">
                    <a href="mailto: info@forgerock.com">info@forgerock.com</a>
                    <br>
                    Copyright © 2010-14 ForgeRock AS, all rights reserved.
                </p>
            </div>
        </div>
    </body>
</html>
