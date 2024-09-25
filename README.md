# java

![Avatar](https://github.com/dgucc/sandbox/blob/main/tips/images/avatar.gif)  

---

## Install OpenJDK on Linux Mint

[Install OpenJDK on Linux Mint 21](https://techviewleo.com/install-java-openjdk-on-linux-mint/)  

List all available versions of OpenJDK on Linux Mint.  
```bash  
$ sudo apt update
$ apt-cache search openjdk
```
To install the default OpenJDK :    
`$ sudo apt install default-jdk` 

Or select a specific version :    
`$ sudo apt install openjdk-17-jdk` 

List of Java versions installed :   
`$ sudo update-java-alternatives --list` 

Set the default version :   
`$ sudo update-alternatives --config java`  

Check the default version:  
`$ java --version` 

---

[maven simple example](https://github.com/dgucc/java/tree/main/my-app)  

---

## Install IntelliJ Community Edition

[Reference](https://samtinkers.wordpress.com/2020/08/31/install-intellij-in-linux-mint-20/)  
[Download Community Edition](https://download.jetbrains.com/idea/ideaIC-2024.1.2-aarch64.tar.gz)  

```bash  
cd /home/user/Downloads/
tar xvf ideaIC-2024.1.2.tar.gz
sudo mv idea-IC-241.17011.79 /opt/idea
```  
Launch IntelliJ: `/opt/idea/bin/idea.sh`  

Create launcher : Menu Tools > "Create Desktop Entry"  


Add contextual menu "Open with Intellij" in linux mint    

create file ~/.local/share/nemo/actions/intellij.nemo_action :  

```
[Nemo Action]
Name=Open in Intellij
Comment=Open with Intellij
Exec="/opt/idea/bin/idea.sh" %F
Icon-Name=intellij
Selection=Any
Extensions=dir;
```

---

## Wi-Fi QR-Code

Sample to generate QRCode for WiFi  

## 8080 Already in use :  
`$ lsof -i:8080`  
`$ kill -9 <PID>`  

with cygwin :  
`$ netstat -aonp tcp | awk  '$4 == "LISTENING" && $2 ~ /:8080$/ '`  

## Get rid of "WARNING: An illegal reflective access operation has occurred"
```
import java.lang.reflect.Field;
import java.lang.reflect.Method;

@SuppressWarnings("unchecked")
public static void disableAccessWarnings() {
        try {
            Class unsafeClass = Class.forName("sun.misc.Unsafe");
            Field field = unsafeClass.getDeclaredField("theUnsafe");
            field.setAccessible(true);
            Object unsafe = field.get(null);

            Method putObjectVolatile = unsafeClass.getDeclaredMethod("putObjectVolatile", Object.class, long.class, Object.class);
            Method staticFieldOffset = unsafeClass.getDeclaredMethod("staticFieldOffset", Field.class);

            Class loggerClass = Class.forName("jdk.internal.module.IllegalAccessLogger");
            Field loggerField = loggerClass.getDeclaredField("logger");
            Long offset = (Long) staticFieldOffset.invoke(unsafe, loggerField);
            putObjectVolatile.invoke(unsafe, loggerClass, offset, null);
        } catch (Exception ignored) {
        }
}

public static void main(String[] args) {
	disableAccessWarnings();
		...
}
```  
## Script to run maven for a specific jdk  
mvn8.cmd :  
```cmd
@echo off
@REM Remember to add PATH to this file...

echo "       ____.                       ______    "
echo "      |    |____ ___  _______     /  __  \   "
echo "      |    \__  \\  \/ /\__  \    >      <   "
echo "  /\__|    |/ __ \\   /  / __ \_ /   --   \  "
echo "  \________(____  /\_/  (____  / \______  /  "
echo "                \/           \/         \/   "
echo "                                             "

@REM SET M2_HOME=C:\home\bin\apache-maven-3.9.5
SET JAVA_HOME=C:\home\bin\jdk-8
CALL "C:\home\bin\apache-maven-3.9.5\bin\mvn.cmd" %*
```
mvn8.sh : 
```bash
#!/usr/bin/bash
export JAVA_HOME="C:\home\bin\jdk-17"
echo "      ____.                      _____________   "
echo "     |    |____ ___  _______    /_   \______  \  "
echo "     |    \__  \\  \/ /\__  \    |   |   /    /  "
echo " /\__|    |/ __ \\   /  / __ \_  |   |  /    /   "
echo " \________(____  /\_/  (____  /  |___| /____/    "
echo "               \/           \/                   "
mvn $@ 
```

## Convert Charset
```java
final Charset fromCharset = Charset.forName("windows-1252");
final Charset toCharset = Charset.forName("UTF-8");
return new String(input.getBytes(fromCharset), toCharset);
```  
---

## Standard Formats 

Phone Number  
`tel:+48111111111;`  

SMS  
`smsto:555-555-5555:What's up Dude`  

vCard  
```
BEGIN:VCARD
VERSION:2.1
N:John Doe
TEL;HOME;VOICE:555-555-5555
TEL;WORK;VOICE:666-666-6666
EMAIL:john@example.com
ORG:home
URL:https://john.doe.com
END:VCARD
```

Email  
`mailto:contact@example.com?subject=Subject&body=Body`  

---  

## References 

Found this (not yet tested)  
[QR Code generator library](https://github.com/nayuki/QR-Code-generator)  

---

## Mismatching Java version and Maven Dependency

To identify "Mismatching Java version and Maven Dependency" use ["maven-enforcer-plugin" and "extra-enforcer-rule"](https://stackoverflow.com/questions/26559830/required-java-version-of-maven-dependency/26565660#26565660)  

Add this lines in the [pom.xml](https://www.mojohaus.org/extra-enforcer-rules/enforceBytecodeVersion.html)   

```xml
<build>
<plugins>
	<plugin>
		<groupId>org.apache.maven.plugins</groupId>
		<artifactId>maven-enforcer-plugin</artifactId>
		<version>3.3.0</version> 
		<!-- find the latest version at http://maven.apache.org/plugins/maven-enforcer-plugin/ -->
		<executions>
			<execution>
				<id>enforce-bytecode-version</id>
				<goals>
					<goal>enforce</goal>
				</goals>
				<configuration>
					<rules>
						<enforceBytecodeVersion>
							<maxJdkVersion>1.8</maxJdkVersion>
							<excludes>
								<exclude>org.mindrot:jbcrypt</exclude>
							</excludes>
						</enforceBytecodeVersion>
					</rules>
					<fail>true</fail>
				</configuration>
			</execution>
		</executions>
		<dependencies>
			<dependency>
				<groupId>org.codehaus.mojo</groupId>
				<artifactId>extra-enforcer-rules</artifactId>
				<version>1.7.0</version>
			</dependency>
		</dependencies>
		</plugin>
	</plugins>
</build>
```
	Identify problematic dependency 
 
`$ mvn clean compile`  

> [ERROR] Rule 0: org.codehaus.mojo.extraenforcer.dependencies.EnforceBytecodeVersion failed with message:
> [ERROR] Found Banned Dependency: org.hsqldb:hsqldb:jar:2.6.0
> [ERROR] Use 'mvn dependency:tree' to locate the source of the banned dependencies.

---

 
## [Marshaller example](https://howtodoinjava.com/jaxb/marshaller-example/)
 "Marshaller Callback Methods"  
 "You can customize the marshalling operation by inside JAXB annotated class e.g. Employee.java. "  
 "You need to define two methods which will listen before and after the marshaller process that class. "  
 "In these methods, you can perform actions such as setting extra fields"  
``` 
// Invoked by Marshaller after it has created an instance of this object.
boolean beforeMarshal(Marshaller marshaller) {
	System.out.println("Before Marshaller Callback");
	return true;
}

// Invoked by Marshaller after it has marshalled all properties of this object.
void afterMarshal(Marshaller marshaller) {
	System.out.println("After Marshaller Callback");
}
```

## Regex Normalizer
```
System.out.println(Normalizer.normalize(CEt ça sera sa moitié, Normalizer.Form.NFD));
CEt ça sera sa moitié
System.out.println(Normalizer.normalize(CEt ça sera sa moitié, Normalizer.Form.NFD).replaceAll([^\\p{ASCII}], )); // \\p{ASCII} : match ascii
CEt ca sera sa moitie
System.out.println(Normalizer.normalize(CEt ça sera sa moitié, Normalizer.Form.NFD).replaceAll([\\p{M}],)); // \\p{M} : match accents
CEt ca sera sa moitie
```

## xpath

xpath to get StartDate and EndDate for all declaration types :  
`//*[local-name()='Declarer']//*[local-name()='StartDate'] `  
whatever intermediate element : AccountingYear|ReportingPeriod  

```

	Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(new File(filepath);
	XPath xpath = XPathFactory.newInstance().newXPath();

	// NodeList version
	NodeList nodes = (NodeList) xpath.compile(//*[local-name() = 'AssessmentYear']).evaluate(doc,XPathConstants.NODESET);
	for (int i = 0; i < nodes.getLength(); i++) {
		Node node = nodes.item(i);
		assessmentYear = node.getTextContent();
	}

	// SingleNode version
	Node node = (Node) xpath.compile(//*[local-name() = 'AssessmentYear']).evaluate(doc, XPathConstants.NODE);
	assessmentYear = node.getTextContent();
```

## PDF : workaround for html2pdf to download pdf : Base64  

http://localhost:8080/api/pdf/get/html/base64/
```
src/main/java/sandbox/rest/resource/PdfResource.java :
	@POST
	@Path("get/html/base64/{filename}")
	@Produces(MediaType.TEXT_PLAIN + ";charset=utf-8")
	public Response getPdfBase64FromHtml(String html, @PathParam("filename") String filename)
	[...]
	return Response.ok(
		Base64.getEncoder().encodeToString(baos.toByteArray()).toString(), 
		MediaType.TEXT_PLAIN)
		.build();
```

src/main/webapp/testHtml2pdf.html :
```
[...]
$.ajax(settings)
	.done(function (response) {
		var anchor = document.createElement("a"); //Create anchor <a>
		anchor.href = "data:application/pdf;base64," + response; // Pdf in Base64
		anchor.download = filename;
		anchor.click(); // trigger file download			
		anchor.remove();
```

## Duration  
```
Instant start = Instant.now();
System.out.println("Start :" + DateTimeFormatter.ofLocalizedDateTime(FormatStyle.SHORT).withLocale(Locale.FRENCH).withZone(ZoneOffset.UTC).format(start));

try {
	Thread.sleep(1000);
} catch (InterruptedException e) {
	e.printStackTrace();
}

Instant two = Instant.now();

System.out.println("Stop  :" + DateTimeFormatter.ofLocalizedDateTime(FormatStyle.SHORT).withLocale(Locale.FRENCH).withZone(ZoneOffset.UTC).format(two));
Duration res = Duration.between(one, two);
System.out.println("Duration : " + res.toMinutesPart() + " min " + res.toSecondsPart() + " s");
```

## Clob and charset
```
myClob = new javax.sql.rowset.serial.SerialClob(myString.getBytes("ISO-8859-1").toCharArray());
myClob = new javax.sql.rowset.serial.SerialClob(myString.getBytes("UTR-8").toCharArray());
```

---
## Log4j

Filter log... to skip noisy messages  

src/main/resources/log4j.xml :  
```
<log4j:configuration>[...]
	<appender>[...]
	    <layout/>
		# filter type 1
	    	<filter class="org.apache.log4j.filter.ExpressionFilter">
	    		<param name="expression" value="MSG LIKE '.*t read cell.*'" />
            		<param name="acceptOnMatch" value="false"/>
        	</filter>
 	    	# filter type 2 
	    	<filter class="org.apache.log4j.varia.StringMatchFilter">
		    <param name="StringToMatch" value="Can't read cell" />
		    <param name="acceptOnMatch" value="false"/>
        	</filter>
			# filter not a soluce ;-)
			<filter class="org.apache.log4j.varia.DenyAllFilter"/> -->
	</appender>
[...]
```

---

## Maven password

Encrypt password :  
`$ mvn --encrypt-password newpass`  > settings.xml 


---

## Jetty

Remote debug with mvn jetty:run  

`MAVEN_OPTS="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n" && mvn jetty:run | tee log/debug.log`  

Embedded jetty : Fix "favicon.ico 404" in browser  

src/main/webapp/favicon.ico

How to kill running jetty on port 8080  
```
> netstat -ano | grep 8080 | grep LISTENING
> taskkill /F /PID 1234
```

## Eclipse  

Eclipse: Java was started but returned error code=13  
Remove in environement PATH : "C:\Program Files (x86)\Common Files\Oracle\Java\javapath"  

[Debug mode - eclipse-weblogic](https://stackoverflow.com/questions/26104666/how-to-debug-java-web-application-in-eclips-with-weblogic-server)  

startWeblogic.cmd :  
`set JAVA_OPTIONS=-Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,address=8453,server=y,suspend=n ` 
Eclipse (mode debug) :  
Run -> Debug Configurations -> Remote Java Application  
	Host : localhost  
	Port : 8453  
	-> Click Debug   


## Tomcat  

Tomcat 7 does not start anymore... ?  
> Install Tomcat 9  
Source of new problem : conflicting port for shutdown !!!  
D:\tools\DEV\SERVER\apache-tomcat-9.0.30\conf\server.xml :  
```
<Server port="8005" shutdown="SHUTDOWN">
to
<Server port="8006" shutdown="SHUTDOWN">
# idem for Tomcat 7 + set environement
D:\tools\DEV\SERVER\apache-tomcat-7.0.70\bin\startup.bat :
	setlocal
	SET CATALINA_HOME=D:\tools\DEV\SERVER\apache-tomcat-7.0.70
	SET CATALINA_BASE=D:\tools\DEV\SERVER\apache-tomcat-7.0.70
	SET CATALINA_TMPDIR=D:\tools\DEV\SERVER\apache-tomcat-7.0.70\temp
	SET JAVA_HOME==C:\Program Files\Java\jdk1.7.0_80
	SET JRE_HOME=C:\Program Files\Java\jdk1.7.0_80\jre
```

## Hibernate Tools Maven Plugin

[github](https://github.com/hibernate/hibernate-tools/blob/main/maven/README.md)  
hbm2ddl  
hbm2java  

