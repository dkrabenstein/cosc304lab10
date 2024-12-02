<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
    // Invalidate the session to clear all session variables
    session.invalidate();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clear Session</title>
</head>
<body>
    <h1>Session Cleared</h1>
    <p>All session variables have been cleared.</p>
    <a href="index.jsp">Go back to Home</a>
</body>
</html>
