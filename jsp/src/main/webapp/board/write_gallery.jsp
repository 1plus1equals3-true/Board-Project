<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>갤러리 글쓰기</title>
<style>
*{
	margin: 0 auto;
	padding: 0;
	text-align: center;
	box-sizing: border-box;
}
.write-form table {
    width: 100%;
    border-collapse: collapse;
    font-size: 14px;
    margin: 20px auto;
    max-width: 600px;
    background-color: #fff;
    border: 1px solid #dee2e6;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.write-form td {
    padding: 15px;
    border: 1px solid #e9ecef;
}

.write-form td:first-child {
    background-color: #f8f9fa;
    font-weight: bold;
    color: #495057;
    text-align: center;
    width: 120px;
}

.write-form input[type="text"],
.write-form textarea {
    width: calc(100% - 24px);
    padding: 10px 12px;
    border: 1px solid #ced4da;
    border-radius: 4px;
    font-size: 14px;
    box-sizing: border-box;
    text-align: left;
}

.write-form textarea {
    height: 200px;
    resize: vertical;
}

.write-form .button-container {
    text-align: right;
}

.write-form .write_sub,
.write-form .btn-cancel {
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    font-size: 14px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    margin-left: 8px;
}

.write-form .write_sub {
    background-color: #007bff;
    color: white;
}

.write-form .write_sub:hover {
    background-color: #0056b3;
}

.write-form .btn-cancel {
    background-color: #6c757d;
    color: white;
}

.write-form .btn-cancel:hover {
    background-color: #5a6268;
}

/* a 태그 안에 button을 넣었을 때 스타일 */
.write-form a {
    text-decoration: none;
}
/* 전체 컨테이너 (div) 스타일 */
.file-container {
  /* 세로 정렬(column) 대신 가로 정렬(row)로 변경 */
  display: flex;
  flex-direction: row; 
  align-items: center; /* 세로 중앙 정렬 */
  gap: 5px; /* 요소들 사이의 간격 */

  /* 나머지 디자인 스타일은 그대로 유지 */
  padding: 3px;
  border-radius: 12px;
  background-color: white;
}

/* 파일 입력 필드 스타일 */
.file-container input[type="file"] {
  /* 너비가 너무 넓어지지 않도록 조정 */
  width: 100%;
  max-width: 350px; /* 적절한 너비로 조정하세요 */
  font-family: Arial, sans-serif;
  color: #555;
  border: 1px solid #BDBDBD;
  border-radius: 8px;
  padding: 10px 15px;
}

/* 버튼 스타일 */
.file-container button {
  padding: 10px 18px;
  font-family: Arial, sans-serif;
  font-size: 14px;
  color: #555;
  background-color: #E0E0E0;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s ease;
  width: fit-content;
}

/* 호버 효과 */
.file-container button:hover {
  background-color: #BDBDBD;
}
</style>
</head>
<body>
<%@ include file="op_top.jsp" %>
<%@ include file="../board/op_logincheck.jsp" %>
<%@ include file="../include/side_nav.jsp" %>
<section class="min-height">
<h1>갤러리 글쓰기</h1><br>
<form name="write_form" action="../board_proc/write_gallery_proc.jsp" method="post" enctype="multipart/form-data" class="write-form">
	<table>
		
		<tr>
			<td>제목</td>
			<td><input type="text" name="writetitle"></td>
		</tr>
		
		<tr>
			<td>내용</td>
			<td>
				<textarea class="text" name="writetext"></textarea>
			</td>
		</tr>
		
		<tr>
			<td>파일</td>
			<td>
			
				<div id="file_container_0" class="file-container">
					<input type="file" name="upfile_0" id="upfile_0" accept=".gif, .jpg, .png">
				</div>

			</td>
		</tr>
		
		<tr>
			<td colspan="2">
				<input type="button" class="write_sub" value="작성" onclick="gallery_submit()">
				<button type="button" class="btn-cancel" onclick="history.back()">취소</button>
			</td>
		</tr>
		
	</table>
</form>
</section>
<%@ include file="op_bot.jsp" %>


