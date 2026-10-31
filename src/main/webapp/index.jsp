<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.util.*, java.util.Base64" %>
<%@ include file="navbar.jsp" %>
<%@ include file="footer.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Local Marketplace</title>
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

/* --- Category section --- */
.category-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 40px;
    justify-items: center;
    align-items: center;
    padding: 30px;
    text-align: center;
}
a.category-card {
    display: block;
    text-decoration: none;
    color: inherit;
}

.category-card {
    background: #fff;
    border-radius: 16px;
    padding: 45px 25px;
    box-shadow: 0 6px 14px rgba(0,0,0,0.1);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    cursor: pointer;
    width: 100%;
    max-width: 320px;
}
.category-card:hover {
    transform: scale(0.95);
    box-shadow: 0 8px 20px rgba(0,0,0,0.15);
}
.category-card i {
    font-size: 60px; /* slightly smaller */
    color: #0d6efd;
    margin-bottom: 20px;
}
.category-card h5 {
    font-weight: 600;
    font-size: 1.3rem;
}

/* --- Search Results --- */
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
}
.product-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 18px rgba(0,0,0,0.15);
}
.product-card:active {
    transform: scale(0.97);
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

<%
    String query = request.getParameter("query");
    List<Map<String, String>> results = new ArrayList<>();

    if (query != null && !query.trim().isEmpty()) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Project", "root", "root");

            //  Original query (unchanged)
            String sql = "SELECT * FROM product WHERE product_name LIKE ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, "%" + query + "%");
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
                results.add(product);
            }

        } catch (Exception e) {
            out.println("<div class='text-danger text-center'>Error: " + e.getMessage() + "</div>");
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
    }
%>

<div class="container">
    <% if (query != null && !query.trim().isEmpty()) { %>
        <h3 class="text-center mb-4">Search Results for "<%= query %>"</h3>

        <% if (results.isEmpty()) { %>
            <p class="text-center text-muted">No products found matching your query.</p>
        <% } else { 
            Connection con2 = null;
            PreparedStatement ps2 = null;
            ResultSet rs2 = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/Project", "root", "root");
                ps2 = con2.prepareStatement("SELECT fileContent FROM product WHERE pid = ?");
                
                for (Map<String, String> product : results) {
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
                    <a href="productDetails.jsp?pid=<%= product.get("pid") %>" class="text-decoration-none text-reset">
    <div class="product-card">
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
                        
<%-- 	<p>Product Description: <%= product.get("description") %></p>
 --%>            
        </div>
    </div>
</a>

        <%
                    if (rs2 != null) rs2.close();
                }
            } catch (Exception e) {
                out.println("<p>Error loading images: " + e.getMessage() + "</p>");
            } finally {
                if (rs2 != null) rs2.close();
                if (ps2 != null) ps2.close();
                if (con2 != null) con2.close();
            }
        } %>

    <% } else { %>
        <h3 class="text-center mb-4 text-primary">Explore Categories</h3>
        <div class="category-grid">
    <a href="CategoryNextPage.jsp?category=Electronics" class="category-card">
        <i class="bi bi-laptop"></i>
        <h5>Electronics</h5>
    </a>
    <a href="CategoryNextPage.jsp?category=Clothing" class="category-card">
        <i class="bi bi-bag"></i>
        <h5>Clothing</h5>
    </a>
    <a href="CategoryNextPage.jsp?category=Home+%26+Living" class="category-card">
        <i class="bi bi-house-door"></i>
        <h5>Home &amp; Living</h5>
    </a>
    <a href="CategoryNextPage.jsp?category=Books" class="category-card">
        <i class="bi bi-book"></i>
        <h5>Books</h5>
    </a>
    <a href="CategoryNextPage.jsp?category=Groceries" class="category-card">
        <i class="bi bi-basket"></i>
        <h5>Groceries</h5>
    </a>
    <a href="CategoryNextPage.jsp?category=Beauty" class="category-card">
        <i class="bi bi-heart"></i>
        <h5>Beauty</h5>
    </a>
    <a href="CategoryNextPage.jsp?category=Sports" class="category-card">
        <i class="bi bi-trophy"></i>
        <h5>Sports</h5>
    </a>
</div>

    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
