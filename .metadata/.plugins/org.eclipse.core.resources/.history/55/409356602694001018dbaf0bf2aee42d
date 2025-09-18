<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="lib.DB" %>
<%
String login_id = "";
login_id = (String)session.getAttribute("ss_check");
String login_idx = "";
String login_name = "";
String login_upfile = "";
int login_rank = -1;

if(login_id == null || login_id.equals("") || login_id.equals("null")) {
}else {
	String sqll = null;
	Connection connl =null;
	PreparedStatement psl = null;
	ResultSet rsl = null;
	
	try {
		
		connl = DB.getConnection();
		
		sqll = "SELECT * FROM member WHERE uid=?";
		psl = connl.prepareStatement(sqll);
		psl.setString(1, login_id);
		
		rsl = psl.executeQuery();
		rsl.next();
		
		login_idx = rsl.getString("idx");
		login_name = rsl.getString("name");
		login_upfile = rsl.getString("upfile");
		login_rank = rsl.getInt("member_rank");
		
	}catch (Exception e) {
		out.println(e.toString());
		out.println(sqll);
	}
}
%>

<style>
.min-height {
	min-height: 760px;
}
*{
	margin: 0 auto;
	padding: 0;
	text-align: center;
	box-sizing: border-box;
}
.board-header {
    background-color: #f8f9fa;
    border-bottom: 2px solid #e9ecef;
    padding: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    margin: 0 auto;
}

.board-header h1 {
    font-size: 28px;
    color: #343a40;
    margin: 0;
    font-weight: bold;
    text-align: left;
}

.board-header h1 a {
	font-size: 28px;
    color: #343a40;
    margin: 0;
    font-weight: bold;
    text-decoration: none;
}

.board-header nav ul {
    list-style: none;
    padding: 0;
    margin: 0;
    display: flex;
    gap: 50px;
    text-align: right;
}

.board-header nav li a {
    text-decoration: none;
    /*color: #495057;*/
    font-size: 16px;
    font-weight: 500;
    transition: color 0.3s ease;
}

header img {
	width: 40px;
    height: 40px;
    border-radius: 4px;
    border: 1px solid #ced4da;
}

.logout-btn {
    display: inline-block;
    padding: 8px 16px;
    border: none;
    border-radius: 4px;
    background-color: gray;
    color: white;
    cursor: pointer;
    text-decoration: none;
    transition: background-color 0.3s ease;
}
.logout-btn:hover {
    background-color: #dc3545;
}

.mypage-btn {
    display: inline-block;
    padding: 8px 16px;
    border: none;
    border-radius: 4px;
    background-color: gray;
    color: white;
    cursor: pointer;
    text-decoration: none;
    transition: background-color 0.3s ease;
}
.mypage-btn:hover {
    background-color: #007bff;
}

.user-info {
    display: inline-block;
    padding: 8px 16px;
    border: 1px solid gray;
    border-radius: 4px;
    color: black;
    font-size: 16px;
    font-weight: 500;
    transition: background-color 0.3s ease;
}


</style>
<% if(login_id == null || login_id.equals("") || login_id.equals("null")) { %>
<header class="board-header">
    <h1><a href="../board_proc/main_proc.jsp">게 시 판</a></h1>
    <nav>
        <ul>
            <li><span class="user-info">비로그인</span></li>
            <li> &nbsp; &nbsp; &nbsp; &nbsp; </li>
            <li><a href="../member/Join.jsp" class="mypage-btn">회원가입</a></li>
            <li><a href="../member/Login.jsp" class="mypage-btn">로그인</a></li>
        </ul>
    </nav>
</header>
<% }else { %>
<header class="board-header">
    <h1><a href="../board_proc/main_proc.jsp">게 시 판</a></h1>
    <nav>
        <ul>
            <li><span class="user-info">닉네임 : <%= login_name %></span></li>
            <% if (login_upfile == null || login_upfile.equals("")) { %>
            	<li> &nbsp; &nbsp; &nbsp; &nbsp; </li>
            <% }else { %>
            	<li><img alt="X" src="../member/Download.jsp?uid=<%= login_id %>"></li>
            <% } %>
            <li><a href="../member/View.jsp?uid=<%= login_id %>" class="mypage-btn">마이페이지</a></li>
            <li><a href="../member/Logout.jsp" class="logout-btn">로그아웃</a></li>
        </ul>
    </nav>
</header>
<% } %>
