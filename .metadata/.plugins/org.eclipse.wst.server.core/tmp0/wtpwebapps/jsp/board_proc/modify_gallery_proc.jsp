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
<%@ page import="lib.MyFileRenamePolicy" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
    
<%
// ========================================================
// 1. 초기 설정 및 새 경로 생성 (작성 로직 재사용)
// ========================================================
String ip = java.net.Inet4Address.getLocalHost().getHostAddress();
String fileNames[] = new String[10]; 
String originalFileNames[] = new String[10]; 

Date today = new Date();
SimpleDateFormat yearFormat = new SimpleDateFormat("yyyyMMdd");
String ymd = yearFormat.format(today);

// 고정 경로 (D:\\data)와 날짜 기반의 새로운 전체 경로 생성
String path = "D:\\data";
String dir = path + "\\board" + ymd; // ⭐ 새로운 파일이 저장될 경로

Path directoryPath = Paths.get(dir);
try {
    // 디렉토리가 없으면 생성 (이미 존재하면 예외 없이 넘어감)
    Files.createDirectories(directoryPath);
} catch (IOException e) {
    // 디렉토리 생성 실패 시 즉시 종료
    out.println("<script>alert('파일 저장 디렉토리 생성 실패.'); history.back();</script>");
    return;
}
	
int size = 1024 * 1024 * 10; // 10M
String fileName = null;
String originalFileName = "";

// JDBC 변수
Connection conn = null;
Statement st = null;
ResultSet rs = null;
PreparedStatement ps = null;

MultipartRequest multi = null; 
String idx = null;
boolean transactionSuccess = false;

