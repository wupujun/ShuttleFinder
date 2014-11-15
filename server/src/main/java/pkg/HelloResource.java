package pkg;


import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.FormParam;


@Path("/hello")

public class HelloResource {

	private HashMap<String,String> users= new HashMap<String,String>();
	
	   @GET 
	    @Produces("text/plain")
	    public String getIt() {
	        return "Hello World!";
	    }
	   
	   @POST
	   @Produces(MediaType.TEXT_HTML)
	   @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	   public void newUser(
			   @FormParam("id") String id,
			   @FormParam("name") String name,
			   @Context HttpServletResponse response
			   ) throws IOException 
			   {
		   			users.put(id,  name);
			   }
			   

}


