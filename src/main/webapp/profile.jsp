<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>User Profile</title>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

<style>
    body {
        background: linear-gradient(to right, #74ebd5, #ACB6E5);
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        min-height: 100vh;
    }
    .profile-card {
        background-color: #fff;
        border-radius: 20px;
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
        padding: 40px;
        max-width: 700px;
        margin: 80px auto;
        text-align: center;
        transition: 0.3s;
    }
    .profile-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
    }
    .profile-img {
        width: 150px;
        height: 150px;
        object-fit: cover;
        border-radius: 50%;
        border: 5px solid #0d6efd;
        margin-bottom: 20px;
    }
    .profile-info h3 {
        color: #0d6efd;
        font-weight: 600;
    }
    .profile-info p {
        font-size: 1.1rem;
        color: #555;
    }
    .info-row {
        text-align: left;
        margin-top: 20px;
    }
    .info-row i {
        color: #0d6efd;
        width: 25px;
    }
</style>
</head>

<body>
<%
HttpSession sess = request.getSession();
String email = (String)sess.getAttribute("email");
String qry = "SELECT * FROM user_info WHERE email=?";
int phone=0;
String name="", address="", city="",password="",dob="";
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/project","root","root");
    PreparedStatement ps = con.prepareStatement(qry);
    ps.setString(1, email);
    ResultSet rs = ps.executeQuery();

    if(rs.next()) {
        
        name = rs.getString(1);
        email = rs.getString(4);
        phone = rs.getInt(2);
        address = rs.getString(6);
        password=rs.getString(5);
        dob=rs.getString(3);
        
    }
    con.close();
} catch(Exception e) {
    out.println("<div class='alert alert-danger text-center mt-5'>Error: "+e.getMessage()+"</div>");
}
%>

<div class="container">
    <div class="profile-card">
        <img src="https://cdn-icons-png.flaticon.com/512/847/847969.png" alt="Profile Picture" class="profile-img">
        <div class="profile-info">
            <h3><%= name %></h3>
            <p><i class="bi bi-envelope"></i> <%= email %></p>
        </div>

        <div class="info-row">
            <p><i class="bi bi-telephone"></i> <strong>Phone:</strong> <%= phone %></p>
            <p><i class="bi bi-geo-alt"></i> <strong>Address:</strong> <%= address %></p>
            
        </div>

        <div class="mt-4">
            <a href="editprofile.jsp" class="btn btn-primary px-4"><i class="bi bi-pencil"></i> Edit Profile</a>
            <a href="logout.jsp" class="btn btn-outline-danger px-4"><i class="bi bi-box-arrow-right"></i> Logout</a>
        </div>
    </div>
</div>
<%
sess.setAttribute("n", name);
sess.setAttribute("ph", phone);
sess.setAttribute("e", email);
sess.setAttribute("p", password);
sess.setAttribute("a", address);
sess.setAttribute("d", dob);



%>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
