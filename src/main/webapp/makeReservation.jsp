<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
String function = request.getParameter("function");
String username = request.getParameter("username");
String password = request.getParameter("password"); 
String email = request.getParameter("email");


ApplicationDB database = new ApplicationDB(); 
Connection connection = null;
PreparedStatement statement = null;


if(function.equals("addReservation")) {
	
	int resNum = Integer.parseInt(request.getParameter("resNum"));
	String transitLineName = request.getParameter("transitLineName");
	String departureDate = request.getParameter("departureDate");


	Timestamp timestamp = null;
	if (!departureDate.equals("null") && !departureDate.isEmpty() && !departureDate.equals(null)) {
	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    java.util.Date parsedDate = dateFormat.parse(departureDate);
	    timestamp = new Timestamp(parsedDate.getTime());
	}

	int trainNumber = Integer.parseInt(request.getParameter("trainNumber"));
	String originStation = request.getParameter("originStation");
	String destinationStation = request.getParameter("destinationStation");
	int totalFare = Integer.parseInt(request.getParameter("totalFare"));
	String tripType = request.getParameter("tripType");

	String checkDuplicates = "SELECT * FROM reservation_accountreservation WHERE email_address = ? AND transitLine = ? AND trainNumber = ?";
	



	try {
	    connection = database.getConnection();
	    statement = connection.prepareStatement(checkDuplicates);
	    statement.setString(1, email);
		statement.setString(2, transitLineName);
		statement.setInt(3, trainNumber);
	    
	    ResultSet rows = statement.executeQuery();
	    
	    if (!rows.next()) {
	        
	        String sql = "INSERT INTO reservation_accountreservation (email_address, ResNum, transitLine, DepartureDateTime, trainNumber, originStation, destinationStation, totalFare, tripType) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

	        
	        PreparedStatement stmt = null;
	        

	        try {
	            connection = database.getConnection();
	            stmt = connection.prepareStatement(sql);
	            
	            stmt.setString(1, email);
	            stmt.setInt(2, resNum);
	            stmt.setString(3, transitLineName);
	            stmt.setTimestamp(4, timestamp);
	            stmt.setInt(5, trainNumber);
	            stmt.setString(6, originStation);
	            stmt.setString(7, destinationStation);
	            stmt.setInt(8, totalFare);
	            stmt.setString(9, tripType);

	            int rowsAffected = stmt.executeUpdate();
	            if (rowsAffected > 0) {
	                out.println("Reservation added successfully!"+ tripType);
	                response.sendRedirect("reservations.jsp?username="+username+"&password="+ password +"&email="+email); 
	            } 
	        } catch (SQLException e) {
	            e.printStackTrace();
	            out.println("Error: " + e.getMessage() + tripType);
	            out.println("Error: " + e.getMessage() + email);
	        } 
	        
	        
	    } 
	    
	    
	    else {
	    	
	    	%>
	    	<p>You have already reserved this!<p>
	    	<form action="browse.jsp?username=<%= username %>&password=<%= password %>" method="post">
	           <input type="submit" value = "Back">
	                        
	        </form>  
	    	<% 
	        
	    }
	} catch (SQLException e) {
	    e.printStackTrace();
	    out.println("Error: " + e.getMessage() + tripType);
	    out.println("Error: " + e.getMessage() + email);
	} 

} else {
	
	try {
		String resNum = request.getParameter("reservationToCancel"); 
		String sql = "DELETE FROM reservation_accountreservation WHERE email_address = ? AND ResNum = ?";
		connection = database.getConnection();
		statement = connection.prepareStatement(sql);
		statement.setString(1, email);
		statement.setInt(2, Integer.parseInt(resNum));
		int rowsAffected = statement.executeUpdate();
	    
	    if (rowsAffected > 0) {
	        out.println("Row deleted successfully!");
	        response.sendRedirect("reservations.jsp?username="+username+"&password="+ password +"&email="+email); 
	    } else {
	        %>
	        <p>You have already reserved this!<p>
	    	<form action="reservations.jsp?username=<%= username %>&password=<%= password %>&email=<%= email %>" method="post">
	           <input type="submit" value = "Back">
	                        
	        </form> 
	        <% 
	    }
	} catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
	
	
	
}

    
    
    
%>

				


</body>
</html>