<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
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

<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>

<%
out.println("Administrator Sales Report by Day" + "<br>" + "<br>");
// TODO: Write SQL query that prints out total order amount by day
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
try {
    Connection con = DriverManager.getConnection(url, uid, pw);
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    String sql = "SELECT CAST(orderDate AS DATE), SUM(totalAmount) FROM ordersummary GROUP BY CAST(orderDate AS DATE)";
    PreparedStatement pstmt = con.prepareStatement(sql);
    ResultSet rst = pstmt.executeQuery();
    out.println("<table>");
    out.println("<tr class='order-header'><th>Order Date</th><th>Total Order Amount</th></tr>");
    while(rst.next()) {
        out.println("<tr>");
        out.println("<td>" + rst.getString(1) + "</td>");
        out.println("<td>$" + String.format("%.2f", rst.getDouble(2)) + "</td>");
        out.println("</tr>");
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

%>

</body>
</html>

