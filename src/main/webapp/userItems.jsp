<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@ page import="java.sql.Blob" %>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Base64"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="navbar.jsp" %>
<%@ include file="footer.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Product Details</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
<style>
    .product-card {
        max-width: 900px;
        margin: 20px auto;
    }
    .product-image {
        max-height: 350px;
        object-fit: cover;
        border-radius: 8px 0 0 8px;
    }
    .product-info {
        padding: 20px;
    }
    .product-price {
        font-size: 1.5rem;
        font-weight: bold;
        color: #d6336c;
        margin-bottom: 15px;
    }
    .product-attribute {
        margin-bottom: 10px;
    }
    .label-attr {
        font-weight: 600;
        color: #555;
    }
</style>
</head>
<body>

<div class="container mt-5">
<h1>Your Items</h1>
<%
    String email = (String) session.getAttribute("email");
    if (email == null) {
%>
    <div class="alert alert-warning text-center">No email session found. Please login.</div>
<%
    } else {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Project", "root", "root");
            
            
            
            
            
            String sql = "select * from product where email = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();

            while(rs.next()) {
            	int productId = rs.getInt("pid");
                String name = rs.getString("product_name"); 
                String category = rs.getString("category");
                double price = rs.getDouble("price");
                String email2 = rs.getString("email");
                String description = rs.getString("description");
                String condition = rs.getString("condition");
                String address = rs.getString("address");

                Blob blob = rs.getBlob("fileContent");
                String base64image = "";
                if (blob != null) {
                    InputStream inputStream = blob.getBinaryStream();
                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                    byte[] buffer = new byte[4096];
                    int bytesRead = -1;
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }
                    byte[] imgData = outputStream.toByteArray();
                    inputStream.close();
                    outputStream.close();
                    base64image = Base64.getEncoder().encodeToString(imgData);
                }
%>

    <div class="card product-card shadow-sm d-flex flex-row">
        <div class="flex-shrink-0">
            <% if (!base64image.isEmpty()) { %>
                <img src="data:image/jpeg;base64,<%= base64image %>" alt="<%= name %>" class="product-image" />
                
            <% } else { %>
                <div class="text-muted p-5" style="width:350px; height:350px; display:flex; align-items:center; justify-content:center;">
                    No Image Available
                </div>
            <% } %>
        </div>
        <div class="product-info flex-grow-1">
        	<form action="DeleteProductServlet.jsp" method="post" onsubmit="return confirm('Are you sure you want to delete this product?');">
    			<input type="hidden" name="productId" value="<%= productId %>">
    			<button type="submit" class="btn btn-danger mt-3">Delete Product</button>
			</form>
            <h2 class="mb-3"><%= name %></h2>
            <div class="product-price">$<%= price %></div>
            <div class="product-attribute"><span class="label-attr">Category:</span> <%= category %></div>
            <div class="product-attribute"><span class="label-attr">Condition:</span> <%= condition %></div>
            <div class="product-attribute"><span class="label-attr">Description:</span><br/> <%= description %></div>
            <div class="product-attribute"><span class="label-attr">Address:</span> <%= address %></div>
            <div class="product-attribute"><span class="label-attr">Contact Email:</span> <%= email2 %></div>
            
        </div>
        
        
    </div>
    

<%
            }
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
    }
%>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
