package bus;


import org.junit.*;  

import static junit.framework.Assert.*;  

import java.lang.reflect.Type;
import java.util.HashMap;

import BusFinder.BusLine;
import BusFinder.DataStore;
import BusFinder.User;


public class TestDataStore {	

	@Test
	public void testDataStore() {
		// TODO Auto-generated method stub
		HashMap<String,User> userMap= new HashMap<String,User>();
		User user1= new User();
		user1.setId("user_id1");
		user1.setName("user_name1");
		
		userMap.put("1", user1);
		userMap.put("2", new User());
		userMap.put("3", new User());
		
		HashMap<String,BusLine> busLines = new HashMap<String,BusLine>();
		BusLine line1= new BusLine();
		line1.driverName="driver1";
		line1.driverNo="driverNo1";
		line1.lineName="Line No.1";
		busLines.put("line1", line1);
		busLines.put("line2", new BusLine());
		
		DataStore.instance().setUsers(userMap);
		DataStore.instance().setBuslinesMap(busLines);
		
		int saveSize= DataStore.save();
		//Assert.assertTrue("saved string size >0", saveSize>0);
		
		DataStore.instance().clear();
		
		int loadSize= DataStore.load();
		//Assert.assertTrue("loaded string size >0", loadSize>0);
		
		Assert.assertTrue(DataStore.instance().getBuslinesMap().size()==2);
		Assert.assertTrue(DataStore.instance().getUsers().size()==3);	
				
		String lineClass=DataStore.instance().getBuslinesMap().get("line1").getClass().toString();
		String userClass=DataStore.instance().getUsers().get("1").getClass().toString();
		
		System.out.println("LineClass="+lineClass+",userClass="+userClass);
		Assert.assertTrue(DataStore.instance().getUsers().size()==3);	
		
		
	}

}
