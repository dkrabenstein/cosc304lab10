<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Ray's Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
// Get product name to search for
// TODO: Retrieve and display info for the product
String productId = request.getParameter("id");

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
String productName = "";
Double price = 0.0;
String productImageURL = "";
String productImageURL2;
String productPrice = "";
String linkCart = "";
try (Connection con = DriverManager.getConnection(url, uid, pw);)
{	
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    String sql = "SELECT productId, productName, productPrice, productImageURL, productImage FROM Product P  WHERE productId = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, productId);
    ResultSet rst = pstmt.executeQuery();
    if(rst.next()) {
        productName = rst.getString(2);
        price = rst.getDouble(3);
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance();
        String formattedPrice = currencyFormatter.format(price);
        String imageLoc = rst.getString(4);
        productImageURL2 = "displayImage.jsp?id=" + productId;
        productPrice = String.format("%.2f", price);
        String imageBinary = rst.getString(5);
        linkCart = "addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + productPrice;

        out.println(productName + "<br>");
        if (imageLoc != null)
            out.println("<img src=\""+imageLoc+"\">");
        if (imageBinary != null)
            out.println("<img src=\"displayImage.jsp?id="+productId+"\">");  
        out.println("<br>" + "<br>" + "Id  " + productId + "<br>");
        out.println("Price " + formattedPrice + "<br>");
        out.println("<a href='" + linkCart + "'>Add to Cart</a>" + "<br>");
        out.println("<a href='" + "listprod.jsp" + "'>Continue Shopping</a>");
        // out.println("</table>");
        // Retrieve any image with a URL


// Retrieve any image stored directly in database



    }
} catch (java.lang.ClassNotFoundException e) {
    out.println("ClassNotFoundException: " +e);
}


// TODO: If there is a productImageURL, display using IMG tag
		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		
// TODO: Add links to Add to Cart and Continue Shopping
%>

</body>
</html>

