package org.jsp.login;


import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Base64;
import java.util.HashSet;
import java.util.Random;
import java.util.Set;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.mysql.cj.jdbc.Blob;

@MultipartConfig
public class SellServer extends HttpServlet{
	

	
	 private static final Random rand = new Random();

	    public static int pid(Set<Integer> s) {
	        int x = rand.nextInt(10000); // Generates 0 to 9999
	        while (s.contains(x)) {
	            x = rand.nextInt(10000);
	        }
	        s.add(x);
	       // System.out.println(x);
	        return x;
	    }
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String name=req.getParameter("name");
		String category=req.getParameter("category");
		String addresss=req.getParameter("address");
		String description=req.getParameter("description");
		double price=(double)Integer.parseInt(req.getParameter("price"));
		String email=req.getParameter("email");
		Part filePart=req.getPart("image");
		InputStream fileContent=filePart.getInputStream();
		String condition=req.getParameter("condition");
		
//        resp.setContentType("text/html");
//        PrintWriter pw = resp.getWriter();
//        pw.println("<html><body>");
//        pw.println("<h3>Image Uploaded and Retrieved:</h3>");
//        pw.println("<img src='data:image/jpeg;base64," + base64Image + "' width='300' />");
//        pw.println("</body></html>");
		//System.out.println(name +"" +condition);
		
		
		Connection con=null;
		PreparedStatement ps=null;
		String qry="insert into product values(?,?,?,?,?,?,?,?,?)";
//		String qry="delete from product where product_name='TV'";
		Set<Integer> s=new HashSet<Integer>();
		s.add(1);
//		System.out.println(pid(s));
		

		try {
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			con=DriverManager.getConnection("jdbc:mysql://localhost:3306/project","root","root");
			ps=con.prepareStatement(qry);
			ps.setInt(1,pid(s) );
			ps.setString(2,name);
			ps.setString(3,category+"."+name);	
			ps.setDouble(4,price);
			ps.setString(5, email);
			ps.setString(6, description); 
			ps.setString(7, condition);
			ps.setString(8, addresss);
		    ps.setBlob(9, fileContent);



			
			ps.executeUpdate();
			
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			if (con!=null) {
				try {
					con.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if (ps!=null) {
				try {
					ps.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
		}
		
  RequestDispatcher rd=req.getRequestDispatcher("index.jsp");
  rd.forward(req, resp);
	}

}
