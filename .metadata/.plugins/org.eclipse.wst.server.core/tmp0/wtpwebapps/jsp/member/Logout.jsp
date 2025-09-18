<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>   
<%
/*
Cookie[] cookies = request.getCookies();

if(cookies != null && cookies.length > 0){
   for(int i = 0; i < cookies.length; i++){
      cookies[i].setMaxAge(0);
      response.addCookie(cookies[i]);
   }
}
*/

session.removeAttribute("ss_check");
//session.invalidate();
%>
<script>
alert("로그아웃");
location.replace("Login.jsp");
</script>