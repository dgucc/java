package sandbox.rest.test;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.log4j.Logger;

@Path("test")
public class TestResource {
	private static Logger logger = Logger.getLogger(TestResource.class.getName());
	@GET
	@Path("hello/{name : (.*)}")
	@Produces(MediaType.TEXT_PLAIN +";charset=utf-8")
	public String hello(@PathParam("name") String name) {
		logger.info("Hello "+ name);
		return "Hello " + name;
	}
}
