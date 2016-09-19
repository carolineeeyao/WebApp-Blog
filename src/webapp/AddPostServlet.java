package webapp;
 
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

import javax.servlet.http.*;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
 
public class AddPostServlet extends HttpServlet {
  	private static final Logger log = Logger.getLogger(AddPostServlet.class.getName());
 
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
    	UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        Query getEmail = new Query("Email");
	    List<Entity> emails = datastore.prepare(getEmail).asList(FetchOptions.Builder.withLimit(20));
	      for(Entity email: emails)
	    {
	    	  if(user.getEmail().equals(email.getProperty("email")))
	    	  {
	    		  datastore.delete(email.getKey());
	    	  }
	    }
        resp.sendRedirect("/webapp.jsp");
    }
	
	
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
              throws IOException {
    	UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        Entity greeting = new Entity("Email",user.getEmail());
        greeting.setProperty("email", user.getEmail());
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        datastore.put(greeting);
        
        resp.sendRedirect("/showallposts.jsp");
    }
}