try {
    // ========================================================
    // 2. MultipartRequest 생성 및 파일 즉시 저장 (새 경로 dir 사용)
    // ========================================================
    // request, 파일저장경로, 용량, 인코딩타입, 중복파일명에 대한 정책
	multi = new MultipartRequest(request, dir, size, "utf-8", new MyFileRenamePolicy());
    
    // 2-1. idx 및 폼 데이터 수신
    idx = multi.getParameter("idx");

    if (idx == null || idx.isEmpty()) {
        throw new Exception("게시글 번호가 유효하지 않습니다.");
    }

    String writetitle = multi.getParameter("writetitle");
    String writetext = multi.getParameter("writetext");
    String deletedFileOrders = multi.getParameter("deleted_file_ids"); // 삭제할 기존 파일 ID (PK)
    
    // 2-2. 전송한 새 파일 이름들을 배열에 저장
    Enumeration files = multi.getFileNames();
    
    int i = 0;
    while (files.hasMoreElements()) {
    	
        String name = (String)files.nextElement();
        
        // 서버에 저장된 이름 (dir에 저장됨)
        fileName = multi.getFilesystemName(name);
        
        // 사용자가 업로드한 원래 파일 이름
        originalFileName = multi.getOriginalFileName(name);
        
        if (fileName != null) {
        	originalFileNames[i] = originalFileName;
            fileNames[i] = fileName; // **fileNames 배열 사용**
            i++;
        }
    }
    
    

    // DB 연결 및 트랜잭션 시작
    conn = DB.getConnection();
    conn.setAutoCommit(false); 

    // ========================================================
    // 3. 기존 파일 삭제 처리 (deleted_file_ids 기준)
    //    * 기존 파일은 기존 경로를 사용합니다. (DB에서 경로를 조회하지 않아도 됨)
    // ========================================================
    if (deletedFileOrders != null && !deletedFileOrders.isEmpty()) {
        String[] ordersToDelete = deletedFileOrders.split(","); // 파일의 PK(idx) 값들
        
        // 3-1. 삭제할 파일의 upfile 이름과 relativedir을 DB에서 조회
        StringBuilder inClause = new StringBuilder();
        for (int j = 0; j < ordersToDelete.length; j++) {
            inClause.append("?");
            if (j < ordersToDelete.length - 1) inClause.append(",");
        }
        
        String sql_select_del_files = 
            "SELECT upfile, relativedir FROM board_gallery WHERE bidx = ? AND idx IN (" + inClause.toString() + ")"; // idx는 board_gallery의 PK
        
        ps = conn.prepareStatement(sql_select_del_files);
        ps.setString(1, idx); // 게시글 idx
        for (int j = 0; j < ordersToDelete.length; j++) {
            ps.setInt(j + 2, Integer.parseInt(ordersToDelete[j]));
        }
        rs = ps.executeQuery();
        
        List<String[]> filesToDelete = new ArrayList<>(); // [upfile, relativedir] 쌍
        while(rs.next()) {
            filesToDelete.add(new String[]{rs.getString("upfile"), rs.getString("relativedir")}); 
        }
        rs.close(); ps.close();

        // 3-2. DB에서 해당 파일 레코드 삭제
        String sql_delete = 
            "DELETE FROM board_gallery WHERE bidx = ? AND idx IN (" + inClause.toString() + ")"; // idx는 board_gallery의 PK
        ps = conn.prepareStatement(sql_delete);
        ps.setString(1, idx);
        for (int j = 0; j < ordersToDelete.length; j++) {
            ps.setInt(j + 2, Integer.parseInt(ordersToDelete[j]));
        }
        ps.executeUpdate();
        ps.close();
        
        // 3-3. 서버 저장소에서 실제 파일 삭제 (조회된 경로 사용)
        for (String[] fileInfo : filesToDelete) {
            String savedFile = fileInfo[0];
            String relativeDir = fileInfo[1]; // ⭐ 기존 경로 사용
            
            if (savedFile != null && relativeDir != null) {
                File file = new File(relativeDir, savedFile); 
                if (file.exists()) {
                    file.delete();
                }
            }
        }
    }

    // ========================================================
    // 4. 게시글 내용 업데이트
    // ========================================================
    String sql_update_board = "UPDATE board SET title = ?, content = ?, ip = ? WHERE idx = ?";
    ps = conn.prepareStatement(sql_update_board);
    ps.setString(1, writetitle);
    ps.setString(2, writetext);
    ps.setString(3, ip); 
    ps.setString(4, idx);
    ps.executeUpdate();
    ps.close();

    // ========================================================
    // 5. 새로운 파일 DB에 추가 (fileNames 배열 사용)
    // ========================================================
    
    // ⭐ file_order 컬럼이 없으므로 제거하고, Auto-increment 되는 board_gallery.idx를 사용합니다.
    
    String sql_insert_gallery = "insert into board_gallery(bidx, upfile, originalfile, relativedir) " +
           " values(?,?,?,?)";
    
    for (int j = 0; j < fileNames.length; j++) {
        if (fileNames[j] != null) {
            
            ps = conn.prepareStatement(sql_insert_gallery);
            
            ps.setString(1, idx);
            ps.setString(2, fileNames[j]); // upfile (새 경로에 저장된 이름)
            ps.setString(3, originalFileNames[j]);
            ps.setString(4, dir); // ⭐ 새로 생성된 경로 사용
            
            ps.executeUpdate();
            ps.close();
        }
    }
    
    // ========================================================
    // 6. 트랜잭션 커밋 및 완료
    // ========================================================
    conn.commit();
    transactionSuccess = true;
	 
}catch(Exception e){ 
	  if (conn != null) conn.rollback();
      out.println("<script>alert('게시글 수정 중 오류가 발생했습니다.\\n에러: " + e.getMessage().replace("'", "\\'") + "'); history.back();</script>");
}finally {
    // DB 연결 종료
    if (ps != null) ps.close();
    if (rs != null) rs.close();
    if (st != null) st.close();
    if (conn != null) conn.close();
}

// 최종 리다이렉션
if (transactionSuccess) {
    %> <script type="text/javascript">
        location.replace("../board/view.jsp?idx=<%=idx%>");
    </script> <%
}
%>