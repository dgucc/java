<<<<<<< HEAD
package sandbox.rest.test;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



@Path("test")
public class TestResource {
	
	private static Logger logger = LoggerFactory.getLogger(TestResource.class.getName());
	
	@GET
	@Path("hello/{name : (.*)}")
	@Produces(MediaType.TEXT_PLAIN +";charset=utf-8")
	public String hello(@PathParam("name") String name) {
		logger.info("/rest/test/hello : Hello " + name);
		return "Hello " + name;
	}
}
=======
package sandbox.rest.test;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



@Path("test")
public class TestResource {
	
	private static Logger logger = LoggerFactory.getLogger(TestResource.class.getName());
	
	@GET
	@Path("hello/{name : (.*)}")
	@Produces(MediaType.TEXT_PLAIN +";charset=utf-8")
	public String hello(@PathParam("name") String name) {
		logger.info("/rest/test/hello : Hello " + name);
		return "Hello " + name;
	}
}
>>>>>>> f2f25fa45ccf07b2579467ac1b4b42e9116453f8
