<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import ="com.google.appengine.api.datastore.Text" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 
<html>
  <head>
  </head>
 
 <%
    String guestbookName = request.getParameter("guestbookName");
    if (guestbookName == null) {
        guestbookName = "default";
    }
    pageContext.setAttribute("guestbookName", guestbookName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>

	<table>
	<tr>
	<td>
    <form action="/addpost.jsp" method="post">
     <input type="submit" value="Add Post" />
    </form>
    </td>
    <td>
    <form action="/webapp.jsp" method="post">
    <input type="submit" value="Show less" />
    </form>
    </td>

    
   <%
 		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    Query getEmail = new Query("Email");
	    List<Entity> emails = datastore.prepare(getEmail).asList(FetchOptions.Builder.withLimit(20));
 	 
	    boolean inList = false;
   
	    for(Entity email: emails)
	    {
	    	String parsed = (String) email.getProperty("email");
	    	if(parsed.equals(user.getEmail()))
	    		inList=true;
	    }
	
	    if(!inList){
%>   
		<td>
	    <form action="/showall" method="get">
	    <input type="submit" value="Suscribe" />
	    </form>
	    </td>
	        <td>
		<form action="/shareposts.jsp" method="post">
	    <input type="submit" value="Share" />
	    </form>

<%	 
		}else{
%>
   		<td>
	    <form action="/showall" method="post">
	    <input type="submit" value="Unsuscribe" />
	    </form>
	    </td>
	        <td>
		<form action="/shareposts.jsp" method="post">
	    <input type="submit" value="Share" />
	    </form>

<%
		}
%>
    
   <td>
   Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)
	</td>
	</tr>
	</table>
<%
    } else {
%>
<table>
<tr>
<td>
Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to post about your topic.
</td>
</tr>
</table>
<%
    }
%>

</tr>
</table>
 
  <body>
  
  <table>
  <tr>
  <td>
  <img src="pic.jpg" alt="Picture" style="width:100%;height:100px">
  </td>
  </tr>
  <tr>
  <td>
  <header align = center><b><font size = "20">EE461L Blog</font></b></header>
  </td>
  </tr>
  </table>


 
<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
    Query query = new Query("Greeting", guestbookKey).addSort("date", Query.SortDirection.DESCENDING);
    List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(20));
    if (greetings.isEmpty()) {
    } else {
 
        for (Entity greeting : greetings) {
        	if(!greeting.getKind().equals("Email")){
        	Text longDescription = (Text)greeting.getProperty("content");
	            pageContext.setAttribute("greeting_content",longDescription.getValue());
	            pageContext.setAttribute("greeting_date",greeting.getProperty("date"));
	            pageContext.setAttribute("greeting_name",greeting.getProperty("Name"));
	            if (greeting.getProperty("user") != null) {
	                pageContext.setAttribute("greeting_user",greeting.getProperty("user"));
	                %>
	                <table>
	                <tr>
	                <td>
	                On ${fn:escapeXml(greeting_date)} <b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:
	                </td>
	                <%
		             %>
		             <tr>
		             <td>
		            <b>${fn:escapeXml(greeting_name)}</b>
		            </td>
		            </tr>
		            </br>
		            <%           
		            %>
		            <tr>
		            <td>
		            ${fn:escapeXml(greeting_content)}</blockquote>
		            </td>
		            </tr>
		            </table>
		            </br>
		            <%
	            }
            }
		
        }
        
    }
%>
 


 
  </body>
</html>