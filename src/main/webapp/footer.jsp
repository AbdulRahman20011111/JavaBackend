<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%
    String currentPage = request.getRequestURI();
    boolean isBuyPage = currentPage.contains("index.jsp");
    boolean isSellPage = currentPage.contains("sell.jsp");
%>
<!DOCTYPE html>
<html>
<head>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            margin-bottom: 80px; /* space for fixed footer */
        }

        .footer {
            position: fixed;
            bottom: 0;
            width: 100%;
            height: 60px;
            display: flex;
            background-color: #f8f9fa;
            border-top: 1px solid #dee2e6;
            z-index: 1000;
        }

        .footer-section {
            flex: 1;
            text-align: center;
            line-height: 60px;
            font-size: 1.1rem;
            text-decoration: none;
            font-weight: 500;
            color: #333;
            position: relative;
        }

        .footer-section i {
            margin-right: 6px;
        }

        .footer-section.active {
            color: #0d6efd;
        }

        .footer-section.active::before {
            content: "";
            position: absolute;
            top: 0;
            left: 30%;
            width: 40%;
            height: 3px;
            background-color: #0d6efd;
            border-radius: 2px;
        }
    </style>
</head>
<body>

<footer class="footer">
    <a href="index.jsp" class="footer-section <%= isBuyPage ? "active" : "" %>">
        <i class="bi bi-cart3"></i> Buy
    </a>
    <a href="sell.jsp" class="footer-section <%= isSellPage ? "active" : "" %>">
        <i class="bi bi-plus-circle"></i> Sell
    </a>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
