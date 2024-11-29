<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Duncan & Frank Order List</title>
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
    <h1 style="text-align: center;">Order List</h1>
    <%
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";

        String query = "SELECT os.orderId, os.orderDate, os.totalAmount, " +
                       "c.customerId, c.firstName + ' ' + c.lastName AS customerName, " +
                       "p.productId, op.quantity, op.price " +
                       "FROM ordersummary os " +
                       "JOIN customer c ON os.customerId = c.customerId " +
                       "JOIN orderproduct op ON os.orderId = op.orderId " +
                       "JOIN product p ON op.productId = p.productId " +
                       "ORDER BY os.orderId, p.productId";

        try (Connection con = DriverManager.getConnection(url, uid, pw);
             Statement stmt = con.createStatement();
             ResultSet rst = stmt.executeQuery(query)) {

            int currentOrderId = -1;

            while (rst.next()) {
                int orderId = rst.getInt("orderId");

                // New order section
                if (orderId != currentOrderId) {
                    if (currentOrderId != -1) {
                        // Close the previous order's table
                        out.println("</table>");
                    }

                    // Print order header
                    currentOrderId = orderId;
                    out.println("<h3>Order ID: " + orderId + "</h3>");
                    out.println("<table>");
                    out.println("<tr class='order-header'><th>Order Date</th><th>Customer ID</th><th>Customer Name</th><th>Total Amount</th></tr>");
                    out.println("<tr>");
                    out.println("<td>" + rst.getTimestamp("orderDate") + "</td>");
                    out.println("<td>" + rst.getInt("customerId") + "</td>");
                    out.println("<td>" + rst.getString("customerName") + "</td>");
                    out.println("<td>$" + String.format("%.2f", rst.getDouble("totalAmount")) + "</td>");
                    out.println("</tr>");
                    out.println("</table>");

                    // Start new product table
                    out.println("<table>");
                    out.println("<tr><th>Product ID</th><th>Quantity</th><th>Price</th></tr>");
                }

                // Print product details
                int productId = rst.getInt("productId");
                int quantity = rst.getInt("quantity");
                double price = rst.getDouble("price");

                out.println("<tr>");
                out.println("<td>" + productId + "</td>");
                out.println("<td>" + quantity + "</td>");
                out.println("<td>$" + String.format("%.2f", price) + "</td>");
                out.println("</tr>");
            }

            if (currentOrderId != -1) {
                // Close the last order's product table
                out.println("</table>");
            }
        } catch (SQLException ex) {
            out.println("<p>Error: " + ex.getMessage() + "</p>");
        }
    %>
</body>
</html>