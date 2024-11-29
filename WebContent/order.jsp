<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Duncan & Frank Order Processing</title>
</head>
<body>

<%
    // Retrieve customer ID and shopping cart details
    String custId = request.getParameter("customerId");
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (custId == null || productList == null || productList.isEmpty()) {
%>
        <h2>Error: Invalid customer ID or shopping cart is empty!</h2>
<%
    } else {
        // Database connection info
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw"; // Replace with your actual password
        Connection con = null;

        try {
            con = DriverManager.getConnection(url, uid, pw);
            con.setAutoCommit(false); // Enable transaction management

            // Step 1: Insert order summary into ordersummary table
            String orderInsertSQL = "INSERT INTO ordersummary (orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, customerId) " +
                                     "VALUES (GETDATE(), 0, '123 Main St', 'Test City', 'Test State', '12345', 'Test Country', ?)";
            PreparedStatement orderStmt = con.prepareStatement(orderInsertSQL, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, Integer.parseInt(custId));
            orderStmt.executeUpdate();

            // Retrieve the generated order ID
            ResultSet keys = orderStmt.getGeneratedKeys();
            keys.next();
            int orderId = keys.getInt(1);

            // Step 2: Insert each product into orderproduct table
            String productInsertSQL = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
            PreparedStatement productStmt = con.prepareStatement(productInsertSQL);

            double totalAmount = 0.0;

            Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
            
            while (iterator.hasNext()) {
                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                ArrayList<Object> product = entry.getValue();

                // Retrieve product details from cart
                String productId = (String) product.get(0);
                String productName = (String) product.get(1); // This is unused but availableh ahah
                int quantity = (Integer) product.get(3);
                out.println("here1");
                String price_string = (String) product.get(2);
                
                double price = Double.parseDouble(price_string);

                // Insert product details into orderproduct table
                productStmt.setInt(1, orderId);
                productStmt.setInt(2, Integer.parseInt(productId));
                productStmt.setInt(3, quantity);
                productStmt.setDouble(4, price);
                productStmt.executeUpdate();

                // Calculate total amount for the order
                totalAmount += quantity * price;
            }
            out.println("here1");
            // Step 3: Update totalAmount in ordersummary table
            String updateOrderSQL = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
            PreparedStatement updateOrderStmt = con.prepareStatement(updateOrderSQL);
            updateOrderStmt.setDouble(1, totalAmount);
            updateOrderStmt.setInt(2, orderId);
            updateOrderStmt.executeUpdate();

            // Commit the transaction
            con.commit();

            // Display order summary
%>
            <h2>Order Successfully Placed!</h2>
            <h3>Order ID: <%= orderId %></h3>
            <h3>Total Amount: $<%= String.format("%.2f", totalAmount) %></h3>
            <h3>Customer ID: <%= custId %></h3>
            <table border="1">
                <tr>
                    <th>Product ID</th>
                    <th>Product Name</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Total</th>
                </tr>
<%
                iterator = productList.entrySet().iterator();
                while (iterator.hasNext()) {
                    Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                    ArrayList<Object> product = entry.getValue();

                    String productId = (String) product.get(0);
                    String productName = (String) product.get(1);
                    int quantity = (Integer) product.get(3);
                    String price_string = (String) product.get(2);
                    double price = Double.parseDouble(price_string);

%>
                <tr>
                    <td><%= productId %></td>
                    <td><%= productName %></td>
                    <td><%= quantity %></td>
                    <td>$<%= String.format("%.2f", price) %></td>
                    <td>$<%= String.format("%.2f", quantity * price) %></td>
                </tr>
<%
                }
%>
            </table>
<%
            // Clear the cart
            session.setAttribute("productList", null);
        } catch (Exception e) {
            if (con != null) {
                con.rollback(); // Rollback transaction in case of error
            } 
%>
            <h2>Error: <%= e.getMessage() %></h2>
<%
        }
    }
%>
</body>
</html>
