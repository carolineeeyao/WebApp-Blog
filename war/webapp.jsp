<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import ="com.google.appengine.api.datastore.Text" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 
<html>
  <head>
	<link rel="stylesheet" href="bootstrap.css"/>
		<link rel="stylesheet" href="main.css"/>
		
		<link href="https://fonts.googleapis.com/css?family=Courgette" rel="stylesheet">
		<link href="https://fonts.googleapis.com/css?family=Comfortaa" rel="stylesheet">
  </head>
 
  <body>

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

	<table style="width:80%; margin:auto">
	<tr>
	<td>
    <form action="/addpost.jsp" method="post">
    	<input type="submit" value="Add Post" type="button" class="btn btn-secondary"/>
    </form>
    </td>
    <td>
   <form action="/showallposts.jsp" method="post">
      <input type="submit" value="Show More" type="button" class="btn btn-secondary"/>
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
	    <form action="/webappblog" method="get">
	     <input type="submit" value="Subscribe" type="button" class="btn btn-secondary"/>
	    </form>
	    </td>
	    
    <td>
		<form action="/shareposts.jsp" method="post">
	    <input type="submit" value="Share" type="button" class="btn btn-secondary"/>
	    </form>
	</td>	

<%	 
		}else{
%>
   		<td>
	    <form action="/showall" method="post">
	    <input type="submit" value="Unsubscribe" type="button" class="btn btn-secondary" />
	    </form>
	    </td>
    <td>
		<form action="/shareposts.jsp" method="post">
	    <input type="submit" value="Share" type="button" class="btn btn-secondary"/>
	    </form>
	</td>	

<%
		}
%>
<td align = right>
   Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)
  </td>
</tr>
</table>
<%
    } else {
%>
  <table style="width:80%; margin:auto;" >
  <tr>
  <td align = right>
  Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to post about your topic.
  </td>
  </tr>
  </table>
<%
    }
%>

  
  <table style="width:80%; margin:auto">
  <tr>
  	<td>
  <img src="meow header.png" alt="Picture" style="width:100%;height:200px">
  	</td>
  </tr>
  <tr>
  <td>
  <header align = center><h1>A Cute Cat Blog</h1></header>
  </td>
  </tr>
  </table>
  
  


 
<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
    Query query = new Query("Greeting", guestbookKey).addSort("date", Query.SortDirection.DESCENDING);
    List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
 	int counter = 0;
    if (greetings.isEmpty()) {
    } else {
 
        for (Entity greeting : greetings) {
        	if(!greeting.getKind().equals("Email")&&counter<3){
        		counter++;
	            Text longDescription = (Text)greeting.getProperty("content");
	            pageContext.setAttribute("greeting_content",longDescription.getValue());
	            pageContext.setAttribute("greeting_date",greeting.getProperty("date"));
	            pageContext.setAttribute("greeting_name",greeting.getProperty("Name"));
	            if (greeting.getProperty("user") != null) {
	                pageContext.setAttribute("greeting_user",greeting.getProperty("user"));
	                %>
	                <table style="width:80%; margin:auto; " class="comment">
	                <tr>
	                	<td>
	                	On ${fn:escapeXml(greeting_date)} <b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:
	                	</td>
	                </tr>
	                <%
		             %>
		            <tr>
		            	<td>
		           			 <h2>Title: ${fn:escapeXml(greeting_name)}</h2>
		           		</td>
		           	</tr>
		            </br>
		            <%           
		            %>
		            <tr>
		            	<td class="content">
		            		${fn:escapeXml(greeting_content)}
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