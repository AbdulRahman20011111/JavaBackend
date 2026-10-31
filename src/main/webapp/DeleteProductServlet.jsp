<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<% String productId = request.getParameter("productId");
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/Project","root","root");
        String sql = "DELETE FROM product WHERE pid=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, productId);
        ps.executeUpdate();
        ps.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
    response.sendRedirect("userItems.jsp"); %>
</body>
</html>