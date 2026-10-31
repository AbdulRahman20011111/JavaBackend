<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Edit Profile</title>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

<style>
    body {
        background: linear-gradient(135deg, #74ebd5, #ACB6E5);
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        min-height: 100vh;
    }
    .edit-container {
        background-color: #fff;
        border-radius: 20px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        padding: 40px;
        max-width: 600px;
        margin: 80px auto;
    }
    h2 {
        text-align: center;
        color: #0d6efd;
        margin-bottom: 30px;
    }
    .form-control {
        border-radius: 10px;
    }
    .btn-primary {
        border-radius: 10px;
        width: 100%;
    }
    .password-container {
        position: relative;
    }
    .toggle-password {
        position: absolute;
        top: 50%;
        right: 15px;
        transform: translateY(-50%);
        cursor: pointer;
        color: #0d6efd;
    }
</style>
</head>
<body>

<%
    HttpSession sess = request.getSession();
    String email = (String)sess.getAttribute("e");
    String name = (String)sess.getAttribute("n");
    String dob = (String)sess.getAttribute("d");
    String add = (String)sess.getAttribute("a");
    int phone = (Integer)sess.getAttribute("ph");
    String password = (String)sess.getAttribute("p");
%>

<div class="container">
    <div class="edit-container">
        <h2>Edit Profile</h2>
        <form action="ed.jsp" method="post">
            <div class="mb-3">
                <label for="email" class="form-label">Email address</label>
                <input type="email" name="email" id="email" class="form-control" value="<%= email %>" required readonly>
            </div>

            <div class="mb-3">
                <label for="name" class="form-label">Full Name</label>
                <input type="text" name="name" id="name" class="form-control" value="<%= name %>" required>
            </div>

            <div class="mb-3">
                <label for="dob" class="form-label">Date of Birth</label>
                <input type="date" name="dob" id="dob" class="form-control" value="<%= dob %>" required>
            </div>

            <div class="mb-3">
                <label for="address" class="form-label">Address</label>
                <textarea name="address" id="address" class="form-control" rows="3" required><%= add %></textarea>
            </div>

            <div class="mb-3">
                <label for="phone" class="form-label">Phone Number</label>
                <input type="tel" name="phone" id="phone" class="form-control" value="<%= phone %>" pattern="[0-9]{10}" required>
            </div>

            <!-- Password Field with Show/Hide Icon -->
            <div class="mb-3 password-container">
                <label for="password" class="form-label">Password</label>
                <input type="password" name="password" id="password" class="form-control" value="<%= password %>" required>
                <i class="bi bi-eye-slash toggle-password" id="togglePassword"></i>
            </div>

            <button type="submit" class="btn btn-primary mt-3">Update Profile</button>
        </form>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Show/Hide Password Script -->
<script>
    const togglePassword = document.getElementById('togglePassword');
    const password = document.getElementById('password');

    togglePassword.addEventListener('click', () => {
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        togglePassword.classList.toggle('bi-eye');
        togglePassword.classList.toggle('bi-eye-slash');
    });
</script>

</body>
</html>