<script>
document.addEventListener('DOMContentLoaded', () => {
    const fileArea = document.querySelector('.write-form tbody tr:nth-child(3) td:nth-child(2)');
    let fileIndex = 0;
    const file_total = 10; // 파일 업로드 제한 수
    const file_limit = file_total +1;

    // 초기 파일 입력 필드에 이벤트 리스너를 즉시 연결
    addEventListenersToFileInput(document.getElementById('upfile_0'));

    // 파일 입력 필드에 이벤트 리스너를 추가하는 함수
    function addEventListenersToFileInput(inputElement) {
        inputElement.addEventListener('change', handleFileChange);
    }

    // 파일 변경 이벤트 핸들러
    function handleFileChange(event) {
        const currentInput = event.target;
        const container = currentInput.closest('.file-container');
        const allInputs = fileArea.querySelectorAll('input[type="file"]');
        
        if (!container) return;
        
        // 현재 파일의 개수 확인
        if (currentInput.files.length > 0) {
            // 전체 파일 입력 필드의 개수가 n개 이상이면
            if (allInputs.length >= file_limit) {
                // 경고창을 띄우고
                alert('더 이상 파일을 업로드할 수 없습니다. (최대 '+(file_total)+'개)');
                // 현재 선택한 파일의 값을 비운 뒤 함수 종료
                currentInput.value = '';
                return; 
            }
        }
        
        // 기존의 취소 버튼 제거
        const existingCancelButton = container.querySelector('.cancel-button');
        if (existingCancelButton) {
            existingCancelButton.remove();
        }

        if (currentInput.files.length > 0) {
            // 파일이 선택되었을 때만 취소 버튼 생성 및 추가
            addCancelButton(container);

            // 현재 입력 필드가 마지막 필드일 때만 새로운 필드를 추가
            const isLastInput = currentInput === allInputs[allInputs.length - 1];

            if (isLastInput) {
                addNewFileInput();
            }
        }
    }

    // 취소 버튼을 생성하고 추가하는 함수
    function addCancelButton(container) {
        const newCancelButton = document.createElement('button');
        newCancelButton.type = 'button';
        newCancelButton.className = 'cancel-button';
        newCancelButton.textContent = '취소';

        newCancelButton.addEventListener('click', () => {
            // 현재 컨테이너(파일 입력 필드와 취소 버튼)만 제거합니다.
            container.remove();

            // 파일 입력 필드가 하나도 없으면 초기 필드 다시 생성
            if (!fileArea.querySelector('.file-container')) {
                fileIndex = 0;
                addNewFileInput(true); // isInitial true로 설정
            }
        });

        container.appendChild(newCancelButton);
    }

    // 새로운 파일 입력 필드를 추가하는 함수
    function addNewFileInput(isInitial = false) {
        const allInputs = fileArea.querySelectorAll('input[type="file"]');
        if (allInputs.length >= file_limit) {
            // 이미 n개 이상의 파일 입력 필드가 있다면 더 이상 추가하지 않음
            return; 
        }

        if (!isInitial) {
            fileIndex++;
        }

        const newContainer = document.createElement('div');
        newContainer.id = `file_container_\${fileIndex}`;
        newContainer.className = 'file-container';

        const newInput = document.createElement('input');
        newInput.type = 'file';
        newInput.name = `upfile_\${fileIndex}`;
        newInput.id = `upfile_\${fileIndex}`;
        newInput.accept = '.gif, .jpg, .png';

        newContainer.appendChild(newInput);
        fileArea.appendChild(newContainer);

        // 새로운 필드에 이벤트 리스너 연결
        addEventListenersToFileInput(newInput);
    }
});

//////////
function gallery_submit() {
    // 1. 문서의 모든 type="file" 인풋 요소를 가져옵니다.
    // querySelectorAll을 사용하면 'input' 태그를 모두 가져올 필요 없이 type="file"만 가져올 수 있습니다.
    const fileInputs = document.querySelectorAll('input[type="file"]');
    
    let isFileSelected = false; // 파일이 하나라도 선택되었는지 여부를 저장할 변수

    // 2. 모든 파일 인풋을 순회하며 파일이 선택되었는지 확인합니다.
    for (const input of fileInputs) {
        // 동적으로 추가된 마지막 빈 파일 입력 필드는 무시하고, 
        // 파일이 실제로 선택된 인풋만 확인합니다.
        if (input.files && input.files.length > 0) {
            isFileSelected = true; // 파일이 하나라도 선택되었음을 표시
            break; // 하나라도 찾았으면 더 이상 검사할 필요 없이 반복 중단
        }
    }

    // 3. 파일 선택 여부에 따라 처리합니다.
    if (!isFileSelected) {
        alert("갤러리는 파일을 최소 1개 이상 업로드해야 합니다.");
        return; // 파일이 하나도 선택되지 않았으면 폼 제출을 막습니다.
    }
    
    // 4. 모든 검증을 통과했으면 폼을 제출합니다. (name 속성 확인 완료)
    document.write_form.submit();
}
//////////
</script>

</body>
</html>