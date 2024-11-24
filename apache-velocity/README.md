
# Velocity 

Velocity is a Java-based templating engine.


## Setup project

```bash
$ mvn archetype:generate -DgroupId=sandbox -DartifactId=apache-velocity -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
$ cd apache-velocity/
$ mkdir -p src/main/resources/vm
```
```xml
<dependency>
  <groupId>junit</groupId>
  <artifactId>junit</artifactId>
  <version>3.8.1</version>
  <scope>test</scope>
</dependency>
<dependency>
  <groupId>org.apache.velocity</groupId>
  <artifactId>velocity</artifactId>
  <version>1.7</version>
</dependency>
<dependency>
  <groupId>org.apache.velocity</groupId>
  <artifactId>velocity-tools</artifactId>
  <version>2.0</version>
</dependency>
```

## Define Model to merge with the Velocity Template

Model :  
- src/main/java/sandbox/model/Report.java  
- src/main/java/sandbox/model/EnumStatus.java  
- src/main/java/sandbox/model/Member.java  

Template :  
- src/main/resources/vm/mailBody.vm  

```html
<!DOCTYPE html>
<html>
<meta charset="utf-8">
<body>
#if($body.status == "ERROR")
    <h1>Error : Data not ready...</h1>
#else
    <h1>List of members</h1>
    <table>
    <thead>
        <tr>
            <th align="right">id</th>
            <th>name</th>
        </tr>
    </thead>
    <tbody>
#foreach($member in $body.members)
        <tr>
            <td align="right">$member.id</td>
            <td>$member.name</td>
        </tr>
#end 
    </tbody>
    </table>
#end

</body>
</html>
```

Execute :  

`$ mvn exec:java -Dexec.mainClass=sandbox.App`  

```java
public static void main(String[] args) {
     VelocityEngine velocityEngine = new VelocityEngine();
        velocityEngine.init();

        Template template = velocityEngine.getTemplate("src/main/resources/vm/mailBody.vm");
        VelocityContext context = new VelocityContext();

        // Populate Data 
        Report mail = new Report();        
        mail.setStatus(EnumStatus.READY);
        List<Member> list = new ArrayList<>();
        list.add(new Member(1, "Damien"));        
        list.add(new Member(2, "Céline"));
        list.add(new Member(3, "Amaury"));
        mail.setMembers(list);

        context.put("body", mail);

        StringWriter writer = new StringWriter();
        template.merge(context, writer);

        System.out.println(writer.toString());
}
```

Result :  

```html
<!DOCTYPE html>
<html>
<meta charset="utf-8">
<body>
    <h1>List of members</h1>
    <table>
    <thead>
        <tr>
            <th align="right">id</th>
            <th>name</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td align="right">1</td>
            <td>Damien</td>
        </tr>
        <tr>
            <td align="right">2</td>
            <td>Céline</td>
        </tr>
        <tr>
            <td align="right">3</td>
            <td>Amaury</td>
        </tr>
    </tbody>
    </table>

</body>
</html>
```

Or

```html 
<!DOCTYPE html>
<html>
<meta charset="utf-8">
<body>
    <h1>Error : Data not ready...</h1>

</body>
</html>
---

## Reference 

[Apache Velocity Tutorial](https://www.javaguides.net/2019/11/apache-velocity-tutorial.html)
