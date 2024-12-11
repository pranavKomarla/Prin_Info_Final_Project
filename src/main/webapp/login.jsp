<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
    // Backend Logic - Moved to the top before any HTML is sent
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    HashSet<Integer> resList = new HashSet<Integer>();
    session.setAttribute("resList", resList);

    if (username != null && password != null) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            // Check if user is an admin (manager table)
            String adminQuery = "SELECT * FROM employeeworks_at WHERE username = ? AND password = ? AND SSN IN (SELECT SSN FROM manager);";
            String repQuery = "SELECT * FROM employeeworks_at WHERE username = ? AND password = ? AND SSN IN (SELECT SSN FROM customer_representative);";
            String customerQuery = "SELECT * FROM Customer WHERE username = ? AND password = ?";

            PreparedStatement adminPs = con.prepareStatement(adminQuery);
            adminPs.setString(1, username);
            adminPs.setString(2, password);
            ResultSet adminRs = adminPs.executeQuery();

            if (adminRs.next()) {
                // Admin found
                session.setAttribute("username", username);
                session.setAttribute("firstName", adminRs.getString("firstName"));
                session.setAttribute("lastName", adminRs.getString("lastName"));
                session.setAttribute("password", adminRs.getString("password"));
                con.close();
                response.sendRedirect("adminDashboard.jsp");
                return; // Ensure no further processing
            }

            PreparedStatement repPs = con.prepareStatement(repQuery);
            repPs.setString(1, username);
            repPs.setString(2, password);
            ResultSet repRs = repPs.executeQuery();

            if (repRs.next()) {
                // Representative found
                session.setAttribute("username", username);
                session.setAttribute("firstName", repRs.getString("firstName"));
                session.setAttribute("lastName", repRs.getString("lastName"));
                session.setAttribute("password", repRs.getString("password"));
                con.close();
                response.sendRedirect("repDashboard.jsp");
                return;
            }

            PreparedStatement customerPs = con.prepareStatement(customerQuery);
            customerPs.setString(1, username);
            customerPs.setString(2, password);
            ResultSet customerRs = customerPs.executeQuery();

            if (customerRs.next()) {
                // Customer found
                session.setAttribute("email", customerRs.getString("emailAddress"));
                session.setAttribute("firstName", customerRs.getString("firstName"));
                session.setAttribute("lastName", customerRs.getString("lastName"));
                session.setAttribute("password", customerRs.getString("password"));
                con.close();
                response.sendRedirect("browse.jsp");
                return;
            } else {
                // Invalid credentials
                con.close();
                response.sendRedirect("login.jsp?error=Invalid+username+or+password");
                return;
            }
        } catch (Exception e) {
            // Handle exceptions by displaying an error message
            // It's better to forward to an error page or display a message in the JSP
            out.print("<p class='error'>An error occurred: " + e.getMessage() + "</p>");
            return;
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Login Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: flex-start; 
            height: 100vh;
            background-color: #f4f4f4;
        }
        .login-container {
            background-color: #fff;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            width: 350px;
            margin-top: 5rem;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        label {
            font-weight: bold;
            margin-bottom: 5px;
            display: block;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
        input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .error {
            color: red;
            margin-bottom: 15px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Login</h2>
        <%
            // Retrieve any error message from the query string
            String error = request.getParameter("error");
            if (error != null) { 
        %>
            <p class="error"><%= error %></p>
        <% } %>
        <!-- Form to collect username and password -->
        <form method="post" action="login.jsp">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required />
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required />
            <input type="submit" value="Login" />
        </form>
    </div>
</body>
</html>