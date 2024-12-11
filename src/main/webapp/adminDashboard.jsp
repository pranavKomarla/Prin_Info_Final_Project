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
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();		
	
	Statement stmt = con.createStatement();
	
	String entity = "Customer";
	
	String username = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");

	String sql = "SELECT COALESCE(SUM(totalFare), 0) AS totalFareSum FROM reservation_accountreservation";
	PreparedStatement ps = con.prepareStatement(sql);
	ResultSet result = ps.executeQuery();
	
	if(result.next()) {
		String report = String.valueOf(result.getInt("totalFareSum"));
		%>
		<p>Sales Report:</p>
		<p><%= report %></p>
		<%
		
		
		
		
		
	}
	

%>

	<form action="adminDashboard.jsp%>" method="post" class="form-container">
        <h2 >Search Train Schedule</h2>
        <div>
            <label for="textbox1">Transit Line:</label>
            <input 
                type="text" 
                id="textbox1" 
                name="transitLine" 
                placeholder="Enter a Transit Line" 
                value="<%= request.getParameter("transitLine") != null ? request.getParameter("transitLine") : "" %>">
        </div>
        <div>
            <label for="textbox2">Customer Name:</label>
            <input 
                type="text" 
                id="textbox2" 
                name="customerName" 
                placeholder="Enter a Customer:" 
                value="<%= request.getParameter("customerName") != null ? request.getParameter("customerName") : "" %>">
        </div>
        
        <input type="submit" value="Search">
    </form>
    
    <%
        // Check if form data is available
        String transitLine = request.getParameter("transitLine");
        String customerName = request.getParameter("customerName");
        
        
        
        
        
        
        
        
        if (transitLine != null || customerName != null) {
        	String[] nameParts = customerName.split(" ");
            String customerEmail = "";
            
            String sqlName = "SELECT emailAddress FROM Customer WHERE firstName = ? AND lastName = ?";
            PreparedStatement ps2 = con.prepareStatement(sqlName);
            ps2.setString(1, nameParts[0]);
            ps2.setString(2, nameParts[1]);
            ResultSet rsEmail = ps2.executeQuery(); 
            if(rsEmail.next()) {
            	customerEmail = rsEmail.getString("emailAddress" );
            }
        	
        	StringBuilder queryBuilder = new StringBuilder("SELECT * FROM reservation_accountreservation WHERE 1=1");
        	
        	List<String> parameters = new ArrayList<>();
			
			if (transitLine!= null && !transitLine.isEmpty()) {
			    queryBuilder.append(" AND transitLineName = ?");
			    parameters.add(transitLine);
			}
			if (customerName != null && !customerName.isEmpty()) {
			    queryBuilder.append(" AND email_address= ?");
			    parameters.add(customerEmail);
			}
			
			
			PreparedStatement ps3 = con.prepareStatement(queryBuilder.toString());
			
			// Set parameters dynamically
			for (int i = 0; i < parameters.size(); i++) {
			    ps3.setString(i + 1, parameters.get(i));
			}
			
			ResultSet rs = ps3.executeQuery();
        	
        	
        
        
        
        
			while(rs.next()) {
        
		    
    %>
    
			<ul class="train-item">
				<%
				String one = rs.getString("email_address");
				int two = rs.getInt("ResNum");
				String three = rs.getString("transitLine");
				Timestamp four = rs.getTimestamp("DepartureDateTime");
				int five = rs.getInt("trainNumber");
				String six = rs.getString("originStation");
				String seven = rs.getString("destinationStation");
				int eight = rs.getInt("totalFare");
				String nine = rs.getString("tripType");
				%>
				<li><strong>Email Address:</strong> <%= one %><br></li>
				<li><strong>Reservation Number:</strong> <%= two %><br>s</li>
				<li><strong>Transit Line:</strong> <%= three %><br></li>
				<li><strong>Departure Date Time:</strong> <%= four %><br></li>
				<li><strong>Train Number:</strong> <%= six %><br></li>
				<li><strong>Origin Station:</strong> <%= five %><br></li>
				<li><strong>Destination Station:</strong> <%= seven %><br></li>
				<li><strong>Total Fare:</strong> <%= eight %><br></li>
				<li><strong>Trip Type:</strong> <%= nine %><br><br></li>
				
				
				    
				<input type="submit" value="Make Reservation">
			</ul> 
		
		<%
			} 
		
		}
		%>
	
	

</body>
</html>