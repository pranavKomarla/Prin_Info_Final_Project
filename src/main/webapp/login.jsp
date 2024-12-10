<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
</head>
<body>
    <h2>Login</h2>
    <% 
        // Retrieve any error message from the query string
        String error = request.getParameter("error");
        if (error != null) { 
    %>
        <p style="color: red;"><%= error %></p>
    <% } %>
    <!-- Form to collect username and password -->
    <form method="post" action="browse.jsp">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required />
        <br><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required />
        <br><br>
        <input type="submit" value="Login" />
    </form>
</body>
</html>