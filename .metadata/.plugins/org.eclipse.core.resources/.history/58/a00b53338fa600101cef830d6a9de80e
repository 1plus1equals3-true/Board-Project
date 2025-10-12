<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
//========================전역===============================
let keepfile_length;
//==========================================================
	
// X버튼 누르면 기존 파일 삭제하는 기믹
document.addEventListener('DOMContentLoaded', function() {
    // 1. 모든 'X' 버튼 선택
    const deleteButtons = document.querySelectorAll('#keep_file .file-delete-btn');
    
    // 2. 삭제된 파일을 모아둘 컨테이너 선택
    const deletedFilesContainer = document.getElementById('del_file');

    // 3. 각 버튼에 클릭 이벤트 리스너 등록
    deleteButtons.forEach(button => {
        button.addEventListener('click', function() {
            
            // ⭐ 4. 사용자에게 삭제 여부를 확인합니다.
            const isConfirmed = confirm("이 파일을 삭제하시겠습니까?");

            // 사용자가 '확인'을 눌렀을 때만 처리합니다.
            if (isConfirmed) {
                // A. 가장 가까운 .file-item 요소를 찾습니다.
                const fileItem = this.closest('.file-item');
                keepfile_length--;
                
                if (fileItem) {
                    // B. file-item 내부에 있는 input[type=hidden] 요소를 찾습니다.
                    const hiddenInput = fileItem.querySelector('input[type="hidden"]');
                    
                    if (hiddenInput) {
                        // C. 서버에서 '삭제할 파일' 목록으로 인식하도록 name을 변경합니다.
                        hiddenInput.name = 'deleted_files'; 
                        
                        // D. hidden input을 #del_file 컨테이너로 이동시킵니다.
                        deletedFilesContainer.appendChild(hiddenInput);
                    }

                    // E. 파일 항목 (시각적인 부분)을 DOM에서 완전히 제거합니다.
                    fileItem.remove();
                    
                    console.log('파일 삭제 및 hidden input 이동 완료.');
                }
            } else {
                // 사용자가 '취소'를 누른 경우
                console.log('파일 삭제가 취소되었습니다.');
            }
        });
    });
});

// 수정버튼 submit
// 기존 파일 삭제 로직 아래에 다음 함수를 추가하세요.

function gallery_modify_submit() {
    const form = document.forms['modify_form'];
    
    // 1. 잔존하는 기존 파일 확인 (삭제되지 않고 #keep_file에 남아있는 파일)
    const keptFiles = document.querySelectorAll('#keep_file .file-item');
    const hasKeptFiles = keptFiles.length > 0;
    
    // 2. 새로 업로드된 파일 확인 (input type="file"에 파일이 선택되었는지)
    let hasNewFiles = false;
    
    // 폼 내의 모든 input[type="file"] 요소를 찾습니다.
    const newFileInputs = form.querySelectorAll('input[type="file"]');

    newFileInputs.forEach(input => {
        // input.value는 사용자가 파일을 선택하면 파일 경로 문자열을 가집니다.
        // 파일이 하나라도 선택되면 hasNewFiles를 true로 설정하고 반복을 중단합니다.
        if (input.value) { 
            hasNewFiles = true;
            // 성능 최적화를 위해 파일을 찾으면 즉시 루프를 중단할 수 있습니다.
            // (여기서는 .forEach를 사용했으므로 return을 사용해 continue 효과를 내지만, break는 불가능합니다.)
        }
    });

    // 3. 최종 파일 존재 여부 확인
    if (hasKeptFiles || hasNewFiles) {
        // 기존 파일이 남아있거나 새로 업로드된 파일이 있다면 submit 진행
        console.log("파일이 존재합니다. 폼 제출을 진행합니다.");
        form.submit();
    } else {
        // 파일이 하나도 없다면 알림 메시지 출력 후 submit 막기
        alert("하나 이상의 파일을 업로드하거나 기존 파일을 유지해야 합니다.");
        // 파일 입력 필드로 스크롤 이동 등 사용자 경험 개선 가능
    }
}

/*파일 선택창 추가 기믹*/
document.addEventListener('DOMContentLoaded', () => {
    const fileArea = document.querySelector('.write-form tbody tr:nth-child(3) td:nth-child(2)');
    let fileIndex = 0;
    const file_total = 10; // 파일 업로드 제한 수
    const keepfiles = document.querySelectorAll('#keep_file .file-item');
    keepfile_length = keepfiles.length;
    let file_limit = file_total +1 -keepfile_length;

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
                console.log(keepfile_length);
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
</script>