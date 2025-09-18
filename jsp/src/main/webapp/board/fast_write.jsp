<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.File"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.IOException"%>
<%@ page import="java.nio.file.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="lib.DB" %>
    
<%

String ip = java.net.Inet4Address.getLocalHost().getHostAddress();

Date today = new Date();
SimpleDateFormat timeFormat = new SimpleDateFormat("yyyyMMddHHmmss");
String time = timeFormat.format(today);

String sql = "";
Connection conn=null;
Statement st = null;
ResultSet rs = null;
PreparedStatement ps = null;

try {
	conn = DB.getConnection();
	
	for (int i=1; i<=100; i++) {
	
		sql = "insert into board(name,pwd,title,content,regdate,ip) " +
				   " values(?,?,?,?,now(),?)";
		
		ps = conn.prepareStatement(sql);
		
		ps.setString(1, "홍길동"+i);
		ps.setString(2, "pwd"+i);
		ps.setString(3, "제목 " + i);
		ps.setString(4, "[ 내용내용내용 ]");
		ps.setString(5, ip);
		
		ps.executeUpdate();
	
	}
	
	response.sendRedirect("list.jsp");
	 
	 
}catch(Exception e){ 
	  out.println(e.toString());
	  out.println(sql);
}finally {
  	if (ps != null){
		   ps.close();
		}
  	if(rs != null){
		   rs.close();
		}
	if (st != null){
		   st.close();
		}
	if (conn != null){
		   conn.close();
		}
}

%>