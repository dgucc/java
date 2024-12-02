# Validate a JAXB Object Model With an XML Schema 

[validate-jaxb-object-against-xsd](http://blog.bdoughan.com/2010/11/validate-jaxb-object-model-with-xml.html)  

## Create Project
`$ mvn archetype:generate -DgroupId=minfin -DartifactId=jaxb-validate-xsd -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false` 

```xml
<dependency>
	<groupId>javax.xml.bind</groupId>
	<artifactId>jaxb-api</artifactId>
	<version>2.3.1</version>
</dependency>
<dependency>
	<groupId>com.sun.xml.bind</groupId>
	<artifactId>jaxb-impl</artifactId>
	<version>2.3.4</version>
</dependency>
<dependency>
	<groupId>org.glassfish.jaxb</groupId>
	<artifactId>jaxb-runtime</artifactId>
	<version>4.0.0</version>
</dependency>
```

## Migrate from javax.xml to jakarta.xml

GroupId : javax.xml.bind -> jakarta.xml.bind  
ArtifactId : javax.xml.bind -> jakarta.xml.bind-api  

GroupId: com.sun.xml.bind -> org.glassfish.jaxb  
ArtifactId: jaxb-impl -> jaxb-runtime  

Rename package name  
import javax.xml.bind -> jakarta.xml.bind  

## Customize SAXParseException message 
https://visionplaymedia.netlify.app/blog/2020-06-25-custom-error-handler-while-validating-xml-against-xsd-schema/  


## Execute   
```
$ mvn clean compile
$ mvn exec:java -Dexec.mainClass="minfin.App"
```

> Output
*** Started ***
ERROR: cvc-maxLength-valid: Value 'Jane Doe' with length = '8' is not facet-valid with respect to maxLength '5' for type 'stringMaxSize5'.
ERROR: cvc-type.3.1.3: The value 'Jane Doe' of element 'name' is not valid.
ERROR: cvc-complex-type.2.4.f: 'phone-number' can occur a maximum of '2' times in the current sequence. This limit was exceeded. No child element is expected at this point.
*** Terminated ***

-----------------

## Misc
### Migrate from javax.xml to jakarta.xml with OpenRewrite

- Try to refactor with OpenRewrite : https://docs.openrewrite.org/recipes/java/migrate/jakarta/javaxxmlbindmigrationtojakartaxmlbind  

```xml
<build>
    <plugins>
      <plugin>
        <groupId>org.openrewrite.maven</groupId>
        <artifactId>rewrite-maven-plugin</artifactId>
        <version>5.46.0</version>
        <configuration>
          <exportDatatables>true</exportDatatables>
          <activeRecipes>
            <recipe>org.openrewrite.java.migrate.jakarta.JavaxXmlBindMigrationToJakartaXmlBind</recipe>
          </activeRecipes>
        </configuration>
        <dependencies>
          <dependency>
            <groupId>org.openrewrite.recipe</groupId>
            <artifactId>rewrite-migrate-java</artifactId>
            <version>2.30.0</version>
          </dependency>
        </dependencies>
      </plugin>
    </plugins>
  </build>
```
`$ mvn rewrite:run`

 OR   

`mvn -U org.openrewrite.maven:rewrite-maven-plugin:run -Drewrite.recipeArtifactCoordinates=org.openrewrite.recipe:rewrite-migrate-java:RELEASE -Drewrite.activeRecipes=org.openrewrite.java.migrate.jakarta.JavaxXmlBindMigrationToJakartaXmlBind -Drewrite.exportDatatables=true`  

