<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>    
<%@ page import="lib.DB" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    // JSON 응답 설정을 최상단에 배치
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    // JSP 내장 객체 사용 (로그인 정보는 세션에서 가져옵니다)
    String login_id = (String) session.getAttribute("ss_check"); 
    String cidx = request.getParameter("cidx"); // 클라이언트에서 'cidx'로 전달받습니다.
    
    // 응답 JSON 메시지 초기화
    String jsonResponse;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    if (login_id == null || cidx == null || cidx.isEmpty()) {
        jsonResponse = "{\"success\": false, \"message\": \"로그인이 필요하거나 댓글 정보가 부족합니다.\"}";
        out.print(jsonResponse);
        return;
    }
    
    try {
        conn = DB.getConnection();
        String uid = null;
        
        // 1. 해당 댓글의 작성자 ID 확인
        String checkSql = "SELECT uid FROM comment WHERE idx = ?";
        ps = conn.prepareStatement(checkSql);
        ps.setString(1, cidx);
        rs = ps.executeQuery();

        if (rs.next()) {
            uid = rs.getString("uid");
        }
        
        // ResultSet과 PreparedStatement 정리
        if (rs != null) rs.close();
        if (ps != null) ps.close();

        // 2. 로그인 ID와 댓글 작성자 ID 비교
        if (uid == null || !login_id.equals(uid)) {
            // 권한 없음
            jsonResponse = "{\"success\": false, \"message\": \"댓글을 삭제할 권한이 없습니다.\"}";
        } else {
            // 3. 권한이 있다면 댓글 삭제 실행
            String deleteSql = "DELETE FROM comment WHERE idx = ? AND uid = ?";
            ps = conn.prepareStatement(deleteSql);
            ps.setString(1, cidx);
            ps.setString(2, login_id);
            
            int deletedRows = ps.executeUpdate();

            if (deletedRows > 0) {
                // 삭제 성공
                jsonResponse = "{\"success\": true, \"message\": \"댓글 삭제 성공\"}";
            } else {
                // 삭제 실패 (이미 삭제되었거나 ID가 일치하지 않는 경우)
                jsonResponse = "{\"success\": false, \"message\": \"댓글을 찾을 수 없거나 삭제에 실패했습니다.\"}";
            }
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        // 데이터베이스 오류 발생 시
        jsonResponse = "{\"success\": false, \"message\": \"데이터베이스 오류가 발생했습니다.\"}";
    } finally {
        if (rs != null) try { rs.close(); } catch(SQLException ignored) {}
        if (ps != null) try { ps.close(); } catch(SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch(SQLException ignored) {}
    }
    
    // 최종 JSON 응답 출력
    out.print(jsonResponse);
%>