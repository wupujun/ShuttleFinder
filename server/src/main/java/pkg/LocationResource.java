package pkg;

import BusFinder.*;

import java.io.IOException;
import java.net.URI;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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

import org.apache.derby.client.am.DateTime;

@Path("/locations/")


public class LocationResource {

	
	 @GET
     @Produces("application/json")
     //@Produces({MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
     public ResultObject getLocations() {
     
		 
     
	 ResultObject result= new ResultObject();
	 List<Location> locations = DataStore.instance().getLocations();	 
	 result.dataType=ResultObject.DATATYPE.ARRAY;
	 result.returnObject=locations;
	 result.status=ResultObject.STATUS.OK;
	 
     return result;
}
 
 
 @POST
 @Produces("application/json")
 @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
 public ResultObject newLocation(
		   @FormParam("userID") String userID,
		   @FormParam("Lat") String Lat,
		   @FormParam("Long") String Long,
		   @Context HttpServletResponse response
		   ) throws IOException 
		   {
	 			ResultObject result= new ResultObject();

	 			ArrayList<Location> locations=DataStore.instance().getLocations();
  				Location aLocation=new Location();
	 			aLocation.setLatitude(Lat);
	 			aLocation.setLongitude(Long);
	 			aLocation.setUserID(userID);
	 			
	 			Date nowTime=new Date(); 
	 			System.out.println(nowTime); 
	 			SimpleDateFormat time=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
	 			String timeString=time.format(nowTime); 
	 			
	 			aLocation.setTime(timeString);
	 			locations.add(aLocation);
	 			
	 			
	 		
	 			
	 			result.dataType=ResultObject.DATATYPE.ARRAY;
	 			result.returnObject=locations;

	 			result.dataType=ResultObject.DATATYPE.ARRAY;
	 			result.returnObject=locations;
	 			result.status=ResultObject.STATUS.OK;
	 			
	 			return result;
	 			
		   }
	
	
}
