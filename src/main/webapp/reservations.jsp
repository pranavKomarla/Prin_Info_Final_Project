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
String email = request.getParameter("email");
int resNum = Integer.parseInt(request.getParameter("resNum"));
String transitLineName = request.getParameter("transitLineName");
String departureDate = request.getParameter("departureDate");
String tripType; 




Timestamp timestamp = null;
if (!departureDate.equals("null") && !departureDate.isEmpty()) {
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    java.util.Date parsedDate = dateFormat.parse(departureDate);
    timestamp = new Timestamp(parsedDate.getTime());
}

int trainNumber = Integer.parseInt(request.getParameter("trainNumber"));
String originStation = request.getParameter("originStation");
String destinationStation = request.getParameter("destinationStation");
int totalFare = Integer.parseInt(request.getParameter("totalFare"));

if(originStation.equals(destinationStation)) {
	tripType = "round-trip";
} else {
	tripType = "one-way";
}

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
        out.println("Reservation added successfully!");
    } else {
        out.println("Reservation could not be added.");
    }
} catch (SQLException e) {
    e.printStackTrace();
    out.println("Error: " + e.getMessage() + transitLineName);
    out.println("Error: " + e.getMessage() + email);
} finally {
    try {
        if (stmt != null) stmt.close();
        if (con != null) con.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}



%>



</body>
</html>