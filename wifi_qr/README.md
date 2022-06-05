# Generate Wi-Fi QR-Code 

Prepare java project with maven :

```
$ mvn archetype:generate -DgroupId=example.com -DartifactId=qr-code -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false  
$ cd qr-code
```

Add zxing dependencies in the pom.xml :

```
	<!-- zxing -->
	<dependency>
	  <groupId>com.google.zxing</groupId>
	  <artifactId>core</artifactId>
	  <version>3.3.0</version>
	</dependency>

	<dependency>
	  <groupId>com.google.zxing</groupId>
	  <artifactId>javase</artifactId>
	  <version>3.3.0</version>
	</dependency>
```

`$ mvn clean install eclipse:eclipse` 

Java sample to generate a Wi-Fi QR-Code (png)  

> src/main/java/com/example/App.java  

Compile and execute  

`$ mvn clean compile`  

`$ mvn exec:java -Dexec.mainClass="com.example.App"` 

Look at the generated QR-Code "WIFI-SSID.png"  

Scan the QR-Code with your smartphone to connect the related Wi-Fi  
> 'WIFI:S:WIFI-SSID;T:WPA;P:WIFI-PASSWORD;H:false;;'  

