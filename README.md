# IdP Proxy IdP Finder implementation demo

This is the demo'd IdP Finder solution implemented for the IdP Proxy Demo performed on IRM Summit 2014

## To install

* Set up IdP Proxy by following [this guide](https://wikis.forgerock.org/confluence/display/openam/SAMLv2+IDP+Proxy+Part+1.+Setting+up+a+simple+Proxy+scenario).
* compile the project
* add the class files to WEB-INF/classes (or to WEB-INF/lib if you create a JAR out of it)
* add the proxyidpfinder.jsp to the OpenAM WAR
* On the IdP Proxy's admin console go to Federation -> &lt;IdP Proxy entity> -> IDP -> Advanced tab and set the followings:
    * IDP Finder implementation class: org.forgerock.openam.saml2.plugins.DefaultSAML2IdPFinder
    * IDP Finder JSP: /proxyidpfinder.jsp

And this is it! Once a given SP's request can be forwarded to several different IdPs, this Finder implementation should kick in and allow the user to select their IdP.

## Disclaimer

This was developed relatively quickly to get my demo working, so you may find that it is not suitable for all the different scenarios (or just has some really poor error handling), the purpose of this project is really to show how easy it is to implement something like this.

## License

Everything in this repo is licensed under the ForgeRock CDDL license: http://forgerock.org/license/CDDLv1.0.html
