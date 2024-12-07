# hyperjaxb3 and Java 17

from **xsd** generate entities with  
    **jaxb** annotations  
    **jpa** annotations  
    **ddl** create-drop sql

> hyperjaxb3
> java 17
> hsqldb


## Example with a given xsd

- Clean out the xsd file
> src/main/resoures/126-beps13-notification-v1-51.xsd

- Customize jaxb+orm generation (id, table names):  
> src/main/resources/binding.xjb


- To make it work with HSQLDB :  
> src\main\resources\META-INF\orm.xml : Specify PUBLIC as schema Name  
> src\main\resources\persistence-hsqldb.properties :  

```
jakarta.persistence.schema-generation.database.action=drop-and-create
jakarta.persistence.schema-generation.scripts.action=drop-and-create
jakarta.persistence.schema-generation.scripts.create-target=target/test-database-sql/ddl-create.sql
jakarta.persistence.schema-generation.scripts.drop-target=target/test-database-sql/ddl-drop.sql

hibernate.cache.provider_class=org.hibernate.cache.HashtableCacheProvider
hibernate.jdbc.batch_size=0
```

- Retrieve the generated **Persistence Unit Name** :  
> target\generated-sources\xjc\META-INF\persistence.xml  

- Create a EntityManager Accordingly (src/main/java/minfin/App.java) :    

```java
entityManagerFactory = Persistence.createEntityManagerFactory("be.fgov.minfin.beps13.notification.v1_51:oecd.ties.isocbctypes.v1", persistenceProperties);
```
Marshall declaration just after persisting it to see the generated Id's


**Execute**  

`$ mvn clean compile exec:java`  
`$ mvn -Phibernate clean compile exec:java`  

Output :  

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<ns2:Declaration275CBCNOT xmlns="http://beps13.minfin.fgov.be/notification/v1.51" xmlns:ns2="be.fgov.minfin.beps13.entity.notification.v1_51" Id="1">
    <Declarer Id="1">
        <CompanyName>CompanyName</CompanyName>
        <CompanyNumber>1234567890</CompanyNumber>
        <AssessmentYear>2016</AssessmentYear>
        <ReportingPeriod Id="1">
            <StartDate>2014-01-01</StartDate>
            <EndDate>2015-01-01</EndDate>
        </ReportingPeriod>
    </Declarer>
    <UltimateParentCompany Id="1">
        <DistinctParentCompany Id="1">
            <Name>Name</Name>
            <CountryCode>BE</CountryCode>
            <TIN>TIN</TIN>
            <MotherAdres Id="2">
                <Street>Street</Street>
                <Number>Number</Number>
                <PostalCode>PostalCode</PostalCode>
                <City>City</City>
            </MotherAdres>
        </DistinctParentCompany>
    </UltimateParentCompany>
    <IsYourParentCompany>true</IsYourParentCompany>
    <BelgGroupEntITC92 Id="1">
        <BelgGroupEnt Id="1">
            <NoCBC>true</NoCBC>
            <NoAcord>true</NoAcord>
            <Negligence>true</Negligence>
            <EUOther>false</EUOther>
        </BelgGroupEnt>
    </BelgGroupEntITC92>
    <MotherRep Id="1">
        <DistinctReportingCompany Id="1">
            <ReportingEntityName>name</ReportingEntityName>
            <ReportingEntityCountrycode>AI</ReportingEntityCountrycode>
            <ReportingEntityTIN></ReportingEntityTIN>
            <ReportingEntityAdress Id="1">
                <Street>Street</Street>
                <Number>Number</Number>
                <PostalCode>PostalCode</PostalCode>
                <City>City</City>
            </ReportingEntityAdress>
        </DistinctReportingCompany>
    </MotherRep>
</ns2:Declaration275CBCNOT>
```


---
# ChangeLog

- Use hsqldb  
- Customize jaxb-orm generation (binding.xjb)  


---

# Fixes

## javax.persistence.spi::No valid providers found

```xml
<dependency>
   <groupId>org.hibernate</groupId>
   <artifactId>hibernate-core-jakarta</artifactId>
   <version>5.6.9.Final</version>
</dependency>
```
