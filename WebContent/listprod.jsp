<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Duncan and Frank Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
out.println("Products Containing" + " \"" + name + "\"");
name = "%" + name + "%";
		
//Note: Forces loading of SQL Server driver
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
try (Connection con = DriverManager.getConnection(url, uid, pw);)
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	String SQL = "SELECT productId, productName, ProductPrice " + 
				"FROM product " +
				"WHERE productName LIKE ?";
	PreparedStatement pstmt = con.prepareStatement(SQL);
	pstmt.setString(1, name);
	ResultSet rst = pstmt.executeQuery();
	out.println("<table>");
	out.println("<tr class='order-header'><th>Product Name</th><th>Price</th></tr>");
	int productId = 0;
	String productPrice = "";
	String productName = "";
	String link_cart = "";
	String link_product = "";

	while(rst.next()) {
		if (rst.next()) { 
			productId = rst.getInt(1);
			productName = rst.getString(2);
			productPrice = String.format("%.2f", rst.getDouble(3));
			link_cart = "addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + productPrice;
			link_product = "product.jsp?id=" + productId;
            out.println("<tr>");
			out.println("<td><a href='" + link_cart + "'>Add to Cart</a></td>");
			out.println("<td><a href='" + link_product + "'>" + productName + "</a></td>");
			out.println("<td>" + productPrice + "<td>"); 
			out.println("</tr>");
		} else { 
			out.println("No matching products found.");
		}
	}
	out.println("</table>");
//	<form name="Add to Cart" method=post action="addcart.jsp?id=productId&name=productName&price=productPrice</form>
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

%>

</body>
</html>