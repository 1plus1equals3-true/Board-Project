<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>

<%
    // 1. 비즈니스 로직: 데이터 생성
    List<String> items = new ArrayList<>();
    items.add("이것은");
    items.add("JSP를 사용한");
    items.add("컨트롤러 역할의");
    items.add("파일입니다.");

    // 2. request 객체에 데이터 저장
    request.setAttribute("itemList", items);

    // 3. 뷰(View) 역할을 하는 JSP로 포워딩
    RequestDispatcher dispatcher = request.getRequestDispatcher("test3.jsp");
    dispatcher.forward(request, response);
%>