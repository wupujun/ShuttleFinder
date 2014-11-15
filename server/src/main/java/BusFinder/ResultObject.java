package BusFinder;


import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlAccessType;

@XmlRootElement

public class ResultObject {

public enum STATUS {OK,ERROR};
public enum DATATYPE {OBJECT, ARRAY,MAP,NULL};

public STATUS status;
public DATATYPE dataType;
public String errorMsg;
public Object returnObject;

public ResultObject() {
	status=STATUS.OK;
	dataType=DATATYPE.OBJECT;
	errorMsg="OK";
}

}
