<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    

<%
	int pageCount = ccount / scale + (ccount%scale==0?0:1);

	if (page_group_start>1) { %>
    <a href="list.jsp?_page=<%= page_group_start-1 %>&key=<%= key %>&word=<%= word %>" class="aa aah">◀</a>
<% 
	}else {
%>
		<a class="aa aax" >◀</a>
<%
	}
	for (int i=page_group_start; i<=page_group_end; i++) {
		if(i==now_page) {
%>
			<a href="?_page=<%= i %>&key=<%= key %>&word=<%= word %>" class="aa aaa"><%= i %></a>
<%
		}else if (i<=Math.ceil(dcount/scale)) { //totalp
%>
			<a href="?_page=<%= i %>&key=<%= key %>&word=<%= word %>" class="aa aah"><%= i %></a>
<%
		}
	}
	if (page_group_end<pageCount) {
%>
    	<a href="?_page=<%= page_group_end+1 %>&key=<%= key %>&word=<%= word %>" class="aa aah">▶</a>
<%
	}else {
%>
		<a class="aa aax">▶</a>
<%	
	}
%>


	<form name="search_form" method="get" class="search-form">
		<select name="key">
			<option value="name">작성자</option>
			<option value="title">제목</option>
			<option value="content">내용</option>
		</select>
		<input type="text" name="word">
		<button type="submit">검색</button>
	</form>
