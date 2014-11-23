package bus;

import static org.junit.Assert.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;

import org.junit.Test;

public class TestGetLocations {

	@Test
	public void test()  {
		//fail("Not yet implemented");
		String command = "curl 127.0.0.1:8080/bus/webresources/locations -d 'userID=user1&Lat=39.23&Long=134.343'";
		
		try{
		
			for(int i=0;i<12;i++) {
				Process proc = Runtime.getRuntime().exec(command);
				/*		
				InputStream stderr = proc.getErrorStream();
				InputStreamReader isr = new InputStreamReader(stderr);
				BufferedReader br = new BufferedReader(isr);
				String line = null;
				
				while ((line = br.readLine()) != null) {
				    log.error(line);
				}*/
				
				int exitVal = proc.waitFor();
				System.out.println("Process exitValue: " + exitVal);
			}
			
			String getCommand = "curl 127.0.0.1:8080/bus/webresources/locations";
			Process proc = Runtime.getRuntime().exec(command);
				

			
			int exitVal = proc.waitFor();
//			System.out.println("Process exitValue= " + exitVal + "jsonText="+resultText.toString());

			
		}
		catch(Exception e) {
			
		}
		
	}

}
