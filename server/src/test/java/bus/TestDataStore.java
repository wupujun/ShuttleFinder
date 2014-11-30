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
		line1.busLine= "busline1";
		line1.driver = "陈师傅";
		line1.license = "京NB001";
		line1.phone="13810001234";
		line1.seatCount=40;

		BusLine line2= new BusLine();
		line2.busLine="busline1";
		line2.driver="李师傅";
		line2.license="京NB002";
		line2.phone="18610001234";
		line2.seatCount=39;

		
		busLines.put("busline1", line1);
		busLines.put("busline2", line2);
		
		DataStore.instance().setUsers(userMap);
		DataStore.instance().setBuslinesMap(busLines);
		
		int saveSize= DataStore.save();
		//Assert.assertTrue("saved string size >0", saveSize>0);
		
		DataStore.instance().clear();
		
		int loadSize= DataStore.load();
		//Assert.assertTrue("loaded string size >0", loadSize>0);
		
		Assert.assertTrue(DataStore.instance().getBuslinesMap().size()==2);
		Assert.assertTrue(DataStore.instance().getUsers().size()==3);	
				
		String lineClass=DataStore.instance().getBuslinesMap().get("busline1").getClass().toString();
		String userClass=DataStore.instance().getUsers().get("1").getClass().toString();
		
		System.out.println("LineClass="+lineClass+",userClass="+userClass);
		Assert.assertTrue(DataStore.instance().getUsers().size()==3);	
		
		
	}

}
