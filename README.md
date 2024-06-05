# java

![Avatar](https://github.com/dgucc/sandbox/blob/main/tips/images/avatar.gif)  

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

---

## Wi-Fi QR-Code

Sample to generate QRCode for WiFi  

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

