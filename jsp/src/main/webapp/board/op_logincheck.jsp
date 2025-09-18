<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
if(login_id == null || login_id.equals(""))
{
%>
<script>
alert("로그인 하세요.");
location.replace("../member/Login.jsp");
</script>
<%
	return;
}
%>
