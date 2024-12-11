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
		
		
		<form action="browse.jsp?username=<%= usernameStr %>&password=<%= passwordStr %>" method="post" class="form-container">
        <h2>Search Train Schedule</h2>
        <div>
            <label for="textbox1">Origin:</label>
            <input 
                type="text" 
                id="textbox1" 
                name="origin" 
                placeholder="Enter Origin" 
                value="<%= request.getParameter("origin") != null ? request.getParameter("origin") : "" %>">
        </div>
        <div>
            <label for="textbox2">Destination:</label>
            <input 
                type="text" 
                id="textbox2" 
                name="destination" 
                placeholder="Enter Destination" 
                value="<%= request.getParameter("destination") != null ? request.getParameter("destination") : "" %>">
        </div>
        <div>
            <label for="textbox3">Date Of Travel:</label>
            <input 
                type="date" 
                id="textbox3" 
                name="dateOfTravel" 
                placeholder="Enter Date of Travel" 
                value="<%= request.getParameter("dateOfTravel") != null ? request.getParameter("dateOfTravel") : "" %>">
        </div>
        <div>
            <label for="sortBy">Sort by:</label>
            <select id="sortBy" name="sort">
                <option value="arrival" <%= "arrival".equals(request.getParameter("sort")) ? "selected" : "" %>>Arrival Time</option>
                <option value="departure" <%= "departure".equals(request.getParameter("sort")) ? "selected" : "" %>>Departure Time</option>
                <option value="fare" <%= "fare".equals(request.getParameter("sort")) ? "selected" : "" %>>Fare</option>
            </select>
        </div>
        <input type="submit" value="Search">
    </form>
	<%
        // Check if form data is available
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String dateOfTravel = request.getParameter("dateOfTravel");

        // Display the list only if data is submitted
		  if (origin != null || destination != null || dateOfTravel != null) {
		    try {
		        ApplicationDB db = new ApplicationDB();
		        Connection con = db.getConnection();
		
		        String entity = "train_schedule";
		        List<String> parameters = new ArrayList<>();
		
		        // Start building the SQL query
		       	String sortOption = request.getParameter("sort");
				String orderByClause = "";
				
				if (sortOption != null) {
				    switch (sortOption) {
				        case "arrival":
				            orderByClause = " ORDER BY ArrivalDateTime";
				            break;
				        case "departure":
				            orderByClause = " ORDER BY DepartureDateTime";
				            break;
				        case "fare":
				            orderByClause = " ORDER BY Fare";
				            break;
				        default:
				            orderByClause = ""; // No sorting
				    }
				}
				
				// Include the sorting clause in the SQL query
				StringBuilder queryBuilder = new StringBuilder("SELECT * FROM train_schedule WHERE 1=1");
				
				// Add conditions for filtering (origin, destination, dateOfTravel) dynamically
				if (origin != null && !origin.isEmpty()) {
				    queryBuilder.append(" AND Origin = ?");
				    parameters.add(origin);
				}
				if (destination != null && !destination.isEmpty()) {
				    queryBuilder.append(" AND Destination = ?");
				    parameters.add(destination);
				}
				if (dateOfTravel != null && !dateOfTravel.isEmpty()) {
				    queryBuilder.append(" AND DATE(DepartureDateTime) = ?");
				    parameters.add(dateOfTravel);
				}
				
				// Append the sorting clause
				queryBuilder.append(orderByClause);
				
				PreparedStatement ps = con.prepareStatement(queryBuilder.toString());
				
				// Set parameters dynamically
				for (int i = 0; i < parameters.size(); i++) {
				    ps.setString(i + 1, parameters.get(i));
				}
				
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

                    <form action="reservations.jsp?username=<%= usernameStr %>&password=<%= passwordStr %>" method="post">
                    	<ul class = "train-item">
                    	
                    		<%
                    			String one = rs.getString("transitLineName");
	                    		int two = rs.getInt("Train");
	                    		String three = rs.getString("Origin");
	                    		String four = rs.getString("Destination");
	                    		String five = rs.getString("ArrivalDateTime");
	                    		Timestamp six = rs.getTimestamp("DepartureDateTime");
	                    		String seven = rs.getString("travelTime");
	                    		String eight = rs.getString("Stops");
	                    		int nine = rs.getInt("Fare");
	                    		String ten = "";
	                    		if(three.equals(four))
	                    			ten = "one way";
	                    		else
	                    			ten = "round trip";
                    		%>
                            <li><strong>Transit Line:</strong> <%= one %><br> </li>
                            <li><strong>Train:</strong> <%= two%><br></li>
                            <li><strong>Origin:</strong> <%=  three%><br></li>
                            <li><strong>Destination:</strong> <%= four %><br></li>
                            <li><strong>Departure Time:</strong> <%= six%><br></li>
                            <li><strong>Arrival Time:</strong> <%=  five%><br></li>
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
                        	<input type="hidden" name="tripType" value"<%=ten%>">
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

<head>
    <style>
        /* General body styling */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        /* Center the main container */
        .main-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }

        /* Form container styling */
        .form-container {
            background-color: #ffffff;
            padding: 20px 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 400px;
            margin-bottom: 30px;
        }

        .form-container h2 {
            text-align: center;
            margin-bottom: 20px;
            font-size: 1.8em;
            color: #333;
        }

        .form-container label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
            color: #555;
        }

        .form-container input[type="text"],
        .form-container input[type="date"],
        .form-container select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .form-container input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            font-size: 1em;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .form-container input[type="submit"]:hover {
            background-color: #0056b3;
        }

        /* Train schedule container */
        .train-schedule-container {
            width: 800px;
            max-width: 100%;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .train-schedule-container h3 {
            font-size: 1.5em;
            margin-bottom: 15px;
            color: #333;
        }

        .train-item {
            list-style: none;
            margin: 10px 0;
            background-color: #f9f9f9;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .train-item:hover {
            background-color: #f1f1f1;
        }

        .train-item strong {
            font-weight: bold;
            color: #333;
        }

        .train-item form {
            margin-top: 10px;
        }

        .train-item input[type="submit"] {
            padding: 8px 12px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .train-item input[type="submit"]:hover {
            background-color: #218838;
        }

        /* Button styles for navigation (My Reservations, Logout) */
        .nav-buttons {
            display: flex;
            justify-content: flex-end;
            margin-top: 15px;
        }

        .nav-buttons form {
            margin-left: 10px;
        }

        .nav-buttons input[type="submit"] {
            padding: 8px 15px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 0.9em;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .nav-buttons input[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>