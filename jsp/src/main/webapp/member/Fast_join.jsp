<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="lib.DB" %>

<% 
	String a = request.getParameter("uid");

	if( a == null || a.equals("")){
%>
	<script>
		alert("아이디를 입력하세요.");
		location.replace("Join.jsp");
	</script>
<%
	   return;
	}
	
	
	String sql = "";
	Connection conn=null;
	Statement st = null;
	ResultSet rs = null;
	try {
		conn = DB.getConnection();
		sql = "select count(*) as cnt from member where uid='"+a+"'";
		st = conn.createStatement();
		rs = st.executeQuery(sql);
		rs.next();
		int count = rs.getInt("cnt");
		if (count > 0) {
%>
			<script>
				alert("아이디 중복");
				location.replace("Join.jsp");
			</script>
<%
		return;
		}
	}catch (Exception e) {
		out.println(sql);
	}
	
	
	String b = request.getParameter("upass1");
	String c = request.getParameter("upass2");
	
	if(!b.equals(c)){
%>
		<script>
			alert("비밀번호가 일치하지 않습니다.");
			location.replace("Join.jsp");
		</script>   
<%
		return;
	}
	
	if( b == null || b.equals("")){
		%>
			<script>
				alert("비밀번호를 입력하세요.");
				location.replace("Join.jsp");
			</script>
		<%
			return;
	}
	
	String d = request.getParameter("uname");
	
	if( d == null || d.equals("")){
		%>
			<script>
				alert("이름을 입력하세요.");
				location.replace("Join.jsp");
			</script>
		<%
			return;
	}
	
	String ee = request.getParameter("sex");
	String yy = request.getParameter("yyyy");
	String mm = request.getParameter("mm");
	String dd = request.getParameter("dd");
	String ff[] = request.getParameterValues("hobby");
	String yymmdd = yy+"-"+mm+"-"+dd;
	String hobby = "";
	String [] h = request.getParameterValues("hobby");
	if(h != null)
	{
	   hobby = String.join(",", h);
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가입정보</title>
</head>
<body>
<%
	


	if (b.equals(c)==false) {
		request.getRequestDispatcher("Join.jsp?loginerr=1").forward(request, response);
	}
	else {
%>

	아이디 : <%= a %><br>
	비밀번호 : <%= b %><br>
	비밀번호 확인 : <%= c %><br>
	이름 : <%= d %><br>
	성별 : <%= ee %><br>
	생일 : <%= yymmdd %><br>
	취미 : <%= hobby %><br>
		  
		  
		  
		  
		  <%
		  //String sql = "";
		  //Connection conn=null;
			  //Connection conn=null;
			PreparedStatement ps = null;
			  try{
				 
				 conn = DB.getConnection();
				 
				 for (int i=1; i<=177; i++) {
					 
					 sql = "insert into member(uid,upassword,upasscheck,name,sex,birth,hobby,regdate) " +
							" values(?,?,?,?,?,?,?, now())";
					 
					 ps = conn.prepareStatement(sql);
					   
					   ps.setString(1, a+i);
					   ps.setString(2, b+i);
					   ps.setString(3, c+i);
					   ps.setString(4, d+i);
					   ps.setString(5, ee);
					   ps.setString(6, yymmdd);
					   ps.setString(7, hobby);
					 
					   ps.executeUpdate();
					 
				 }
				 
				 out.println("등록성공");
				 
				 response.sendRedirect("List.jsp");
				 
				 
			  }
			  catch(Exception e){ 
				  out.println(e.toString());
				  out.println(sql);
			  }
			  finally {
				  	if (rs != null){
					   rs.close();
					}
					if (st != null){
					   st.close();
					}
					if (conn != null){
					   conn.close();
					}
			  }
	}
		  %>
</body>
</html>