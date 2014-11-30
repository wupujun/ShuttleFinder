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
	 
	 int lastPos= locations.size()-1;
	 int firstPos= (lastPos-10>0)? lastPos-10:0;
	 if (lastPos<0) lastPos=0;
	 
	 List<Location> last10Locations= new ArrayList<Location> (locations.subList(firstPos,lastPos)); 
	 
	 result.dataType=ResultObject.DATATYPE.ARRAY;
	 result.returnObject=last10Locations;
	 result.status=ResultObject.STATUS.OK;
	 
     return result;
}
 
 
 @POST
 @Produces("application/json")
 @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
 public ResultObject newLocation(
		   @FormParam("userID") String userID,
		   @FormParam("latitude") double latitude,
		   @FormParam("longitude") double longitude,
		   @FormParam("altitude") double altitude,
		   @FormParam("time") String time,
		   @FormParam("line") String line,
		   
		   
		   @Context HttpServletResponse response
		   ) throws IOException 
		   {
	 			ResultObject result= new ResultObject();

	 			
	 			ArrayList<Location> locations=DataStore.instance().getLocationMap().get(line);

	 			Location aLocation=new Location();
	 			aLocation.latitude=latitude;
	 			aLocation.longitude=longitude;
	 			aLocation.userID=userID;
	 			aLocation.altitude=altitude;
	 			aLocation.time=time;
	 			//System.out.println(aLocation.toString());
	 			locations.add(aLocation);
	 			
	 				
	 			result.dataType=ResultObject.DATATYPE.ARRAY;
	 			result.returnObject=locations;

	 			result.dataType=ResultObject.DATATYPE.ARRAY;
	 			result.returnObject=locations;
	 			result.status=ResultObject.STATUS.OK;
	 			
	 			return result;
	 			
		   }
	
	
}
