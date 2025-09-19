<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>    
<%@ page import="lib.DB" %>
<%@page import="java.io.File"%>
<%
String login_id = "";
login_id = (String)session.getAttribute("ss_check");
%>
<%
String idx = request.getParameter("idx");
String delpass = request.getParameter("delpass");
String uid = null;
String pwd = null;
String bidx = null;

String sql = "";
Connection conn=null;
PreparedStatement ps = null;
ResultSet rs = null;

try{
    conn = DB.getConnection();
    {
    	sql = "SELECT c.*, m.upassword as pwd from comment c LEFT JOIN member m ON c.uid = m.uid where c.idx=?";
    	ps = conn.prepareStatement(sql);
    	ps.setString(1, idx);
		rs = ps.executeQuery();
		rs.next();
		uid = rs.getString("uid");
		pwd = rs.getString("pwd");
		bidx = rs.getString("bidx");
    }
    
    if(login_id == null || !login_id.equals(uid))
    {
    	%>
    	<script>
    	alert("댓글을 작성한 계정이 아닙니다.");
    	history.back();
    	</script>
    	<%
    	return;
    }
    
    if(delpass == null || !delpass.equals(pwd))
    {
    	%>
    	<script>
    	alert("비밀번호가 틀렸습니다.");
    	history.back();
    	</script>
    	<%
    	return;
    }

   sql = " delete from comment where idx ='"+idx+"' ";

   Statement st = conn.createStatement();

   st.executeUpdate(sql);

   %>
	<script>
		alert("삭제 성공");
		location.replace("view.jsp?idx=<%= bidx %>");
	</script>
	<%
   
   //response.sendRedirect("list.jsp");
    
  }catch(Exception e){ 
    e.printStackTrace();
    out.println(sql);
  }finally {
	  	if (rs != null){
		   rs.close();
		}
	  	
	  	if (ps != null){
			   ps.close();
			}

		if (conn != null){
		   conn.close();
		}
  }

%>