<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 
<html>
<head>
 <Title>Add Post</Title>
 <link rel="stylesheet" href="webapp.css">
 <head/>

  <body>
  
  <table>
  <tr>
  <td>
  <%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)

<%
    } else {
%>
Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to include your name with greetings you post.
<%
    }
%>
	</tr>
	</td>
	
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
 

<br>
<table>
<tr>
<td>
 <name>Share this post with a friend! Enter their email!</name>
 </br>
 <form action="/share" method="post">
   <textarea name="content" rows="3" cols="60"></textarea>
   </br>
      <input type="hidden" name="guestbookName" value="${fn:escapeXml("default")}"/>
      <input type="submit" value="Send Link" />
  </form> 
 <form action="/webapp.jsp">
    <input type="submit" value="Cancel"  />
  </form>
  
</td>
</tr>
</table>
  </body>
</html>