package pkg;

import BusFinder.*;

import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.SortedMap;
import java.util.TreeMap;

import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.UriBuilder;
import javax.ws.rs.core.UriInfo;

@Path("/stops/")
public class BusStopResource {

	@GET
	@Produces("application/json")
	// @Produces({MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
	public ResultObject getStops(

	@QueryParam("line") String lineID) {

		ResultObject result = new ResultObject();
		TreeMap<String, BusStops> stops = DataStore.instance().getStopMap()
				.get(lineID);

		if (stops != null) {

			result.dataType = ResultObject.DATATYPE.ARRAY;
			result.returnObject = stops.values().toArray();
			result.status = ResultObject.STATUS.OK;
		} else {
			result.dataType = ResultObject.DATATYPE.OBJECT;
			result.errorMsg = "Can't find line:" + lineID;
			result.status = ResultObject.STATUS.ERROR;

		}

		return result;
	}

	@POST
	@Produces(MediaType.TEXT_HTML)
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public void newBusStop(@FormParam("line") String line,
			@FormParam("name") String name, @FormParam("time") String time,
			@FormParam("latitude") double latitude,
			@FormParam("longitude") double longitude,
			@Context HttpServletResponse response) throws IOException {
		HashMap<String, TreeMap<String, BusStops>> stopMap = DataStore
				.instance().getStopMap();
		SortedMap<String, BusStops> stops = stopMap.get(line);
		if (stops == null) {
			stopMap.put(line, new TreeMap<String, BusStops>());
		}
		stops = stopMap.get(line);

		BusStops aStop = new BusStops();
		aStop.line = line;
		aStop.name = name;
		aStop.latitude = latitude;
		aStop.longitude = longitude;
		aStop.time = time;

		stops.put(time, aStop);

	}

}