<%@ page import="java.util.Enumeration"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.io.File"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.IOException"%>
<%@ page import="java.nio.file.*"%>
<%@ page import="java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="lib.DB" %>
<%@ page import="java.util.ArrayList" %>
<%
String idx = request.getParameter("idx");
String fileidx = request.getParameter("fileidx");

String sql = "";
Connection conn=null;
PreparedStatement ps = null;
ResultSet rs = null;
String upfile = "";
String originalfile = "";
String originaldir = "";

try{
	 
	 conn = DB.getConnection();
	 {
		 sql = "select upfile_"+fileidx+", originalfile_"+fileidx+", relativedir from board_gallery where bidx=?";
		 ps = conn.prepareStatement(sql);
		 
		 ps.setString(1, idx);
		 rs = ps.executeQuery();
		 rs.next();
		 upfile = rs.getString("upfile_"+fileidx);
		 originalfile = rs.getString("originalfile_"+fileidx);
		 originaldir = rs.getString("relativedir");
		 
	 }
}	catch(Exception e){ 
		out.println(e.toString());
		out.println(sql);
	}

	//경로 폴더이름만 뽑기
	int index = 0;
	if (originaldir != null) {
		index = originaldir.lastIndexOf("\\");
	}
	
	String ext =""; // 뽑아낸 폴더이름
	if (index > 0) {
		ext = originaldir.substring(index + 1);
		//System.out.println(ext); //시스템 출력
	}

try{

		String path = "D:\\data"; // 절대경로
		String dir = ext; // 상대경로
	   	String fileName = upfile; // 파일이름
	   	String filePath = path + "\\" + dir; // 완전한 경로

	    request.setCharacterEncoding("UTF-8");
	    
	    fileName = new String(fileName.getBytes("UTF-8"), "UTF-8");
	    File file = new File(filePath, fileName);

	    if(file.isFile())
	    {
	        String extension = fileName.substring(fileName.lastIndexOf(".") + 1);
	        
	        if(extension.toLowerCase().equals("jpg") ||
	              extension.toLowerCase().equals("jpeg") ||
	              extension.toLowerCase().equals("gif") ||
	              extension.toLowerCase().equals("png") )
	        {
	           response.setContentType("image/jpeg");
	           response.setHeader("Content-Type","image/jpeg");
	        }
	        else
	        {
	           String header = request.getHeader("User-Agent");
	           
	            if (header.contains("MSIE") || header.contains("Trident")) {  //----------------------------------------
	            	originalfile = java.net.URLEncoder.encode(originalfile,"UTF-8").replaceAll("\\+", "%20");
	                response.setHeader("Content-Disposition", "attachment;filename=" + originalfile + ";");
	            } else {
	            	originalfile = new String(originalfile.getBytes("UTF-8"), "ISO-8859-1");
	                response.setHeader("Content-Disposition", "attachment; filename=\"" + originalfile + "\"");
	             }

	            response.setContentType( "application/download; UTF-8" );
	           response.setHeader("Content-Type", "application/octet-stream");
	        }
	        
	        int bytes = (int)file.length();
	        
	        response.setContentLength(bytes);
	        response.setHeader("Content-Transfer-Encoding", "binary;");
	        response.setHeader("Pragma", "no-cache;");
	        response.setHeader("Expires", "-1;");

	        BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file));
	        BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());

	        byte[] readByte = new byte[4096];
	        try{
	            while((bytes = fin.read(readByte)) > 0){
	                outs.write(readByte, 0, bytes);
	                outs.flush();
	            }
	        }catch(Exception ex) {

	        }finally{
	            outs.close();
	            fin.close();
	        }
	    }
	}catch(Exception ex){
	    ex.printStackTrace();
	}
%>