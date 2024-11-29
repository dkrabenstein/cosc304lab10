<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
<style>
    table {
        width: 80%;
        border-collapse: collapse;
        margin: 20px auto;
    }
    th, td {
        border: 1px solid rgb(0, 0, 0);
        padding: 8px;
        text-align: left;
    }
    th {
        background-color: #f2f2f2;
    }
    .order-header {
        background-color: #d9d9d9;
    }
</style>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// TODO: Print Customer information
out.println("Customer Information" + "<br>" + "<br>");
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
try {
    Connection con = DriverManager.getConnection(url, uid, pw);
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid FROM customer WHERE userid=?";
    PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1, userName);
    ResultSet rst = pstmt.executeQuery();
    out.println("<table>");
    out.println("<tr class='order-header'><th>Order Date</th><th>Total Order Amount</th></tr>");
    if(rst.next()) {
        out.println("<tr><th>Id</th><td>" + rst.getInt(1) +  "</td></tr>");
		out.println("<tr><th>First Name</th><td>" + rst.getString(2) +  "</td></tr>");
		out.println("<tr><th>Last Name</th><td>" + rst.getString(3) +  "</td></tr>");
		out.println("<tr><th>Email</th><td>" + rst.getString(4) +  "</td></tr>");
		out.println("<tr><th>Phone</th><td>" + rst.getString(5) +  "</td></tr>");
		out.println("<tr><th>Address</th><td>" + rst.getString(6) +  "</td></tr>");
		out.println("<tr><th>City</th><td>" + rst.getString(7) +  "</td></tr>");
		out.println("<tr><th>State</th><td>" + rst.getString(8) +  "</td></tr>");
		out.println("<tr><th>Postal Code</th><td>" + rst.getString(9) +  "</td></tr>");
		out.println("<tr><th>Country</th><td>" + rst.getString(10) +  "</td></tr>");
		out.println("<tr><th>User id</th><td>" + rst.getString(11) +  "</td></tr>");
    }
    out.println("</table>");
} 
catch (SQLException ex) {
    out.println(ex);
} catch (java.lang.ClassNotFoundException e) {
    out.println("ClassNotFoundException: " + e);
} finally {
    closeConnection();
}	

// Make sure to close connection
%>

</body>
</html>

