<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
    <%@ page import="lib.DB" %>

<%
boolean is_login = false;
String login_id = "";
/*
Cookie[] cookies = request.getCookies();

if(cookies != null && cookies.length > 0){
   for(int i = 0; i < cookies.length; i++){
      
      if(cookies[i].getName().equals("login_check") && cookies[i].getValue().length() > 0)
      {
         is_login  = true;
         login_id = cookies[i].getValue();
         break;
      }
   }
}
*/
login_id = (String)session.getAttribute("ss_check");

//if(is_login == false)
if(login_id == null || login_id.equals(""))
{
%>
<script>
alert("로그인 하세요.");
location.replace("Login.jsp");
</script>
<%
	return;
}
%>


<%
	String sql = "";
	Connection conn=null;
	Statement st = null;
	ResultSet rs = null;
	String key = request.getParameter("key");
	String word = request.getParameter("word");
	if (key == null) {key = "";}
	if (word == null) {word = "";}
	int totalp = 0; //총 페이지
	int scale = 10; //페이지 당 게시물---------------------------------------------------------------
	int offset = 0; //디비 오프셋
	double count =0; //
	String _page = request.getParameter("_page");
	if (_page == null) _page = "1";
	int now_page = Integer.parseInt(_page); //현재 페이지
	
	offset = (now_page-1)*scale ;

	try {
		conn = DB.getConnection();
		sql = "select count(*) as cnt from member";
		st = conn.createStatement();
		rs = st.executeQuery(sql);
		rs.next();
		count = rs.getDouble("cnt");
		double countt = Math.ceil(count/scale);
		totalp = (int)countt;
		
		}catch (Exception e) {
			out.println(sql);
		}
	
	//int page_size = 3;
	int page_scale = 10; // ----------------------------------------------------------------------
	int page_group = (int)Math.ceil((double)totalp/page_scale);
	int page_group_start = ((now_page-1)/page_scale)*page_scale+1;
	int page_group_end = page_group_start+page_scale-1;
    if (page_group_end>totalp) {
    	page_group_end=totalp;
    }
    
	String suid = request.getParameter("uid");

	try {
		conn = DB.getConnection();
		
		if(word != null && !word.equals("")) {
			sql = " SELECT count(*) as cnt from member where "+key+" like '%"+word+"%'";
		}else {
			sql = " SELECT count(*) as cnt from member ";
		}
		
	}catch (Exception e) {
		System.out.println(sql);
	}
	
		st = conn.createStatement();
	   	rs = st.executeQuery(sql);
	   	rs.next();
	   	count = rs.getInt("cnt");
	   	double dcount = count;
	   	int ccount = (int)count;
%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>List</title>
<style>
* {
margin : 0 auto;
text-align: center;
}
h1 {
margin : 20px;
}
td {
padding: 10px;
text-align: center;
}
.aa {
padding: 5px;
text-decoration: none;
color: green;
}
.aadisable {
color: gray;
}
.aaa {
font-size: 30px;
color: blue;
}
</style>
</head>
<body>
	<%
   //Connection conn=null;
   //Statement st = null;
   //ResultSet rs = null;
    
   //String sql = null;

  try{
    
    conn = DB.getConnection();
    //out.println("연결 성공");
    
   //쿼리문 작성
   if(word != null && !word.equals("")) {
      sql = " SELECT * from member where "+key+" like '%"+word+"%' ORDER BY idx desc limit "+offset+", "+scale;
   } else {
	   sql = " select * from member order by idx desc limit "+offset+"," + scale;
   }
   
   
   
   //Connection객체로부터 Statement객체를 얻어내는 코드
   st = conn.createStatement();
   
   rs = st.executeQuery(sql);
    
  }catch(Exception e){ 
    e.printStackTrace();
    out.println(sql);
  }
%>

<h1>리스트 페이지</h1>

<%
	if(word != null && !word.equals("")) {
%>
		검색컬럼: <%= key %> | 검색어: <%= word %> | 검색된 갯수: <%= (int)count %>
<%
	}
%>
<a href="Logout.jsp"><button type="button">로그아웃</button></a>
<a href="Join.jsp"><button type="button">회원입력</button></a>
<br><br>

<table border="1">
   <tr>
      <td>기본키</td>
      <td>아이디</td>
      <td>비밀번호</td>
      <td>이름</td>
      <td>성별</td>
      <td>생일</td>
      <td>취미</td>
      <td>등록일</td>
      <td>파일</td>
   </tr>
<%   
   while (rs.next()) {
      String idx = rs.getString("idx");
      String uid = rs.getString("uid");
      String upassword = rs.getString("upassword");
      String name = rs.getString("name");
      String sex = rs.getString("sex");
      String birth = rs.getString("birth");
      String hobby = rs.getString("hobby");
      String regdate = rs.getString("regdate");
      String upfile = rs.getString("upfile");
      String originalfile = rs.getString("originalfile");
      String originaldir = rs.getString("originaldir");
      //경로 폴더이름만 뽑기
	  int index = 0;
	  	if (originaldir != null) {
	  		index = originaldir.lastIndexOf("\\");
	  	}
	  	
	  	String extension ="";
		if (index > 0) {
			extension = originaldir.substring(index + 1);
			//System.out.println(extension); //확장자 시스템 출력
		}
%>
   <tr>
      <td><%= idx %></td>
      <td><a href="View.jsp?uid=<%= uid %>"><%= uid %></a></td>
      <td><%= upassword %></td>
      <td><%= name %></td>
      <td><%= sex %></td>
      <td><%= birth %></td>
      <td><%= hobby %></td>
      <td><%= regdate %></td>
      <td><img alt="<%= originalfile %>" src="Download.jsp?uid=<%= uid %>" width="50" height="50"></td>
   </tr>   
<%
   }
%>   
</table>



<%
	int pageCount = ccount / scale + (ccount%scale==0?0:1);

	if (page_group_start>1) { %>
    <a href="List.jsp?_page=<%= page_group_start-1 %>&key=<%= key %>&word=<%= word %>" class="aa">◀</a>
<% 
	}else {
%>
		<a class="aa aadisable" >◀</a>
<%
	}
	for (int i=page_group_start; i<=page_group_end; i++) {
		if(i==now_page) {
%>
			<a href="List.jsp?_page=<%= i %>&key=<%= key %>&word=<%= word %>" class="aa aaa"><%= i %></a>
<%
		}else if (i<=Math.ceil(dcount/10)) { //totalp
%>
			<a href="List.jsp?_page=<%= i %>&key=<%= key %>&word=<%= word %>" class="aa"><%= i %></a>
<%
		}
	}
	if (page_group_end<pageCount) { 
%>
    	<a href="List.jsp?_page=<%= page_group_end+1 %>&key=<%= key %>&word=<%= word %>" class="aa">▶</a>
<%
	}else {
%>
		<a class="aa aadisable">▶</a>
<%	
	}
%>
	<form method="get">
	    <input type="number" name="_page" min="1" max="<%= Math.ceil(dcount/10) %>" value="<%= now_page %>">
	    <input type="hidden" name="key" value=<%= key %>>
		<input type="hidden" name="word" value=<%= word %>>
	    <button type="submit">이동</button>
	</form>
	
	<form name="search_form" method="get">
		<select name="key">
			<option value="uid">아이디</option>
			<option value="name">이름</option>
			<option value="hobby">취미</option>
		</select>
		<input type="text" name="word">
		<button type="submit">검색</button>
	</form>

<br><br>


</body>
</html>

<%
if (rs != null){
   rs.close();
}

if (st != null){
   st.close();
}

if (conn != null)
{
   conn.close();
}
%>