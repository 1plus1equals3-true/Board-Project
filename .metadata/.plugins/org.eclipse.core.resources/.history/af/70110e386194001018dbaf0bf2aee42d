<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="lib.DB" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%
request.setCharacterEncoding("utf-8");

String sql = null;
Connection conn=null;
PreparedStatement ps = null;
ResultSet rs = null;

String idx = request.getParameter("idx");
String cidx = request.getParameter("cidx");
String commentmodify = request.getParameter("commentmodify");

boolean isSuccess = false;
String message = "";

try{
	 
	conn = DB.getConnection();

	sql = "update comment set ment=? where idx=?";
	ps = conn.prepareStatement(sql);
	ps.setString(1, commentmodify);
	ps.setString(2, cidx);
	
	int rowsAffected = ps.executeUpdate();
	
	if (rowsAffected > 0) {
	    isSuccess = true;
        message = "수정 완료";
    } else {
        isSuccess = false;
        message = "수정된 댓글이 없습니다. (cidx 오류)";
    }

}
catch(Exception e){ 
	 e.printStackTrace();
     isSuccess = false;
     message = "DB 처리 중 오류가 발생했습니다.";
}
finally {
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

String jsonResponse = "{ \"success\": " + isSuccess + ", \"cidx\": \"" + cidx + "\", \"message\": \"" + message + "\" }";
out.print(jsonResponse);
out.flush();
%>