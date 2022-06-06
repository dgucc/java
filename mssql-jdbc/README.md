# How to connect to Microsoft SQL Server in java


## MSSQL in docker

```bash
$ sudo service docker start  
$ docker run -itd --rm --name='sql1' --hostname='sql1' -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=SA_password' -p 1433:1433 -v $HOME/workspace/docker/mssql/data:/var/opt/mssql/data mcr.microsoft.com/mssql/server:2017-latest  

```

## POM.XML

Driver mssql-jdbc  

```xml
<dependency>
	<groupId>com.microsoft.sqlserver</groupId>
	<artifactId>mssql-jdbc</artifactId>
	<version>8.2.1.jre11</version>
</dependency>

```

## JAVA
  

```java
public static void main(String[] args) {

	Connection conn = null;

	try {

		String dbURL = "jdbc:sqlserver://localhost:1433";
		String user = "SA";
		String pass = "SA_password";
		conn = DriverManager.getConnection(dbURL, user, pass);
		if (conn != null) {
			DatabaseMetaData dm = (DatabaseMetaData) conn.getMetaData();
			System.out.println("Driver name: " + dm.getDriverName());
			System.out.println("Driver version: " + dm.getDriverVersion());
			System.out.println("Product name: " + dm.getDatabaseProductName());
			System.out.println("Product version: " + dm.getDatabaseProductVersion());
		}

	} catch (SQLException ex) {
		ex.printStackTrace();
	} finally {
		try {
			if (conn != null && !conn.isClosed()) {
				conn.close();
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
	}
}
```

Output :  

> Driver name: Microsoft JDBC Driver 8.2 for SQL Server  
> Driver version: 8.2.1.0  
> Product name: Microsoft SQL Server  
> Product version: 14.00.3436  
