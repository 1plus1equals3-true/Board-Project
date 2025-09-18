<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

리스트 노티스
String sql = "select count(*) as cnt from board WHERE boardtype = '0'";

Connection conn = null;
Statement st = null;
ResultSet rs = null;
%>
<%@ include file="op_paging_cal.jsp" %>

리스트
String sql = "select count(*) as cnt from board";

Connection conn = null;
Statement st = null;
ResultSet rs = null;
%>
<%@ include file="op_paging_cal.jsp" %>

뷰의 수정버튼
<a href="modify_check.jsp?idx=<%= idx %>"><button type="button" class="btn-modify">수정</button></a>

모디파이 체크
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>삭제</title>
<style>
*{
	margin: 0 auto;
	padding: 0;
	text-align: center;
}
.delete-form {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px;
    padding: 20px;
    margin: 20px auto;
    max-width: 400px;
    background-color: #fff;
    border: 1px solid #dee2e6;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.delete-form input[type="password"] {
    flex-grow: 1;
    padding: 10px 12px;
    border: 1px solid #ced4da;
    border-radius: 4px;
    font-size: 14px;
    box-sizing: border-box;
}

.delete-form input[type="submit"],
.delete-form .btn-cancel {
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    font-size: 14px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.delete-form input[type="submit"] {
    background-color: #ffc107; /* 수정 버튼 색상 */
    color: black;
}

.delete-form input[type="submit"]:hover {
    background-color: #e0a800;
}

.delete-form .btn-cancel {
    background-color: #6c757d; /* 취소 버튼 색상 (회색) */
    color: white;
}

.delete-form .btn-cancel:hover {
    background-color: #5a6268;
}

.delete-form a {
    text-decoration: none;
}
.delete-message {
    text-align: center;
    font-size: 16px;
    color: #495057;
    margin-bottom: 10px;
}
</style>
</head>
<body>
<%
String idx = request.getParameter("idx");


%>
<%@ include file="op_top.jsp" %>
<%@ include file="op_logincheck.jsp" %>


<h1>게시글 수정</h1><br>
<p class="delete-message">수정을위해 비밀번호를 입력하세요.</p>
<form action="modify.jsp?idx=<%= idx %>" method="post" class="delete-form">
	<input type="password" name="delpass">
	<input type="submit" value="수정">
	<button type="button" onclick="history.back()" class="btn-cancel">취소</button>
</form>


</body>
</html>