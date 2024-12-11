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
String username = request.getParameter("username");
String password = request.getParameter("password"); 
String email = request.getParameter("email");
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
ApplicationDB database = new ApplicationDB(); 
Connection connection = null;
PreparedStatement statement = null;



try {
    connection = database.getConnection();
    statement = connection.prepareStatement(checkDuplicates);
    statement.setString(1, email);
	statement.setString(2, transitLineName);
	statement.setInt(3, trainNumber);
    
    ResultSet rows = statement.executeQuery();
    
    if (!rows.next()) {
        
        String sql = "INSERT INTO reservation_accountreservation (email_address, ResNum, transitLine, DepartureDateTime, trainNumber, originStation, destinationStation, totalFare, tripType) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        ApplicationDB db = new ApplicationDB(); 
        Connection con = null;
        PreparedStatement stmt = null;
        

        try {
            con = db.getConnection();
            stmt = con.prepareStatement(sql);
            
            // Set the parameters
            stmt.setString(1, email);
            stmt.setInt(2, resNum);
            stmt.setString(3, transitLineName);
            stmt.setTimestamp(4, timestamp);
            stmt.setInt(5, trainNumber);
            stmt.setString(6, originStation);
            stmt.setString(7, destinationStation);
            stmt.setInt(8, totalFare);
            stmt.setString(9, tripType);

            // Execute the update statement
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("Reservation added successfully!"+ tripType);
            } else {
                out.println("Reservation could not be added: Duplicate Reservation");
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
    	<% 
        
    }
} catch (SQLException e) {
    e.printStackTrace();
    out.println("Error: " + e.getMessage() + tripType);
    out.println("Error: " + e.getMessage() + email);
} 






%>

<h3>Reservation Portfolio:</h3>

<%
	String sql2 = "SELECT * FROM reservation_accountreservation WHERE email_address = ?";
	ApplicationDB db2 = new ApplicationDB(); 
	Connection con2 = null;
	PreparedStatement stmt2 = null;


    con2 = db2.getConnection();
    stmt2 = con2.prepareStatement(sql2);
    
    // Set the parameters
    stmt2.setString(1, email);
    

    // Execute the update statement
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
		
	
	
		
		
				<form action="browse.jsp?username=<%= username %>&password=<%= password %>" method="post">
                    	<input type="submit" value = "Back">
                        
                </form>   
							
	
		
        




</body>
</html>
