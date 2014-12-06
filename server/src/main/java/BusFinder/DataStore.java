package BusFinder;

import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlAccessType;






//import net.sf.json.*;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;  
import com.google.gson.JsonArray;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import com.google.gson.reflect.TypeToken; 

@XmlRootElement




public class DataStore {
	static final private String saveFile="./BusStore.txt";
	static final private String busLineMapTag="busLineMap";
	static final private String userMapTag="userMap";
	static final private String stopMapTag="stopMap";
	
	
	public static class DataStoreSerializer implements JsonSerializer<DataStore>,JsonDeserializer<DataStore> {
	    public JsonElement serialize(final DataStore person, final Type type, final JsonSerializationContext context) {
	        JsonObject result = new JsonObject();
	        
	        HashMap<String, BusLine> busLineMap= DataStore.instance().getBuslinesMap();
	        HashMap<String,User> userMap=DataStore.instance().getUsers();
	        HashMap<String,TreeMap<String,BusStops> > stopMap=DataStore.instance().getStopMap();
	        
	        Gson gson1= new Gson();
	        JsonElement busLineJson=gson1.toJsonTree(busLineMap, new TypeToken<Map<String, BusLine>>() {  
	        }.getType());
	        //String busLineMapTxt=gson1.toJson(busLineMap, new TypeToken<Map<String, BusLine>>() {  
            //}.getType());
	        
	        
	        Gson gson2= new Gson();
	        //String userMapTxt=gson2.toJson(userMap, userMap.getClass());
	        JsonElement userMapJson= gson2.toJsonTree(userMap, new TypeToken<Map<String, User>>() {  
	            }.getType());
	        
	        Gson gson3= new Gson();
	        //String userMapTxt=gson2.toJson(userMap, userMap.getClass());
	        JsonElement stopMapJson= gson3.toJsonTree(stopMap, new TypeToken<Map<String, TreeMap<String,BusStops> >>() {  
	            }.getType());

	        
	 	    //gson2.to    
	        result.add(busLineMapTag, busLineJson );        
	        result.add(userMapTag, userMapJson );
	        result.add(stopMapTag,stopMapJson);
	        
	   
	        return result;
	    }

		@Override
		public DataStore deserialize(JsonElement json, Type typeOfT,
				JsonDeserializationContext context) throws JsonParseException {
			// TODO Auto-generated method stub
			DataStore store= new DataStore();
			
			if (json.isJsonObject()) {
				JsonObject obj= json.getAsJsonObject();
				JsonElement busLineObj=obj.get(busLineMapTag);
				JsonElement userObj=obj.get(userMapTag);
				JsonElement stopMapObj=obj.get(stopMapTag);
				
				
				
				
				Gson lineMapGson=new Gson();
				store.buslinesMap=lineMapGson.fromJson(busLineObj,
				
						new TypeToken<Map<String, BusLine>>() {}.getType()
						);

				Gson userMapGson=new Gson();
				store.userMap=userMapGson.fromJson(userObj,
						new TypeToken<Map<String, User>>() {}.getType()
						);
				
				Gson stopMapGson=new Gson();
				store.stopMap=userMapGson.fromJson(stopMapObj,
						new TypeToken<Map<String, TreeMap<String,BusStops> >>() {}.getType()
						);
				
				if (store.userMap==null) store.userMap= new HashMap<String,User>();
				if (store.buslinesMap==null) store.buslinesMap= new HashMap<String,BusLine>();
				if (store.stopMap==null) store.stopMap= new HashMap<String, TreeMap<String,BusStops> >();
				
			}
			//store.buslinesMap= gson.fromJson(json, classOfT)
		            
			return store;
		}

	}
	
	private DataStore(){
		
		this.buslinesMap= new HashMap<String,BusLine>();
		this.userMap= new HashMap<String,User>();
		this.locationMap= new HashMap<String,ArrayList<Location>>();
		this.stopMap= new HashMap<String,TreeMap<String,BusStops>>();
	}
	
	private static DataStore instance=null;
	
	public static DataStore instance() {
		if (instance==null) 
		{
			instance= new DataStore();
		}
		
		return instance;
	}
	
	
	
	
	//serilize 
	public static int save() {
		
		DataStore aStore=instance();
		
		//JSONObject obj=JSONObject.fromObject(aStore);
		
		Gson gson = new GsonBuilder().registerTypeAdapter(DataStore.class, new DataStoreSerializer())
	            .create();

		
		String content=gson.toJson(instance).toString();
		
		FileWriter fw;
		try {
			
			
			System.out.println("save string="+ content);
			fw = new FileWriter(saveFile);
			fw.write(content);
			fw.flush();
			fw.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		
		return content.length();	
	}
	
	public static int load() {

	        File file = new File(saveFile);
	        int size=0;

	        try {

	            
	            String content = FileUtils.readFileToString(file);
	            System.out.println(content);
	            
	            Gson gson = new GsonBuilder().registerTypeAdapter(DataStore.class, new DataStoreSerializer())
	    	            .create();
	            instance=gson.fromJson(content, DataStore.class);
	            
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	        //System.out.println(txt);
	        
		return size;
	}
	
	public void clear() {
		instance.setBuslinesMap(new HashMap<String,BusLine>() );
		instance.setUsers(new HashMap<String,User>() );
		instance.setLocationMap(new HashMap<String,ArrayList<Location> >() );
	}
	
	//getter&setter
	
	public HashMap<String,User> getUsers() {
		return userMap;
	}



	public void setUsers(HashMap<String,User> users) {
		this.userMap = users;
	}

	public HashMap<String,BusLine> getBuslinesMap() {
		return buslinesMap;
	}



	public void setBuslinesMap(HashMap<String,BusLine> buslinesMap) {
		this.buslinesMap = buslinesMap;
	}
	
	

	//data accessor
	private HashMap<String,User> userMap= new HashMap<String,User>();
	private HashMap<String,BusLine> buslinesMap = new HashMap<String,BusLine>();
	//private ArrayList<Location> locations= new ArrayList<Location>();
	private HashMap<String,ArrayList<Location>> locationMap= new HashMap<String,ArrayList<Location>> ();
	private HashMap<String,TreeMap<String,BusStops>> stopMap= new HashMap<String,TreeMap<String,BusStops>>();
	//test method
	static void main()
	{

		
	}



	public HashMap<String,ArrayList<Location>> getLocationMap() {
		return locationMap;
	}

	public HashMap<String,TreeMap<String,BusStops>> getStopMap() {
		return stopMap;
	}



	public void setLocationMap(HashMap<String,ArrayList<Location>> locationMap) {
		this.locationMap = locationMap;
	}
}
