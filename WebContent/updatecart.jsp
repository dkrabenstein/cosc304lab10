<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Update Cart</title>
</head>
<body>

<%
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList != null) {
    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    while (iterator.hasNext()) {
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
        String productId = (String) product.get(0);
        String quantityParam = request.getParameter("quantity_" + productId);
        if (quantityParam != null) {
            try {
                int newQuantity = Integer.parseInt(quantityParam);
                if (newQuantity > 0) {
                    product.set(3, newQuantity);
                } else {
                    out.println("Invalid quantity for product: " + productId + ". Quantity must be greater than 0.<br>");
                }
            } catch (NumberFormatException e) {
                out.println("Invalid quantity format for product: " + productId + ".<br>");
            }
        }
    }
}

response.sendRedirect("showcart.jsp");
%>

</body>
</html>
