<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
if(login_id == null || login_id.equals(""))
{
%>
<script>
alert("권한 없음");
history.back();
</script>
<%
	return;
}
%>
