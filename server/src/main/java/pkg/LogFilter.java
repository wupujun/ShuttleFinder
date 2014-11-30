package pkg;



import java.io.IOException;
import java.util.Date;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

/**
 * @author BigBird
 * @date 2011-12-6 下午11:07:41
 * @action
 */
import BusFinder.*;

public class LogFilter implements Filter {

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		// add code to release any resource
		int len=DataStore.save();
		System.out.println("Destory, save bypes="+ len);
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res,
			FilterChain chain) throws IOException, ServletException {
		// TODO Auto-generated method stub
		//HttpServletRequest request = (HttpServletRequest) req;
		// Get the IP address of client machine
		//String ipAddress = request.getRemoteAddr();
		// Log the IP address and current timestamp
		//System.out
		//	.println("IP " + ipAddress + ",Time " + new Date().toString());
		
		chain.doFilter(req,res);
	}

	@Override
	public void init(FilterConfig config) throws ServletException {
		// TODO Auto-generated method stub
		// Get init parameter
		String testParam = config.getInitParameter("test-param");
		// Print the init parameter
		System.out.println("Test Param:" + testParam);
		int len=DataStore.load();
		System.out.println("load file, len=" + len);
	}

}
