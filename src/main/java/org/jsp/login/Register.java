package org.jsp.login;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Register extends HttpServlet{
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String name=req.getParameter("unm");
		double phone=Double.parseDouble(req.getParameter("phn"));
		String dob=req.getParameter("dob");
		String email=req.getParameter("mail");
		String pass=req.getParameter("pass");
		String add=req.getParameter("add");
		
		Connection con=null;
		PreparedStatement ps=null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con=DriverManager.getConnection("jdbc:mysql://localhost:3306/Project","root","root");
			ps=con.prepareStatement("insert into user_info values(?,?,?,?,?,?)");
			ps.setString(1,name);
			ps.setDouble(2, phone);
			ps.setString(3, dob);
			ps.setString(4, email);
			ps.setString(5, pass);
			ps.setString(6, add);
			ps.executeUpdate();
			RequestDispatcher rs=req.getRequestDispatcher("login.html");
			rs.forward(req, resp);
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
