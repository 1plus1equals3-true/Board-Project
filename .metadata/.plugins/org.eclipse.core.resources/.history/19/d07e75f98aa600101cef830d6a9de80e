<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="lib.DB" %>
<%@ page import="java.io.File"%>
<%@ include file="../board/op_top.jsp" %>
<%
String idx = request.getParameter("idx");
String uid = null;
String boardtype = null;

String sql = "";
Connection conn=null;
PreparedStatement ps = null;
ResultSet rs = null;

try{
    conn = DB.getConnection();
    {
    	sql = "SELECT b.* FROM board b LEFT JOIN member m ON b.uid = m.uid where b.idx=?";
    	ps = conn.prepareStatement(sql);
    	ps.setString(1, idx);
		rs = ps.executeQuery();
		rs.next();
		uid = rs.getString("uid");
		boardtype = rs.getString("boardtype");
    }
    
    if (login_rank == 9) {
    	
    }else if (0 < login_rank && login_rank < 9) {
    	if(login_id == null || !login_id.equals(uid)) {
    		if (boardtype.equals("1") || boardtype.equals("0") || boardtype.equals("3")) {
    			%>
    			<script>
    			alert("권한 없음");
    			location.replace("view.jsp?idx=<%= idx %>");
    			</script>
    			<%
    			return;
    		}
    	}
    }else {
    	if (boardtype.equals("1") || boardtype.equals("0") || boardtype.equals("3")) {
    		%>
    		<script>
    		alert("권한 없음");
    		location.replace("view.jsp?idx=<%= idx %>");
    		</script>
    		<%
    		return;
    	}
    }

    String upfile = null;
    String upfiles[] = new String[10];////
  	String originaldir = "";
    
    {
    	sql = "SELECT b.idx, g.* from board b LEFT JOIN board_gallery g ON b.idx = g.bidx WHERE b.idx=?";
		 ps = conn.prepareStatement(sql);
		 ps.setString(1, idx);
		 rs = ps.executeQuery();
		 int i=0;
		 while (rs.next()) { upfiles[i] = rs.getString("upfile"); originaldir = rs.getString("relativedir"); i++; }
		 if (upfile != null) { // BOARD DB에 데이터를 저장하는 부분 전부 수정해야함
			 String del_file = originaldir+"\\"+upfile;
			 File file = new File(del_file);
			 if( file.exists() ){
		    		if(file.delete()){
		    			System.out.println(del_file+" del");
		    		}else{
		    			System.out.println("파일삭제 실패");
		    		}
		 		}
			 }
		 for (int j=0; j<i; j++) {
			 if (upfiles[j] != null) {
				 String del_file = originaldir+"\\"+upfiles[j];
				 File file = new File(del_file);
				 if( file.exists() ){
			    		if(file.delete()){
			    			System.out.println(del_file+" del");
			    		}else{
			    			System.out.println("파일삭제 실패");
			    		}
				 }
			 }
		 }
    }

   sql = " delete from board where idx ='"+idx+"' ";
   Statement st1 = conn.createStatement();
   st1.executeUpdate(sql);
   st1.close();
   
   sql = " DELETE FROM comment WHERE bidx ='"+idx+"' ";
   Statement st2 = conn.createStatement();
   st2.executeUpdate(sql);
   st2.close();
   
   if (boardtype.equals("3")) {
	   sql = " DELETE FROM board_gallery WHERE bidx ='"+idx+"' ";
	   Statement st3 = conn.createStatement();
	   st3.executeUpdate(sql);
	   st3.close();
   }
   

   %>
	<script>
		var type = "<%= boardtype %>";
		alert("삭제 성공");
		if (type == 0) {
			location.replace("../board/list_notice.jsp");
		}else if (type == 1) {
			location.replace("../board/list_member.jsp");
		}else if (type == 3) {
			location.replace("../board/list_gallery.jsp");
		}else {
			location.replace("../board/list_anonymity.jsp");
		}
		
	</script>
	<%
    
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