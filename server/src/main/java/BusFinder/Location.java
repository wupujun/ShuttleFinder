package BusFinder;



import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlAccessType;

import org.apache.derby.client.am.DateTime;

@XmlRootElement
/*
interface BusLocationInfo : NSObject
{
    double longitude;
    double latitude;
    double altitude;
    NSString* time; // Format: 2011-08-26 05:41:06 +0000
    NSString* userId;
}*/
public class Location {

	public double latitude;
	public double longitude;
	public double altitude;
	public String userID;
	public String time;	
}
