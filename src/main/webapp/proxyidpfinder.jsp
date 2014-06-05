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
--%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page info="IdPFinder" language="java" contentType="text/html" %>
<%@page import="com.iplanet.am.util.SystemProperties" %>
<%@page import="com.sun.identity.shared.Constants" %>
<%@page import="com.sun.identity.shared.encode.Base64" %>
<%@page import="java.nio.charset.Charset"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="org.owasp.esapi.ESAPI" %>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Choose your destiny</title>
        <%
            String contextPath = SystemProperties.get(Constants.AM_SERVICES_DEPLOYMENT_DESCRIPTOR);
        %>
        <link href="<%= contextPath%>/css/new_style.css" rel="stylesheet" type="text/css" />
        <!--[if IE 9]> <link href="<%= contextPath%>/css/ie9.css" rel="stylesheet" type="text/css"> <![endif]-->
        <!--[if lte IE 7]> <link href="<%= contextPath%>/css/ie7.css" rel="stylesheet" type="text/css"> <![endif]-->
    </head>
    <body>
        <div class="container_12">
            <div class="grid_4 suffix_8">
                <a class="logo" href="<%= contextPath%>"></a>
            </div>
            <div class="box clear-float">
                <div class="grid_3">
                    <div class="product-logo"></div>
                </div>
                <div class="grid_9 left-seperator">
                    <div id="loginContent" class="box-content clear-float">
                        <form action="<%= request.getAttribute("javax.servlet.forward.request_uri")%>" method="GET">
                            <div class="row">
                                <label for="hello">Please select your IdP from the following list:</label>
                                <select name="_saml_idp">
                                    <% for (String idp : (List<String>) request.getAttribute("idpList")) {%>
                                    <option value="<%= Base64.encode(idp.getBytes(Charset.forName("UTF-8")))%>"><%= idp%></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                            <fieldset>
                                <div class="row">
                                    <input type="hidden" name="requestID" value="<%= request.getAttribute("requestID")%>" />
                                    <input name="submit" type="submit" value="GO" />
                                </div>
                            </fieldset>
                        </form>
                    </div>
                </div>
            </div>
            <div class="footer alt-color">
                <div class="grid_6 suffix_3">
                    <p><%= ResourceBundle.getBundle("amAuthUI", request.getLocale()).getString("copyright.notice")%></p>
                </div>
            </div>
        </div>
    </body>
</html>