<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>

<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%!
	String username = "";
	String firstName = "";
	String lastName = "";
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
	</head>
	<div class="all">
	<body>
		<%
			try{
				username = (String)session.getAttribute("username");
				firstName = (String)session.getAttribute("firstName");
				lastName = (String)session.getAttribute("lastName");
				email = (String)session.getAttribute("emailAddress");
			} catch(Error e) {
				out.println("Error with fetching:"+e);
			}
		%>
	</body>
		<!--  Make an HTML table to show the results in: -->
	<div class="left-container">
		<div class="logout-container">
			<h3 class="train-schedule-name">
				
				Name: <%= firstName %> <%= lastName %>

			</h3>
			    
		</div>
		
		<form action="browse.jsp" method="post" class="form-container">
        <h2 >Search Train Schedule</h2>
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
    <div class="logout-container">
    	<form  action="reservations.jsp" method="post" style="text-align: left;">
	        <input type="submit" class = "reservations-button" value="My Reservations" />
	    </form>
	    
		<form  action="login.jsp" method="post" style="text-align: left;">
		        <input type="submit" class = "logout-button" value="Logout" />
	    </form>	
	    </div>
	    
	</body>
	</div>
	<div class="schedules-container">
    
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
				            orderByClause = "";
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
				
				for (int i = 0; i < parameters.size(); i++) {
				    ps.setString(i + 1, parameters.get(i));
				}
				
				ResultSet rs = ps.executeQuery();
                               
				HashSet<Integer> resList = (HashSet<Integer>)session.getAttribute("resList");
                resNum = 808;
                
                while(resList.contains(resNum)){
                    resNum = ((int) (Math.random() * 10000) + 1);
                }
                resList.add(resNum);
                session.setAttribute("resList", resList);
                
                int count = 0;
                if (rs.next()) {
                	%>
                	        <h3 class = "train-schedule-name">Train Schedules:</h3>
                	        <ul class="train-list">
                	        <%
                	            do {
                	                count++;
                	                
                	                if (count % 4 == 1) {
                	        %>
                	                    <div class="train-row">
                	        <%
                	                }
                	        %>	
									<form action="makeReservation.jsp?function=addReservation" method="post">                	                        
										<ul class="train-item">
                	                            <%
                	                                String one = rs.getString("transitLineName");
                	                                int two = rs.getInt("Train");
                	                                String three = rs.getString("Origin");
                	                                String four = rs.getString("Destination");
                	                                String five = rs.getString("ArrivalDateTime");
                	                                Timestamp six = rs.getTimestamp("DepartureDateTime");
                	                                String eight = rs.getString("travelTime");
                	                                String seven = rs.getString("Stops");
                	                                int nine = rs.getInt("Fare");
                	                                String ten = three.equals(four) ? "one way" : "round trip";
                	                            %>
                	                            <li><strong>Transit Line:</strong> <%= one %><br></li>
                	                            <li><strong>Train:</strong> <%= two %><br></li>
                	                            <li><strong>Origin:</strong> <%= three %><br></li>
                	                            <li><strong>Destination:</strong> <%= four %><br></li>
                	                            <li><strong>Departure Time:</strong> <%= six %><br></li>
                	                            <li><strong>Arrival Time:</strong> <%= five %><br></li>
                	                            <li><strong>Stops:</strong> <%= seven %><br></li>
                	                            <li><strong>Travel Time:</strong> <%= eight %><br></li>
                	                            <li><strong>Fare:</strong> <%= nine %><br><br></li>
                	                            
                	                            <input type="hidden" name="email" value="<%= email %>">
                	                            <input type="hidden" name="resNum" value="<%= resNum %>">
                	                            <input type="hidden" name="transitLineName" value="<%= one %>">
                	                            <input type="hidden" name="departureDate" value="<%= six.toString() %>">
                	                            <input type="hidden" name="trainNumber" value="<%= two %>">
                	                            <input type="hidden" name="originStation" value="<%= three %>">
                	                            <input type="hidden" name="destinationStation" value="<%= four %>">
                	                            <input type="hidden" name="totalFare" value="<%= nine %>">
                	                            <input type="hidden" name="tripType" value="<%= ten %>">
                	                            <input type="submit" value="Make Reservation">
                	                        </ul> 
                	                    </form>   
                	        <%
                	                if (count % 4 == 0) {
                	        %>
                	                    </div> <!-- End of .train-row -->
                	        <%
                	                }
                	            } while (rs.next());
                	            
                	            if (count % 5 != 0) {
                	        %>
                	                    </div> <!-- End of .train-row -->
                	        <%
                	            }
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
    </div>
    
    	
    <%
        }
    %>
    </div>
	
	
</html>

<head>
    <style>
        /* General body styling */
        body {
        	display:flex;
	        flex-direction: column;
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 1rem;
        }
        
        .left-container{
        	margin-right: 3rem;
        	spacing: 1rem;
        	display: flex;
        	flex-direction: column;
        	align-items: left;
        }
        
        .schedules-container{
        	
        }

        /* Center the main container */
        .main-container {
            display: flex;
            flex-direction: column;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }
        
        table tr{
        	
        }

        /* Form container styling */
        .form-container, .name, .train-schedule-name {
            background-color: #ffffff;
            padding: 20px 30px;
            border-radius: 8px;
			box-shadow: rgba(60, 64, 67, 0.3) 0px 1px 2px 0px, rgba(60, 64, 67, 0.15) 0px 2px 6px 2px;        
		}
        
        
        .form-container{
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

        .form-container input[type="submit"], .reservations-button, .logout-button {
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
        
        .logout-button{
           	background-color: #eb1546;
        }
        
        .all{
        	display:flex;
        	flex-direction:row;
        }

        .form-container input[type="submit"]:hover, .reservations-button:hover, .logout-button:hover {
            background-color: #0056b3;
			box-shadow: rgba(0, 0, 0, 0.1) 2px 2px, rgba(0, 0, 0, 0.08) 4px 4px, rgba(0, 0, 0, 0.06) 6px 6px, rgba(0, 0, 0, 0.04) 8px 8px, rgba(0, 0, 0, 0.02) 10px 10px;
		  transition: box-shadow 0.5s ease-in-out;
			
		}
		
		.train-item:hover {
            background-color: #ddd;
			box-shadow: rgba(60, 64, 67, 0.35) 0px 1px 2px 0px, rgba(60, 64, 67, 0.20) 0px 2px 6px 2px;        
		  	transition: box-shadow 0.5s ease-in-out;
        }
		
		.logout-button:hover{
		            background-color: #b81137;
		
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

        
        .train-row, .logout-container{
        	display: flex;
        	flex-direction:row;
        	grid-auto-flow: row;
			grid-column-gap: 10px;
			align-items: center;
			height: fit-content;
        }
        
        .train-row{
        	margin-top: 1.5rem;
        }
        
        .logout-container{
        	margin-bottom: 1.5rem;
        	justify-content:center;
        }

        .train-item input[type="submit"] {
            padding: 8px 12px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.1s ease;
            margin: 0.7rem;
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
        
        p.name{
        	margin-top:0;
        	margin-bottom:0;
        	width: fit-content;
            font-weight: 300;
        }	
        
        .train-schedule-name{
        	margin-top:0;
        	margin-bottom:0;
            width: fit-content;
            font-weight: 300;
        }
        .train-list {
            list-style-type: none;
            display:flex;
            padding: 0;
            flex-direction: column;
            margin:0;
        }
        .train-item {
            cursor: pointer;
            background-color: #f2f2f2;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
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
