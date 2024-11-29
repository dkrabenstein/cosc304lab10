<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Duncan & Frabnk Grocery Shipment Processing</title>
</head>
<body>
        
	<%@ include file="header.jsp" %> 
	<%
		// Get Order ID from request
		String orderId = request.getParameter("orderId");
		if (orderId == null || orderId.trim().isEmpty()) {
			out.println("<h3>Error: Order ID is missing.</h3>");
			return;
		}
	
		int idInt = Integer.parseInt(orderId);
		String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
		String uid = "sa";
		String pw = "304#sa#pw";
	
		Connection con = null;
	
		try {
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	
			// Establish connection
			con = DriverManager.getConnection(url, uid, pw);
			con.setAutoCommit(false); // Start transaction
	
			// Check if order ID exists
			String checkOrderSql = "SELECT * FROM ordersummary WHERE orderId = ?";
			PreparedStatement checkOrderStmt = con.prepareStatement(checkOrderSql);
			checkOrderStmt.setInt(1, idInt);
			ResultSet orderResult = checkOrderStmt.executeQuery();
	
			if (!orderResult.next()) {
				out.println("<h3>Error: Invalid Order ID.</h3>");
				return;
			}
	
			// Retrieve all items for the given order ID
			String orderDetailsSql = "SELECT productId, quantity FROM orderproduct WHERE orderId = ?";
			PreparedStatement orderDetailsStmt = con.prepareStatement(orderDetailsSql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			orderDetailsStmt.setInt(1, idInt);
			ResultSet productResult = orderDetailsStmt.executeQuery();
	
			boolean sufficientInventory = true;
			int newQuantity = 0;
	
			// Check inventory for each product
			while (productResult.next()) {
				int productId = productResult.getInt("productId");
				int orderQuantity = productResult.getInt("quantity");
	
				String inventorySql = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = 1";
				PreparedStatement inventoryStmt = con.prepareStatement(inventorySql);
				inventoryStmt.setInt(1, productId);
				ResultSet inventoryResult = inventoryStmt.executeQuery();
	
				if (inventoryResult.next()) {
					int availableQuantity = inventoryResult.getInt("quantity");
					if (orderQuantity > availableQuantity) {
						sufficientInventory = false;
						break;
					} else {
						newQuantity = availableQuantity - orderQuantity;
						out.println("Ordered product: " + productId + " Previous inventory: " + availableQuantity + " New inventory: " + newQuantity + "<br>" + "<br>");
					}
				} else {
					sufficientInventory = false;
					break;
				}
			}
	
			if (!sufficientInventory) {
				con.rollback(); // Rollback transaction if insufficient inventory///
				out.println("<h3>Error: Insufficient inventory for the order. Transaction rolled back.</h3>");
			} else {
				// Update inventory for each product
				productResult.beforeFirst();
				while (productResult.next()) {
					int productId = productResult.getInt("productId");
					int orderQuantity = productResult.getInt("quantity");
					
					String updateInventorySql = "UPDATE productinventory SET quantity = quantity - ? WHERE productId = ? AND warehouseId = 1";
					PreparedStatement updateInventoryStmt = con.prepareStatement(updateInventorySql);
					updateInventoryStmt.setInt(1, orderQuantity);
					updateInventoryStmt.setInt(2, productId);
					updateInventoryStmt.executeUpdate();
				}
					
				// Create shipment record nb check for warehouse
				String shipmentSql = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (?, ?, ?)";
				PreparedStatement shipmentStmt = con.prepareStatement(shipmentSql);
				shipmentStmt.setTimestamp(1, new Timestamp(new Date().getTime()));
				shipmentStmt.setString(2, "Shipment for Order ID: " + orderId);
				shipmentStmt.setInt(3, 1);
				shipmentStmt.executeUpdate();
	
				con.commit(); // Commit transaction
				out.println("<h3>Order ID " + orderId + " has been successfully processed and shipped.</h3>");
			}
	
		} catch (SQLException e) {
			if (con != null) {
				con.rollback(); // Rollback transaction on error
			}
			out.println("<h3>Error: " + e.getMessage() + "</h3>");
		} catch (ClassNotFoundException e) {
			out.println("<h3>Error: JDBC Driver not found.</h3>");
		} finally {
			if (con != null) {
				con.close();
			}
		}
	%>
	
	<h2><a href="index.jsp">Back to Main Page</a></h2>
	
	</body>
	</html>
