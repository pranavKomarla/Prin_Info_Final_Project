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
	
	
	public void make_reservation() {
        String sql = "INSERT INTO reservation_accountreservation VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
            stmt.setString(4, departureDate);
            stmt.setInt(5, trainNumber);
            stmt.setString(6, originStation);
            stmt.setString(7, destinationStation);
            stmt.setInt(8, totalFare);

            // Determine trip type
            if(originStation.equals(destinationStation)) {
                tripType = "round-trip";
            } else {
                tripType = "one-way"; 
            }
            stmt.setString(9, tripType);

            // Execute the update statement
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                // Reservation was successfully added
                //out.println("Reservation added successfully!");
            } else {
                // Handle failure to insert reservation
                //out.println("Reservation could not be added.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Clean up resources
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
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
				String email_address = request.getParameter("emailAddress");
				usernameStr = username;
				passwordStr = password; 
				email = email_address; 
				
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
                        <li class = "train-item" 
                        	data-transit-line="<%= rs.getString("transitLineName") %>"
            				data-train="<%= rs.getInt("Train") %>"
            				data-origin="<%= rs.getString("Origin") %>"
            				data-destination="<%= rs.getString("Destination") %>"
            				data-arrival-time="<%= rs.getString("ArrivalDateTime") %>"
				            data-departure-time="<%= rs.getString("DepartureDateTime") %>"
				            data-fare="<%= rs.getInt("Fare") %>"
				            onclick="
				                function() {
				                    
			                        transitLineName = this.getAttribute('data-transit-line'); 
			                        trainNumber = this.getAttribute('data-train'); 
			                        originStation = this.getAttribute('data-origin'); 
			                        destinationStation = this.getAttribute('data-destination'); 
			                        departureDate = this.getAttribute('data-departure-time'); 
			                        totalFare = parseInt(this.getAttribute('data-fare'));
				                    
				                    
				                }
			            	"
                        
                        >
                            <strong>Transit Line:</strong> <%= rs.getString("transitLineName") %><br>
                            <strong>Train:</strong> <%= rs.getInt("Train") %><br>
                            <strong>Origin:</strong> <%= rs.getString("Origin") %><br>
                            <strong>Destination:</strong> <%= rs.getString("Destination") %><br>
                            <strong>Arrival Time:</strong> <%= rs.getString("ArrivalDateTime") %><br>
                            <strong>Departure Time:</strong> <%= rs.getString("DepartureDateTime") %><br>
                            <strong>Stops:</strong> <%= rs.getInt("Stops") %><br>
                            <strong>Travel Time:</strong> <%= rs.getString("travelTime") %><br>
                            <strong>Fare:</strong> <%= rs.getInt("Fare") %><br><br>
                        </li>
                    <%
                        } while (rs.next());
                    %>
                    </ul>
                    <input type="submit" value="Make Reservation" onclick = "make_reservation()"/>
                   
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
	
	
    <form action="login.jsp" method="post" style="text-align: left;">
        <input type="submit" value="Logout" />
    </form>
    
    
    
    
    
	</body>
</html>