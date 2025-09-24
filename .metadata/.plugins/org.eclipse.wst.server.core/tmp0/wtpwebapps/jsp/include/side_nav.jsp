<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
.side-nav {
  /* fixed 속성으로 뷰포트에 바로 고정 */
  position: fixed;
  /* 뷰포트 상단에서 20px 떨어진 곳에 고정 */
  top: 100px; 
  /* 뷰포트 왼쪽에서 20px 떨어진 곳에 고정 */
  left: 10px;
  width: 80px;
  height: fit-content;
  border: 1px solid #ccc;
  padding: 10px;
  background-color: #f9f9f9;
  z-index: 10;
}

.side-nav h6 {
  margin-top: 0;
}

.side-nav h4 {
  margin-top: 0;
  margin-bottom: 10px;
}

.side-nav ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
}

.side-nav li {
  padding: 5px 0;
}
.side-nav a {
	color: black;
	text-decoration: none;
}
.side-nav a:hover {
	color: blue;
}
</style>

<div class="side-nav">
	<h4>게시판</h4>
	<ul>
		<li><h6><a href="../board/list_notice.jsp">공지사항</a></h6></li>
		<li><h6><a href="../board/list_member.jsp">회원 게시판</a></h6></li>
		<li><h6><a href="../board/list_anonymity.jsp">익명 게시판</a></h6></li>
		<li><h6><a href="../board/list_gallery.jsp">갤러리</a></h6></li>
	</ul>
</div>

<script>
    const draggableDiv = document.querySelector('.side-nav');
    let isDragging = false;
    let offsetX, offsetY;

    // 1. 페이지 로드 시 저장된 위치를 불러와 적용
    document.addEventListener('DOMContentLoaded', () => {
        // sessionStorage에서 위치 값 가져오기
        const savedTop = sessionStorage.getItem('sideNavTop');
        const savedLeft = sessionStorage.getItem('sideNavLeft');

        if (savedTop && savedLeft) {
            draggableDiv.style.top = savedTop + 'px';
            draggableDiv.style.left = savedLeft + 'px';
        }
    });

    // 2. 마우스를 누른 순간 (mousedown)
    draggableDiv.addEventListener('mousedown', (e) => {
        isDragging = true;
        offsetX = e.clientX - draggableDiv.getBoundingClientRect().left;
        offsetY = e.clientY - draggableDiv.getBoundingClientRect().top;
        
        document.body.style.userSelect = 'none';
        draggableDiv.style.zIndex = '9999';
    });

    // 3. 마우스가 이동 중일 때 (mousemove)
    document.addEventListener('mousemove', (e) => {
        if (!isDragging) return;
        
        let newX = e.clientX - offsetX;
        let newY = e.clientY - offsetY;

        // 뷰포트 경계를 넘지 않도록 위치 제한
        const maxX = window.innerWidth - draggableDiv.offsetWidth;
        const maxY = window.innerHeight - draggableDiv.offsetHeight;
        newX = Math.max(0, Math.min(newX, maxX));
        newY = Math.max(0, Math.min(newY, maxY));
        
        draggableDiv.style.left = newX + 'px';
        draggableDiv.style.top = newY + 'px';
    });

    // 4. 마우스를 떼는 순간 (mouseup)
    document.addEventListener('mouseup', () => {
        isDragging = false;
        document.body.style.userSelect = '';
        draggableDiv.style.zIndex = '10';

        // 마지막으로 이동된 위치를 sessionStorage에 저장
        sessionStorage.setItem('sideNavTop', parseInt(draggableDiv.style.top));
        sessionStorage.setItem('sideNavLeft', parseInt(draggableDiv.style.left));
    });
</script>