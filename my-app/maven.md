# Maven

[Maven in 5 Minutes](https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html)  

1. Create project 

`$ mvn archetype:generate -DgroupId=com.example -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false`  

`$ cd my-app`   
`$ mkdir -p src/main/resources`  
`$ mkdir -p log`  


2. POM

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.example</groupId>
  <artifactId>my-app</artifactId>
  <version>1.0-SNAPSHOT</version>

  <name>my-app</name>
  <url>http://www.example.com</url>

  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.release>17</maven.compiler.release>
    <java.version>17</java.version>
  </properties>

  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.11</version>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
    <pluginManagement>
      <plugins>
          <plugin>
              <groupId>org.apache.maven.plugins</groupId>
              <artifactId>maven-compiler-plugin</artifactId>
              <version>3.8.1</version>
          </plugin>
      </plugins>
    </pluginManagement>
    <plugins>
      <plugin>
				<groupId>org.codehaus.mojo</groupId>
				<artifactId>exec-maven-plugin</artifactId>
				<version>3.3.0</version>
				<executions>
					<execution>
						<id>run-app</id>
						<goals>
						<goal>java</goal>
						</goals>
					</execution>
				</executions>
				<configuration>
					<mainClass>com.example.App</mainClass>
				</configuration>
			</plugin>

      </plugins>
  </build>
</project>
```

1. Build and execute

`$ mvn clean compile`  

`$ mvn exec:java -Dexec.mainClass=com.example.App` 

or (if mainClass is defined in pom.xml)   
`$ mvn exec:java`  
