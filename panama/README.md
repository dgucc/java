
# PANAMA PAPERS 2016

+ embedded jetty 
+ jsp support
+ jersey for service rest
+ multipart support 
+ d3js


## start jetty :  

execute src/main/java/sandbox/App.java in eclipse 
or with maven :  

`$ mvn clean compile`  
`$ mvn exec:java -Dexec.mainClass="sandbox.App"`  

8080 Already in use :  
`$ lsof -i:8080`  
`$ kill -9 <PID>`  


> http://localhost:8080/rest/application.wadl  
http://localhost:8080/rest/application.wadl?detail=true  
http://localhost:8080/rest/test/hello/WORLD  

> [d3js : upload csv](http://localhost:8080/upload-csv.jsp) &rarr; POST mediaType="multipart/form-data"

<img src="images/d3js-preview.png" alt="Preview d3js graph" title="Preview d3js graph" style="width:70%">  
  

## json to csv : jq

Extract selected fields + arithmetic on fields X and Y :   
`$ jq -r '.[] | [.source, .sourceName, .target, .targetName, (.fieldX | tonumber)+(.fieldY | tonumber)] | @csv ' input.json > output.csv`  


## Sources of data samples
[Panama Papers Dataset 2016](https://github.com/amaboura/panama-papers-dataset-2016)  
https://github.com/amaboura/panama-papers-dataset-2016/blob/master/csv-viz-data/All-edges.csv  

## Font awesome 4.7.0
[The set of icons in Font Awesome 4.7.0](https://fontawesome.com/v4/icons/)

---


## Fixes

### 1. HTTP ERROR 500 - PWC6033: Unable to compile class for JSP

Cause : mismatch between java and jetty version...  
> Fix :   
- ensure using jdk 8 : eclipse > Window > Preferences > java > Installed JREs  
- use compatible version of jetty in pom.xml : `<jetty.version>9.4.43.v20210629</jetty.version>`  

### 2. InjectionManagerFactory not found. 

`2021-07-20 11:11:04 WARN  ROOT:2353 - unavailable
java.lang.IllegalStateException: InjectionManagerFactory not found.`

> Fix :
```
<jetty.version>9.4.43.v20210629</jetty.version>
[...]
<dependency>
	<groupId>org.glassfish.jersey.inject</groupId>
	<artifactId>jersey-hk2</artifactId>
	<version>${jersey.version}</version>
</dependency>
```

### 3. NO JSP Support

```
2021-07-20 11:15:21 INFO  StandardDescriptorProcessor:277 - NO JSP Support for /, did not find org.eclipse.jetty.jsp.JettyJspServlet
2021-07-20 11:15:21 INFO  StandardDescriptorProcessor:277 - NO JSP Support for /, did not find org.apache.jasper.servlet.JspServlet
```
> Fix :  
```
<jetty.version>9.4.43.v20210629</jetty.version>
[...]
<dependency>
	<groupId>org.eclipse.jetty</groupId>
	<artifactId>apache-jsp</artifactId>
	<version>${jetty.version}</version>
</dependency>
```

### 4. java.lang.NoClassDefFoundError: javax/xml/bind/JAXBEContext

> Fix :  
```
<dependency>
    <groupId>javax.xml.bind</groupId>
    <artifactId>jaxb-api</artifactId>
    <version>2.3.1</version>
</dependency> 
```
