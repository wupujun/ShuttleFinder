package BusFinder;



import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlAccessType;

import org.apache.derby.client.am.DateTime;

@XmlRootElement


public class Location {

	private String latitude;
	private String longitude;
	private String userID;
	private String time;
	
	//getter&setter
	public String getLatitude() {
		return latitude;
	}
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
	public String getLongitude() {
		return longitude;
	}
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getTime() {
		return time;
	}
	public void setTime(String timeString) {
		this.time = timeString;
	}
	
}
