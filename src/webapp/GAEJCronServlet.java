package webapp;

import java.io.IOException;
import java.util.logging.Logger;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;

import javax.servlet.ServletException;
import javax.servlet.http.*;

import java.util.List;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

@SuppressWarnings("serial")
public class GAEJCronServlet extends HttpServlet {
	

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
        String msgBody = "This is a test mail you should be getting";
		
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			Query query = new Query("Email");
			
			
			List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(20));
			for(Entity greeting:greetings){
		      String to = (String) greeting.getProperty("email");

		      //TODO
		      //enter email id
		      String from = "sonal.jain@utexas.edu";

		      String host = "smtp.gmail.com";

		      Properties properties = System.getProperties();

		      properties.setProperty("mail.smtp.host", host);

		      Session session = Session.getDefaultInstance(properties);
		      
		         MimeMessage message = new MimeMessage(session);

		         message.setFrom(new InternetAddress(from));

		         message.addRecipient(Message.RecipientType.TO,
		                                  new InternetAddress(to));

		         //TODO 
		         //set the subject
		         message.setSubject("This is the Subject Line!");
		         
		         //TODO
		         //set the message
		         message.setText("This is actual message");


		         Transport.send(message);
		         
		         
			}

		}
		catch(AddressException e) {
		
		}
		catch(MessagingException e) {

		}
		catch (Exception ex) {

		}
	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
	
}
