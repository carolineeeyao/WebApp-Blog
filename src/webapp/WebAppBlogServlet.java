
package webapp;
 
import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.http.*;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Text;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Date;

 
public class WebAppBlogServlet extends HttpServlet {
	private static final Logger log = Logger.getLogger(WebAppBlogServlet.class.getName());
 
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
     UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
 
        String guestbookName = req.getParameter("guestbookName");
        Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
        Text content = new Text(req.getParameter("content"));
        
        String name = req.getParameter("postname");
        Date date = new Date();
        Entity greeting = new Entity("Greeting", guestbookKey);
        greeting.setProperty("user", user);
        greeting.setProperty("date", date);
        greeting.setProperty("content", content);
        greeting.setProperty("Name", name);
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        datastore.put(greeting);
        resp.sendRedirect("/webapp.jsp");
        
        
    }

	  	public void doAdd(HttpServletRequest req, HttpServletResponse resp) throws IOException{
  		UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        
        Entity greeting = new Entity(user.getEmail());
                	
        greeting.setProperty("email", user.getEmail());
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        datastore.put(greeting);
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
        
        resp.sendRedirect("/webapp.jsp");
    }
}