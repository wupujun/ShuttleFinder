package BusFinder;


import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlAccessType;

@XmlRootElement

public class BusStops {
	public String name;
	public String time;
	public String line;
	public double latitude;
	public double longitude;
}
