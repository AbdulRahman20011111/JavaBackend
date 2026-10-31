package org.jsp.login;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.mysql.cj.Session;

public class Login extends HttpServlet{
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String nm=req.getParameter("nm");
		String role="user";
		String pwd=req.getParameter("pwd");
		System.out.println(nm);
		Connection con=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con=DriverManager.getConnection("jdbc:mysql://localhost:3306/Project","root","root");
			ps=con.prepareStatement("select * from user_info where Email=? and Password=?");
			ps.setString(1, nm);
			ps.setString(2, pwd);
			rs=ps.executeQuery();
			
			if(rs.next()) {
				HttpSession s=req.getSession();
				s.setAttribute("email", nm);
				s.setAttribute("user", role);
				
				RequestDispatcher rd=req.getRequestDispatcher("index.jsp");
				rd.forward(req, resp);
			}else {
				PrintWriter pw=resp.getWriter();
				pw.println("<html><body>"
						+ "<h1>Invalid Credentials!!!</h1>"
						+ "<button><a href='login.html'>Try Again</a></button>"
						+ "</body></html>");
			}
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
}
