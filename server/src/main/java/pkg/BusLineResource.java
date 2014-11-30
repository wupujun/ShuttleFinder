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

@Path("/buslines/")

public class BusLineResource {

	 
	   
	 @GET
     @Produces("application/json")
     //@Produces({MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
     public ResultObject getLines() {
     
		 
     HashMap<String,BusLine> busLineMap=DataStore.instance().getBuslinesMap();
	 ResultObject result= new ResultObject();
	 List<BusLine> busLines = new ArrayList<BusLine>();
	 busLines.addAll(busLineMap.values());
	 
	 result.dataType=ResultObject.DATATYPE.ARRAY;
	 result.returnObject=busLines;
	 result.status=ResultObject.STATUS.OK;
	 
     return result;
}
 
 
 @POST
 @Produces(MediaType.TEXT_HTML)
 @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
 public void newBusLine(
		   @FormParam("busLine") String busLine,
		   @FormParam("seatCount") Integer seatCount,
		   @FormParam("license") String license,
		   @FormParam("driver") String driver,
		   @FormParam("phone") String phone,
		   @Context HttpServletResponse response
		   ) throws IOException 
		   {
	 			HashMap<String,BusLine> busLineMap=DataStore.instance().getBuslinesMap();
  				BusLine aLine=new BusLine();
	 			aLine.busLine = busLine; 
	 			aLine.driver=driver;
	 			aLine.license=license;
	 			aLine.phone=phone;
	 			aLine.seatCount=seatCount;
	 			
	 			busLineMap.put(busLine, aLine);
	 			
		   }
		   
}
	
