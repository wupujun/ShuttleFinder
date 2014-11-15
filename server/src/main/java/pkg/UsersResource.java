package pkg;

import BusFinder.*;

import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.UriBuilder;
import javax.ws.rs.core.UriInfo;



//import org.codehaus.jettison.json.JSONArray;
//import org.codehaus.jettison.json.JSONObject;

//import net.sf.json.JSONArray;
//import net.sf.json.JSONObject;

@Path("/users/")

public class UsersResource {
   @Context UriInfo uriInfo;
   
   private HashMap<String,User> userMap= DataStore.instance().getUsers();


 @GET
     @Produces("application/json")
     //@Produces({MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
     public ResultObject getUsers() {
     
	 
	 ResultObject result= new ResultObject();
	 List<User> userList = new ArrayList<User>();
	 userList.addAll(userMap.values());
	 
	 result.dataType=ResultObject.DATATYPE.ARRAY;
	 result.returnObject=userList;
	 result.status=ResultObject.STATUS.OK;
	 
     return result;
}
 
 
 @POST
 @Produces(MediaType.TEXT_HTML)
 @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
 public void newUser(
		   @FormParam("id") String id,
		   @FormParam("name") String name,
		   @FormParam("busline") String busLine,
		   @Context HttpServletResponse response
		   ) throws IOException 
		   {
	 			User aUser=new User();
	 			aUser.setId(id);
	 			aUser.setName(name);
	 			aUser.setBusLine(busLine);
	 			userMap.put(id, aUser);
		   }
		   
}
