<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat"%>


<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%

%>

<h3>Reservation Portfolio:</h3>
<%
	String sql2 = "SELECT * FROM reservation_accountreservation WHERE email_address = ?";
	
	


	ApplicationDB database = new ApplicationDB(); 
	Connection connection = null;
	PreparedStatement stmt2 = null;
    connection = database.getConnection();
    stmt2 = connection.prepareStatement(sql2);
    String email =  (String)session.getAttribute("email"); 
    String username = (String)session.getAttribute("username");
    String password = (String)session.getAttribute("password");
        
    stmt2.setString(1, email);
    
    ResultSet rs = stmt2.executeQuery();
    
			while (rs.next()) {
			%>
			
				<ul>
					<%
                		String one = rs.getString("resNum");
                 		String two = rs.getString("transitLine"); 
                 		Timestamp three = rs.getTimestamp("DepartureDateTime");
                 		String four = rs.getString("trainNumber");
                 		String five = rs.getString("originStation");
                 		String six = rs.getString("destinationStation");
                 		int seven = rs.getInt("totalFare");
                 		String eight = rs.getString("tripType"); 
                		%>
                		
                		<li><strong>Reservation Number:</strong> <%= one %><br> </li>
                        <li><strong>Transit Line:</strong> <%= two %><br> </li>
                        <li><strong>Departure Time:</strong> <%= three%><br></li>
                        <li><strong>Train Number:</strong> <%=  four%><br></li>
                        <li><strong>Origin Station:</strong> <%= five %><br></li>
                        <li><strong>Destination Station:</strong> <%= six%><br></li>
                        <li><strong>Fare:</strong> <%=  seven%><br></li>
                        <li><strong>Travel Time:</strong> <%=  eight%><br></li>
                        
	
	
	
				</ul>
			
		<% 
			}
			
		%>
		
		<%
		%>

				<form action="makeReservation.jsp?function=cancel" method="post">
				    <input 
				        type="text" 
				        id="cancelReservation" 
				        name="reservationToCancel" 
				        placeholder="Enter Reservation Number" 
				        value="<%= request.getParameter("reservationToCancel") != null ? request.getParameter("reservationToCancel") : "" %>" />
				    
				    <!-- Disable the button based on server-side logic -->
				    <input 
				        type="submit" 
				        value="Cancel Reservation" />
				</form>
				
				
				
				<form action="browse.jsp" method="post">
	           		<input type="submit" value = "Back">
	                        
	        	</form> 
						
	
	
		
		
				
				
				




</body>
</html>