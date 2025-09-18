<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSTL 예시 (View)</title>
</head>
<body>
    <h1>JSTL로 코드와 화면 분리하기</h1>
    <ul>
        <%-- JSTL을 이용한 화면 출력 --%>
        <c:forEach var="item" items="${itemList}">
            <li>${item}</li>
        </c:forEach>
    </ul>
</body>
</html>