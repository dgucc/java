<%@  page contentType="text/html; charset=UTF-8" %> 
<html lang="en">
<meta charset="utf-8"/>

<head>
<title>Jetty JSP REST</title>
</head>

<body>
<h1>Embedded Jetty JSP</h1>
<p>Jetty <%=new java.util.Date()%></p>

<p>Hello World from jetty!<p>

<p>
Rest samples
<ul>
	<li><a href="http://localhost:8080/rest/application.wadl">http://localhost:8080/rest/application.wadl</a></li>
	<li><a href="http://localhost:8080/rest/application.wadl?detail=true">http://localhost:8080/rest/application.wadl?detail=true</a></li>
	<li><a href="http://localhost:8080/rest/test/hello/WORLD">http://localhost:8080/rest/test/hello/WORLD</a></li>
	<li><a href="http://localhost:8080/upload.html">d3js : upload csv form</a></li>
</ul>
</p>
</body>
</html>