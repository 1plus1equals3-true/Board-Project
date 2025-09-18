<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<ul>
  <li>1-1</li>
  <li>1-2</li>
  <li>1-3</li>
  <button class="printBtn">출력하기</button>
  <button onclick="printLiText2(this)">출력하기</button>
</ul>
<ul>
  <li>2-1</li>
  <li>2-2</li>
  <li>2-3</li>
  <button class="printBtn">출력하기</button>
  <button onclick="printLiText2(this)">출력하기</button>
</ul>
<ul>
  <li>3-1</li>
  <li>3-2</li>
  <li>3-3</li>
  <button class="printBtn">출력하기</button>
  <button onclick="printLiText2(this)">출력하기</button>
</ul>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

$(".printBtn").on("click", function() {
    const parentUl = $(this).closest("ul");
    printLiTexts(parentUl);
  });
  
  function printLiTexts(ulElement) {
    $(ulElement).find("li").each(function(index, li) {
      alert("이벤트 li " + (index + 1) + ": " + $(li).text());
    });
  }
 
  function printLiText2(button) {
    const parentUl = $(button).closest("ul");
    parentUl.find("li").each(function(index, li) {
       alert("온클릭 li " + (index + 1) + ": " + $(li).text());
    });
  }  
</script>
