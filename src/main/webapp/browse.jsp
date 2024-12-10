<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Insert title here</title>
	</head>
	<body>
	
	<% 
	String usernameStr = "";
	String passwordStr = "";
	%>
		
		<% try {
	
			//Check where you are coming from
			String source = request.getParameter("source");
			
			
			//if("login".equals(source)) {
				//Get the database connection
				ApplicationDB db = new ApplicationDB();	
				Connection con = db.getConnection();		

				//Create a SQL statement
				Statement stmt = con.createStatement();
				//Get the selected radio button from the index.jsp
				String entity = "Customer";
				//Get username from text field
				String username = request.getParameter("username");
				String password = request.getParameter("password");
				usernameStr = username;
				passwordStr = password; 
				//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
				String str = "SELECT * FROM " + entity + " WHERE username = ? AND password = ?";
				PreparedStatement ps = con.prepareStatement(str);
				ps.setString(1, username);
				ps.setString(2, password);
				//Run the query against the database.
				ResultSet result = ps.executeQuery();
	            // Check if any matching records exist
	            if (!result.isBeforeFirst()) { // ResultSet is empty
	                // Redirect to login.jsp with an error message
	                response.sendRedirect("login.jsp?error=Invalid+username+or+password");
	            } else {}
			//}
		%>
			
		<!--  Make an HTML table to show the results in: -->
	<table>
		<tr>    
			<td>First Name</td>
			<td>Last Name</td>
		</tr>
			<%
			//parse out the results
			while (result.next()) { %>
				<tr>    
					<td><%= result.getString("firstName") %></td>
					<td><%= result.getString("lastName") %></td>

				</tr>
				

			<% }
			//close the connection.
			db.closeConnection(con);
			%>
	</table>
			
		<%} catch (Exception e) {
			out.print(e);
		}%>
		
		
	<form action="browse.jsp?username=<%= usernameStr %>&password=<%= passwordStr %>" method="post" style="text-align: left;">
	
	
    	
        <label for="textbox1">Origin:</label>
        <input type="text" id="textbox1" name="origin" placeholder="Enter Origin">
        <br><br>

        
        <label for="textbox2">Destination:</label>
        <input type="text" id="textbox2" name="destination" placeholder="Enter Destination">
        <br><br>

        
        <label for="textbox3">Date Of Travel:</label>
        <input type="text" id="textbox3" name="dateOfTravel" placeholder="Enter Date of Travel">
        <br><br>

        <!-- Submit button -->
        <input type="submit" value="Search">
    </form>
		
	<%
        // Check if form data is available
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String dateOfTravel = request.getParameter("dateOfTravel");

        // Display the list only if data is submitted
        if (origin != null && destination != null && dateOfTravel != null) {
    %>
        <div id="resultList" style="margin-top: 20px;">
            <h3>Your Travel Details:</h3>
            <ul>
                <li><strong>Origin:</strong> <%= origin %></li>
                <li><strong>Destination:</strong> <%= destination %></li>
                <li><strong>Date Of Travel:</strong> <%= dateOfTravel %></li>
            </ul>
        </div>
    <%
        }
    %>
	
	
    <form action="login.jsp" method="post" style="text-align: left;">
        <input type="submit" value="Logout" />
    </form>
	</body>
</html>