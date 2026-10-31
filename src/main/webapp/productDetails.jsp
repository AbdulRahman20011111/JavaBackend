<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="com.mysql.cj.jdbc.Blob"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page import="java.io.File, java.sql.DriverManager, java.util.Base64" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Product Details</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body {
        background: linear-gradient(135deg, #e3f2fd, #ffffff);
        font-family: 'Poppins', sans-serif;
        margin-top: 40px;
        padding-bottom: 40px;
    }
    .container {
        max-width: 900px;
        background: #fff;
        border-radius: 15px;
        padding: 30px;
        box-shadow: 0 8px 24px rgba(13, 110, 253, 0.15);
    }
    .product-image img {
        width: 100%;
        max-width: 400px;
        height: auto;
        border-radius: 15px;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
    }
    .product-details {
        padding-left: 25px;
        flex: 1;
    }
    h1.product-name {
        color: #0d6efd;
        font-weight: 700;
        font-size: 2.5rem;
        margin-bottom: 15px;
    }
    .price {
        font-size: 2rem;
        color: #198754;
        font-weight: 700;
        margin-bottom: 20px;
    }
    .product-description {
        font-size: 1.1rem;
        color: #444;
        margin-bottom: 20px;
    }
    .product-info h5 {
        font-weight: 600;
        margin-top: 20px;
        color: #333;
    }
    .buy-btn {
        background-color: #0d6efd;
        border: none;
        font-size: 1.2rem;
        font-weight: 600;
        padding: 12px 30px;
        border-radius: 8px;
        color: white;
        text-transform: uppercase;
        transition: background-color 0.3s ease;
        margin-top: 30px;
        display: inline-block;
        cursor: pointer;
    }
    .buy-btn:hover {
        background-color: #084cd6;
        text-decoration: none;
        color: white;
    }
    .row-info {
        margin-top: 10px;
        font-size: 1rem;
        color: #555;
    }
</style>
</head>
<body>

<div class="container d-flex flex-wrap justify-content-center">
<%
int pid = Integer.parseInt(request.getParameter("pid"));
Connection con = null;
Connection con2 = null;

PreparedStatement ps = null;
PreparedStatement ps2 = null;

String base64Image = null;
Blob blob = null;
try {
    String qry = "SELECT * FROM product WHERE pid=?";
    Class.forName("com.mysql.cj.jdbc.Driver");   
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Project", "root", "root");   
    
    ps = con.prepareStatement(qry);
    ps.setInt(1, pid);
    ResultSet rs = ps.executeQuery();

    if(rs.next()) {
        blob = (Blob)rs.getBlob("fileContent");
        if (blob != null) {
            byte[] imageBytes = blob.getBytes(1, (int) blob.length());
            base64Image = Base64.getEncoder().encodeToString(imageBytes);
        }
%>
    <div class="product-image">
        <% if (base64Image != null) { %>
            <img src="data:image/jpeg;base64,<%= base64Image %>" alt="Product Image" />
        <% } else { %>
            <img src="https://via.placeholder.com/400x400?text=No+Image" alt="No Image Available" />
        <% } %>
    </div>
  

    <div class="product-details">
        <h1 class="product-name"><%= rs.getString("product_name") %></h1>
		<div class="price">₹ <%= String.format("%.2f", rs.getDouble("price")) %></div>
        <p class="product-description"><%= rs.getString("description") %></p>

        <div class="product-info">
            <h5>Condition:</h5>
            <p class="row-info"><%= rs.getString("condition") %></p>

            <h5>Location:</h5>
            <p class="row-info"><%= rs.getString("address") %></p><br>
			<p class="row-info">If you are interested to buy this product, then contact the seller for more inquires</p>
            
        </div>
        
        <%-- <%
    String email=rs.getString("email");
				System.out.println("one "+email);
	con2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/Project", "root", "root");   
     ps2=con2.prepareStatement("select Phone from user_info where Email=?");
				ps2.setString(1, email);
				ResultSet rs2=ps2.executeQuery();
				double phone=rs2.getDouble("Phone"); %> --%>
        



<button type="button" class="buy-btn" onclick="toggleEmail()">Seller Contact Info</button>

 

<div id="sellerEmailDiv" style="display:none; margin-top:15px; font-size:1rem; color:#0d6efd;">
    Seller Email: <%= rs.getString("email") %>
</div>

<script>
    function toggleEmail() {
        var emailDiv = document.getElementById('sellerEmailDiv');
        if (emailDiv.style.display === 'none') {
            emailDiv.style.display = 'block';
        } else {
            emailDiv.style.display = 'none';
        }
    }
</script>        
        
     
        
    </div>
<%
    } else {
%>
    <h3 class="text-center text-danger">Product not found.</h3>
<%
    }
    rs.close();
} catch (Exception e) {
    out.println("<div class='text-danger text-center'>Error: " + e.getMessage() + "</div>");
} finally {
    try {
        if (ps != null) ps.close();
        if (con != null) con.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
