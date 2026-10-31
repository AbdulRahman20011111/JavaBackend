<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession s= request.getSession();
    String userName = null;
    String role = null;

    if (s != null) {
        userName = (String) s.getAttribute("email");
        System.out.println("hello "+userName);
        role = (String) s.getAttribute("role");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Navbar</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        .navbar {
            background: linear-gradient(90deg, #e3f2fd, #f8f9fa);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            font-weight: 600;
            color: #0d6efd !important;
        }

        .nav-link {
            color: #333 !important;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: color 0.3s ease;
        }

        .nav-link:hover {
            color: #0d6efd !important;
        }

        /* Dropdown hover effect */
        .nav-item.dropdown:hover > .dropdown-menu {
            display: block;
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
            transition: all 0.3s ease;
        }

        .dropdown-menu {
            opacity: 0;
            visibility: hidden;
            transform: translateY(10px);
            transition: all 0.3s ease;
        }

        .dropdown-menu a {
            color: #333;
            transition: all 0.3s ease;
        }

        .dropdown-menu a:hover {
            background-color: #e9ecef;
            color: #0d6efd;
        }

        /* Search box */
        .search-box {
            position: relative;
            display: flex;
            align-items: center;
            margin-left: 10px;
            transition: all 0.4s ease;
        }

        .search-input {
            width: 0;
            opacity: 0;
            border: 1px solid #ced4da;
            background: #ffffff;
            outline: none;
            color: #333;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 15px;
            transition: all 0.4s ease;
        }

        .search-box:hover .search-input,
        .search-input:focus {
            width: 200px;
            opacity: 1;
            box-shadow: 0 0 10px rgba(13, 110, 253, 0.3);
            border-color: #0d6efd;
        }

        .search-icon {
            font-size: 1.3rem;
            color: #0d6efd;
            cursor: pointer;
            animation: beat 1.6s infinite;
            transition: transform 0.3s ease, color 0.3s ease;
            margin-right: 6px;
        }

        @keyframes beat {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.2); }
        }

        .search-icon:hover {
            color: #084298;
            transform: rotate(10deg);
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="index.jsp">
            <i class="bi bi-shop"></i> Local Marketplace
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
                data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" 
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- Left Menu -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <!-- Home -->
                <li class="nav-item">
                    <a class="nav-link" href="index.jsp">
                        <i class="bi bi-house-door"></i> Home
                    </a>
                </li>

                <!-- Categories Dropdown -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="categoriesDropdown" 
                       role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-grid"></i> Categories
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="categoriesDropdown">
                        <li><a class="dropdown-item" href="CategoryNextPage.jsp?category=Electronics"><i class="bi bi-phone"></i> Electronics</a></li>
                        <li><a class="dropdown-item" href="CategoryNextPage.jsp?category=Clothing"><i class="bi bi-bag"></i> Clothing</a></li>
                        <li><a class="dropdown-item" href="CategoryNextPage.jsp?category=Groceries"><i class="bi bi-basket"></i> Groceries</a></li>
                        <li><a class="dropdown-item" href="CategoryNextPage.jsp?category=Books"><i class="bi bi-book"></i> Books</a></li>
                        <li><a class="dropdown-item" href="CategoryNextPage.jsp?category=Home"><i class="bi bi-house"></i> Home & Living</a></li>
                        <li><a class="dropdown-item" href="CategoryNextPage.jsp?category=Beauty"><i class="bi bi-brush"></i> Beauty</a></li>
                    </ul>
                </li>

                <!-- Search bar beside Categories -->
                <li class="nav-item search-box">
                    <i class="bi bi-search search-icon"></i>
                    <span class="text-dark me-2">Search</span>
                    <form action="index.jsp" method="get">
                        <input class="search-input" type="text" name="query" placeholder="Search products...">
                    </form>
                </li>

                <% if (role != null && role.equals("seller")) { %>
                <li class="nav-item">
                    <a class="nav-link" href="addProduct.jsp">
                        <i class="bi bi-plus-circle"></i> Add Product
                    </a>
                </li>
                <% } %>

                <% if (role != null && role.equals("admin")) { %>
                <li class="nav-item">
                    <a class="nav-link" href="adminDashboard.jsp">
                        <i class="bi bi-gear"></i> Admin
                    </a>
                </li>
                <% } %>
            </ul>

            <!-- Right Menu -->
            <ul class="navbar-nav ms-auto">
                <% if (userName != null) { %>
                	<% 
                	Class.forName("com.mysql.cj.jdbc.Driver");
                	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/project","root","root");
                	PreparedStatement ps=con.prepareStatement("Select email from product where email=?");
                	ps.setString(1, userName);
                	ResultSet rs=ps.executeQuery();
                	String email="";
                	if(rs.next()){
                		email=rs.getString("email");
                	}
                	if(userName.equals(email)){
                	%>
                	<li class="nav-item">
                        <a class="nav-link" href="userItems.jsp">
                        <%session.setAttribute("emial", email); %>
                            <i class="bi bi-person-lines-fill"></i> Your Items
                        </a>
                    </li>
                    <%} %>
                    <li class="nav-item">
                        <a class="nav-link disabled text-secondary" href="#">
                            <i class="bi bi-person-circle"></i> <%= userName %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="profile.jsp">
                            <i class="bi bi-person-lines-fill"></i> Profile
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-danger" href="login.html">
                            <i class="bi bi-box-arrow-right"></i> Logout
                        </a>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="login.html">
                            <i class="bi bi-box-arrow-in-right"></i> Login
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="register.html">
                            <i class="bi bi-person-plus"></i> Register
                        </a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Optional: Keep click working on mobile -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        if (window.innerWidth < 992) {
            const dropdowns = document.querySelectorAll('.nav-item.dropdown');
            dropdowns.forEach(dd => {
                dd.addEventListener('mouseenter', () => dd.classList.remove('show'));
                dd.addEventListener('mouseleave', () => dd.classList.remove('show'));
            });
        }
    });
</script>

</body>
</html>
