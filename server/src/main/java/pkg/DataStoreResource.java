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

@Path("/datastore/")

public class DataStoreResource {

	 
	   
	 @GET
     @Produces("application/json")
     //@Produces({MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
     public ResultObject getDataStore() {
     
		 
	 ResultObject result= new ResultObject();

	 result.dataType=ResultObject.DATATYPE.ARRAY;
	 result.returnObject=DataStore.instance();
	 result.status=ResultObject.STATUS.OK;
	 
     return result;

	 }
	 
	 
	 @POST
	 @Produces("application/json")
	 @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	 public ResultObject execute(
			   @FormParam("cmd") String cmd,
			   @Context HttpServletResponse response
			   ) throws IOException 
			   {
		 			
		 			if (0==cmd.compareTo("delete")) {
		 				DataStore.instance().clear();
		 			}
		 			ResultObject result= new ResultObject();

		 			result.dataType=ResultObject.DATATYPE.ARRAY;
		 			result.returnObject= new String("Exec command is sucessful,cmd="+cmd );
		 			result.status=ResultObject.STATUS.OK;
		 			 
		 		    return result;

			   }

}
