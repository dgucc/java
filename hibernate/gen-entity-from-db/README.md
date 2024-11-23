# Generate Entities from DB [Java 17]

[References](https://github.com/hibernate/hibernate-tools/blob/main/maven/docs/5-minute-tutorial.md)  

 - java.version : 17  
 - hibernate.version : 6.5.2.Final  
 - db2.version : 9.7FP6  

## Create project with maven
```shell
$ mvn archetype:generate -DgroupId=sandbox -DartifactId=hibernate-tools-test -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false` 

$ cd hibernate-tools-test/
$ mkdir -p src/main/resources && mkdir -p log
```


## hibernate.properties

Connections parameters  
src\main\resources\hibernate.properties :  
```properties
hibernate.connection.driver_class=com.ibm.db2.jcc.DB2Driver
hibernate.connection.url=jdbc:db2://localhost:50000/DBTEST
hibernate.connection.username=user
hibernate.connection.password=password
hibernate.default_schema=DBTEST
hibernate.default_catalog=
hibernate.connection.autocommit=true
#hibernate.dialect=org.hibernate.dialect.DB2Dialect

```

## Customize hibernate reverse engineering   
src\main\resources\hibernate.reveng.xml :
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-reverse-engineering SYSTEM "https://hibernate.org/dtd/hibernate-reverse-engineering-3.0.dtd" >

<hibernate-reverse-engineering>

	<schema-selection match-schema="DBTEST" match-table=".*" />

	<type-mapping>
		<sql-type jdbc-type="INTEGER" not-null="true" hibernate-type="integer" />
		<sql-type jdbc-type="INTEGER" not-null="false" hibernate-type="java.lang.Integer" />

		<!-- <sql-type jdbc-type="CHAR" not-null="false" hibernate-type="java.lang.Character" />
		<sql-type jdbc-type="CHAR" not-null="true" hibernate-type="character" /> -->
		<sql-type jdbc-type="CHAR" hibernate-type="string" />
		<sql-type jdbc-type="VARCHAR" hibernate-type="string" />

		<sql-type jdbc-type="DATE" hibernate-type="java.time.LocalDate"/>
      <sql-type jdbc-type="TIMESTAMP" hibernate-type="java.time.LocalDateTime"/>
		
	</type-mapping>
	
	<table-filter match-name="BULLSHIT_TABLE" exclude="true" />

	<table-filter match-name=".*"  package="minfin"/>

</hibernate-reverse-engineering>

```


## Customize Annotations Generation

Move annotations from method to field declaration by modifying Templates
src/main/resources/templates/pojo :  
  - Ejb3FieldGetAnnotation.ftl  
  - Pojo.ftl  
  - PojoFields.ftl  
  - PojoPropertyAccessors.ftl  

Make reference to these customized Templates 
pom.xml :  
```xml
<execution>
   ...
   <phase>generate-sources</phase>
   <goals>
      <goal>hbm2java</goal>
   </goals>
   <configuration>
      ...
      <templatePath>${project.basedir}/src/main/resources/templates/</templatePath>
   </configuration>
</execution>
```

## Generate entities "hbm2java"  
`$ mvn clean generate-sources`  

Look for the generated entities in folder  
target\generated-sources\  
or in folder reveng\ (cf. pom.xml)  


