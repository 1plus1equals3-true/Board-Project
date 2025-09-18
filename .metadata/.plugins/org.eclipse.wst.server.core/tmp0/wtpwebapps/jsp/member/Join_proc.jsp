<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.File"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.IOException"%>
<%@ page import="java.nio.file.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="lib.DB" %>

<% 
	Date today = new Date(); // 현재 날짜와 시간 객체 생성
	SimpleDateFormat yearFormat = new SimpleDateFormat("yyyyMMdd"); // 년도 형식 지정
	String ymd = yearFormat.format(today); // 년도만 추출
	int intymd = Integer.parseInt(ymd);
	
	SimpleDateFormat filetimeFormat = new SimpleDateFormat("yyyyMMddHHmmss");
	String filetime = filetimeFormat.format(today);

	// 실제로 서버에 저장되는 path
	String path = "D:\\data";
	//out.println("절대 경로 : " + path + "<br/>");
	String dir = path + "\\" + ymd;
	//디렉토리 생성
	Path directoryPath = Paths.get(dir);
	try {
	    Files.createDirectory(directoryPath);
	
	    System.out.println(directoryPath + " 디렉토리가 생성되었습니다.");
	    
	} catch (FileAlreadyExistsException e) {
	    //System.out.println("디렉토리가 이미 존재합니다");
	} catch (NoSuchFileException e) {
	    System.out.println("디렉토리 경로가 존재하지 않습니다");
	}catch (IOException e) {
	    e.printStackTrace();
	}

	int size = 1024 * 1024 * 10; // 파일 사이즈 설정 : 10M
	String fileName = "";    // 업로드한 파일 이름
	String originalFileName = "";    //  서버에 중복된 파일 이름이 존재할 경우 처리하기 위해

	// cos.jar라이브러리 클래스를 가지고 실제 파일을 업로드하는 과정
	MultipartRequest multi = null;
	
	try{
	    // DefaultFileRenamePolicy 처리는 중복된 이름이 존재할 경우 처리할 때
	    // request, 파일저장경로, 용량, 인코딩타입, 중복파일명에 대한 정책
	    multi = new MultipartRequest(request, dir, size, "utf-8", new DefaultFileRenamePolicy());
	    
	    //String uid = multi.getParameter("uid");
	    //System.out.println(uid);
	    
	    // 전송한 전체 파일이름들을 가져온다.
	    Enumeration files = multi.getFileNames();
	    String str = (String)files.nextElement();
	    //System.out.println(str);
	    
	    
	    //파일명 중복이 발생했을 때 정책에 의해 뒤에 1,2,3 처럼 숫자가 붙어 고유 파일명을 생성한다.
	    // 이때 생성된 이름을 FilesystemName이라고 하여 그 이름 정보를 가져온다. (중복 처리)
	    fileName = multi.getFilesystemName(str);
	    //실제 파일 이름을 가져온다.
	    //out.print(fileName);
	    //System.out.println(fileName);
	    
	    originalFileName = multi.getOriginalFileName(str);
	    //out.print(originalFileName);
	    //System.out.println(originalFileName);
     
    
	}catch(Exception e){
   		e.printStackTrace();
	}
	
	//확장자 찾기
	int index = 0;
	if (fileName != null) {
		index = fileName.lastIndexOf(".");
	}
	String extension ="";
	if (index > 0) {
		extension = fileName.substring(index);
		//System.out.println(extension); //확장자 시스템 출력
	}
	
	//업로드된 파일명 변경하기
		String filetimeex = filetime + extension;
		Path src = Paths.get(dir +"\\"+ fileName);
	    Path dest = Paths.get(dir +"\\"+ filetimeex);
		
	    try {
		    Path newFilePath = Files.move(src, dest);

		    //System.out.println(newFilePath);

		} catch (IOException e) {
		    e.printStackTrace();
		}
%>


<% 
	String a = multi.getParameter("uid");

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
	
	
	String b = multi.getParameter("upass1");
	String c = multi.getParameter("upass2");
	
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
	
	String d = multi.getParameter("uname");
	
	if( d == null || d.equals("")){
		%>
			<script>
				alert("이름을 입력하세요.");
				location.replace("Join.jsp");
			</script>
		<%
			return;
	}
	
	String ee = multi.getParameter("sex");
	String yy = multi.getParameter("yyyy");
	String mm = multi.getParameter("mm");
	String dd = multi.getParameter("dd");
	String ff[] = multi.getParameterValues("hobby");
	String yymmdd = yy+"-"+mm+"-"+dd;
	String hobby = "";
	String [] h = multi.getParameterValues("hobby");
	if(h != null) {hobby = String.join(",", h);}
	
	if (fileName == null) {
    	filetimeex = null;
    	dir = null;
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
				 out.println("연결 성공");
				 
				 sql = "insert into member(uid,upassword,upasscheck,name,sex,birth,hobby,regdate,upfile,originalfile,originaldir) " +
						   " values(?,?,?,?,?,?,?,now(),?,?,?)";
				 
				 ps = conn.prepareStatement(sql);
				   
				   ps.setString(1, a);
				   ps.setString(2, b);
				   ps.setString(3, c);
				   ps.setString(4, d);
				   ps.setString(5, ee);
				   ps.setString(6, yymmdd);
				   ps.setString(7, hobby);
				   ps.setString(8, filetimeex);
				   ps.setString(9, originalFileName);
				   ps.setString(10, dir);
				 
				   ps.executeUpdate();
				 
				 out.println("등록성공");
				 
				 response.sendRedirect("Login.jsp");
				 
				 
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