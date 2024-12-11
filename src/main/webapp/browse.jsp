<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>

<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%!
	String usernameStr = "";
	String passwordStr = "";
	String email = "";
	int resNum;
	int trainNumber;
	String transitLineName, departureDate, originStation, destinationStation, tripType; 
	int totalFare; 
	
	
	
	
    
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Insert title here</title>
		<style>
        .train-list {
            list-style-type: none;
            padding: 0;
        }
        .train-item {
            margin: 10px 0;
            cursor: pointer;
            background-color: #f2f2f2;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .train-item:hover {
            background-color: #ddd;
        }
        #trainDetails {
            margin-top: 20px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
    </style>
	</head>
	<body>
	
	
		
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
				
				String emailStr = "SELECT emailAddress FROM " + entity + " WHERE username = ? AND password = ?";
				PreparedStatement psEmail = con.prepareStatement(emailStr);
				psEmail.setString(1, username);
				psEmail.setString(2, password);
				ResultSet resultEmail = psEmail.executeQuery();
				
				if (resultEmail.next()) {
				    email = resultEmail.getString("emailAddress");
				} else {
				    email = null; 
				}
				
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
        	
        	try {
        		ApplicationDB db = new ApplicationDB();	
    			Connection con = db.getConnection();		

    			
    			Statement stmt = con.createStatement();
    			
    			String entity = "train_schedule";
    			
    			
    			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
    			String str = "SELECT * FROM " + entity + " WHERE Origin = ? AND Destination = ?";
    			PreparedStatement ps = con.prepareStatement(str);
    			ps.setString(1, origin);
    			ps.setString(2, destination);
    			
    			//Run the query against the database.
    			ResultSet rs = ps.executeQuery();
                // Check if any matching records exist
                /* if (!result.isBeforeFirst()) { // ResultSet is empty
                    // Redirect to login.jsp with an error message
                    response.sendRedirect("browse.jsp?error=Invalid+origin+or+destination");
                } else {} */
                
                
                
                resNum = ((int) (Math.random() * 10000) + 1);
                
                
                
                
                if (rs.next()) {
    %>
                    <h3>Train Schedules:</h3>
                    <ul class = "train-list">
                    <%
                        do {
                        	
                    %>	
                    
                    
                    
                    <form action="reservations.jsp" method="post">
                    	<ul class = "train-item">
                    	
                    		<%
                    			String one = rs.getString("transitLineName");
	                    		int two = rs.getInt("Train");
	                    		String three = rs.getString("Origin");
	                    		String four = rs.getString("Destination");
	                    		String five = rs.getString("ArrivalDateTime");
	                    		Timestamp six = rs.getTimestamp("DepartureDateTime");
	                    		String seven = rs.getString("travelTime");
	                    		int eight = rs.getInt("Stops");
	                    		int nine = rs.getInt("Fare");
                    		%>
                            <li><strong>Transit Line:</strong> <%= one %><br> </li>
                            <li><strong>Train:</strong> <%= two%><br></li>
                            <li><strong>Origin:</strong> <%=  three%><br></li>
                            <li><strong>Destination:</strong> <%= four %><br></li>
                            <li><strong>Arrival Time:</strong> <%=  five%><br></li>
                            <li><strong>Departure Time:</strong> <%= six%><br></li>
                            <li><strong>Stops:</strong> <%=  seven%><br></li>
                            <li><strong>Travel Time:</strong> <%=  eight%><br></li>
                            <li><strong>Fare:</strong> <%=  nine%><br><br></li>
                            
                            <input type="hidden" name="email" value="<%= email %>">
                        	<input type="hidden" name="resNum" value="<%= resNum %>">
                        	<input type="hidden" name="transitLineName" value="<%= one %>">
                        	<input type="hidden" name="departureDate" value="<%= six.toString() %>">
                        	<input type="hidden" name="trainNumber" value="<%= two %>">
                        	<input type="hidden" name="originStation" value="<%= three %>">
                        	<input type="hidden" name="destinationStation" value="<%= four %>">
                        	<input type="hidden" name="totalFare" value="<%= nine %>">
                        	<input type="submit" value="Make Reservation">
                        </ul>
                        
                    </form>
                        
                      
                    <%
                        } while (rs.next());
                    %>
                    
                    
                    
                    </ul>
                    
                    
                    
                    
                    
                   
                    
                   
                <%
                
               
                } else {
                %>
                    <p>No schedules found for this location.</p>
                <%
                }
        	} catch (SQLException e) {
                e.printStackTrace();
            } 
        	
        	
        	
        	
    %>
    	
    <%
        }
    %>
	
	<form action="reservations.jsp" method="post" style="text-align: left;">
        <input type="submit" value="My Reservations" />
    </form>
    
    <form action="login.jsp" method="post" style="text-align: left;">
        <input type="submit" value="Logout" />
    </form>
    
    
    
    
    
	</body>
</html>