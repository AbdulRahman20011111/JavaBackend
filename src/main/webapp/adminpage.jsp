<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>All Users</title>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    body {
        font-family: 'Poppins', sans-serif;
        background: linear-gradient(135deg, #e3f2fd, #ffffff);
        padding: 30px;
        min-height: 100vh;
    }
    h1 {
        color: #0d6efd;
        font-weight: 700;
        text-align: center;
        margin-bottom: 40px;
    }
    table {
        background-color: #fff;
        box-shadow: 0 8px 20px rgba(13, 110, 253, 0.1);
        border-radius: 12px;
        overflow: hidden;
    }
    thead th {
        background-color: #0d6efd;
        color: #fff;
        font-weight: 600;
    }
    tbody tr:nth-child(even) {
        background-color: #f8f9fa;
    }
    tbody tr:hover {
        background-color: #dbe8ff;
        cursor: pointer;
    }
    .btn-danger {
        border-radius: 8px;
        padding: 6px 14px;
        font-weight: 600;
        transition: background-color 0.3s ease;
    }
    .btn-danger:hover {
        background-color: #bb2d3b;
    }
</style>

</head>
<body>

<div class="container">
    <h1>All User Details</h1>

    <div class="table-responsive">
        <table class="table table-bordered align-middle">
            <thead>
                <tr>
                    <th>S.no</th>
                    <th>Name</th>
                    <th>Mobile</th>
                    <th>DOB</th>
                    <th>Email</th>
                    <th>Address</th>
                    <th>Delete</th>
                </tr>
            </thead>
            <tbody>
                <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Project", "root", "root");
                    ps = con.prepareStatement("SELECT * FROM user_info");
                    rs = ps.executeQuery();
                    int sno = 1;

                    while (rs.next()) {
                        String name = rs.getString("name");  // use correct column names
                        String phone = rs.getString("phone");  // string for phone avoids decimal issues
                        String dob = rs.getString("dob");
                        String email = rs.getString("email");
                        String add = rs.getString("address");
                %>
                        <tr>
                            <td><%= sno++ %></td>
                            <td><%= name %></td>
                            <td><%= phone %></td>
                            <td><%= dob %></td>
                            <td><%= email %></td>
                            <td><%= add %></td>
                            <td>
                                <form action="deleteuser" method="post" onsubmit="return confirm('Are you sure you want to delete this user?');">
   									 <input type="hidden" name="email" value="<%= email %>">
 								   	 <button type="submit" class="btn btn-danger">Delete</button>
								</form>

                            </td>
                        </tr>
                <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='7' class='text-danger text-center'>Error: " + e.getMessage() + "</td></tr>");
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
                %>
            </tbody>
        </table>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
