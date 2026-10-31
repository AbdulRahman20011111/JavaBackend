<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.util.*, java.util.Base64" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Products in Category</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<style>
body {
    background: linear-gradient(135deg, #e3f2fd, #ffffff);
    font-family: 'Poppins', sans-serif;
}
.container {
    margin-top: 40px;
    margin-bottom: 60px;
    max-width: 95%;
}
.product-card {
    display: flex;
    align-items: center;
    background: #fff;
    border-radius: 14px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    padding: 15px;
    margin-bottom: 25px;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    cursor: pointer;
    width: 100%;
    text-decoration: none;
    color: inherit;
}
.product-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 18px rgba(0,0,0,0.15);
}
.product-image {
    flex: 0 0 250px;
    height: 200px;
    border-radius: 10px;
    overflow: hidden;
    margin-right: 25px;
}
.product-image img {
    width: 100%;
    height: 100%;
    object-fit: contain;
    background-color: #f8f9fa;
}
.product-details {
    flex: 1;
}
.product-details h5 {
    font-weight: 600;
    color: #0d6efd;
}
.price {
    font-size: 1.2rem;
    color: #198754;
    font-weight: 600;
}
</style>
</head>
<body>

<div class="container">
<%
    String category = request.getParameter("category");
    if (category == null || category.trim().isEmpty()) {
%>
        <h3 class="text-center text-danger">Category not specified!</h3>
<%
    } else {
        List<Map<String, String>> products = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Project", "root", "root");

            // Assuming your product table has a 'category' column storing category names
            String sql = "SELECT * FROM product WHERE category LIKE ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, "%"+category+"%");
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> product = new HashMap<>();
                product.put("pid", rs.getString("pid"));
                product.put("name", rs.getString("product_name"));
                product.put("price", rs.getString("price"));
                 product.put("email", rs.getString("email"));
                 product.put("description", rs.getString("description"));
                product.put("condition", rs.getString("condition"));
                product.put("address", rs.getString("address"));
                products.add(product);
            }

%>
        <h3 class="text-center mb-4">Products in Category: <%= category %></h3>
<%
            if (products.isEmpty()) {
%>
                <p class="text-center text-muted">No products found in this category.</p>
<%
            } else {
                PreparedStatement ps2 = null;
                ResultSet rs2 = null;
                try {
                    ps2 = con.prepareStatement("SELECT fileContent FROM product WHERE pid = ?");
                    for (Map<String, String> product : products) {
                        ps2.setString(1, product.get("pid"));
                        rs2 = ps2.executeQuery();
                        String base64Image = null;

                        if (rs2.next()) {
                            Blob blob = rs2.getBlob("fileContent");
                            if (blob != null) {
                                byte[] bytes = blob.getBytes(1, (int) blob.length());
                                base64Image = Base64.getEncoder().encodeToString(bytes);
                            }
                        }
%>
                        <a href="productDetails.jsp?pid=<%= product.get("pid") %>" class="product-card text-decoration-none text-reset">
                            <div class="product-image">
                                <% if (base64Image != null) { %>
                                    <img src="data:image/jpeg;base64,<%= base64Image %>" alt="Product Image">
                                <% } else { %>
                                    <img src="https://via.placeholder.com/250x200?text=No+Image" alt="No Image">
                                <% } %>
                            </div>
                            <div class="product-details">
                                <h5><%= product.get("name") %></h5>
            					<p class="price">Price: <%= product.get("price") %></p>
								<p>Product Condition: <%= product.get("condition") %></p>
         					    <p>Product address: <%= product.get("address") %></p>
								<p>Product Description: <%= product.get("description") %></p>
                            </div>
                        </a>
<%
                        if (rs2 != null) rs2.close();
                    }
                } finally {
                    if (ps2 != null) ps2.close();
                    if (rs2 != null) rs2.close();
                }
            }
        } catch (Exception e) {
%>
            <div class="text-danger text-center">Error: <%= e.getMessage() %></div>
<%
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
