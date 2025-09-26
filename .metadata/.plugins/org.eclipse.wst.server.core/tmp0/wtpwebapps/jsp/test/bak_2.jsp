<script>
// ==========================================================
// 전역 변수: 현재 남아있는 기존 파일의 개수
let keepfile_length;
// 파일 업로드 제한 수 (전역 상수로 유지)
const file_total = 10; 
// ==========================================================
	
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
                
                // 💡 keepfile_length 값 감소 (업로드 가능 횟수가 1 증가)
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
                    
                    // 🚨 디버깅용: 파일이 삭제될 때마다 남은 파일 수 확인
                    console.log(`파일 삭제 및 hidden input 이동 완료. 현재 남은 기존 파일 수: ${keepfile_length}`);
                }
            } else {
                // 사용자가 '취소'를 누른 경우
                console.log('파일 삭제가 취소되었습니다.');
            }
        });
    });
});

// 수정버튼 submit
function gallery_modify_submit() {
    const form = document.forms['modify_form'];
    
    // 1. 잔존하는 기존 파일 확인 (DOM을 직접 확인하는 것이 가장 정확)
    const keptFiles = document.querySelectorAll('#keep_file .file-item');
    const hasKeptFiles = keptFiles.length > 0;
    
    // 2. 새로 업로드된 파일 확인 
    let hasNewFiles = false;
    const newFileInputs = form.querySelectorAll('input[type="file"]');

    newFileInputs.forEach(input => {
        if (input.value) { 
            hasNewFiles = true;
        }
    });

    // 3. 최종 파일 존재 여부 확인
    if (hasKeptFiles || hasNewFiles) {
        console.log("파일이 존재합니다. 폼 제출을 진행합니다.");
        form.submit();
    } else {
        alert("하나 이상의 파일을 업로드하거나 기존 파일을 유지해야 합니다.");
    }
}

/*파일 선택창 추가 기믹*/
document.addEventListener('DOMContentLoaded', () => {
    const fileArea = document.querySelector('.write-form tbody tr:nth-child(3) td:nth-child(2)');
    let fileIndex = 0;
    // const file_total = 10; // 전역으로 선언됨
    const keepfiles = document.querySelectorAll('#keep_file .file-item');
    
    // 💡 전역 변수 초기화
    keepfile_length = keepfiles.length;
    
    // 🚨 [수정]: file_limit 지역 변수를 제거합니다. 
    // 파일 제한은 keepfile_length의 최신 값으로 동적으로 계산할 것입니다.
    // const file_limit = file_total +1 -keepfile_length;

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
        
        // 💡 [수정]: file_limit 대신, 최대 업로드 가능한 개수(maxNewFiles)를 동적으로 계산합니다.
        const maxNewFiles = file_total - keepfile_length;

        // 현재 파일의 개수 확인
        if (currentInput.files.length > 0) {
            
            // 현재 활성화된 (파일이 선택된) 신규 파일 입력 필드의 개수를 계산합니다.
            let selectedNewFilesCount = 0;
            allInputs.forEach(input => {
                if (input.value) {
                    selectedNewFilesCount++;
                }
            });
            
            // 🚨 [수정]: "전체 파일 입력 필드의 개수" 대신 
            // "이미 선택된 신규 파일의 개수"가 "최대로 업로드 가능한 신규 파일 수"를 초과하는지 확인합니다.
            // (새로운 필드가 추가되기 전에 이미 파일 선택을 시도하는 시점입니다.)
            if (selectedNewFilesCount > maxNewFiles) {
                // 경고창을 띄우고
                alert(`더 이상 파일을 업로드할 수 없습니다. (총 ${file_total}개 중 기존 파일 ${keepfile_length}개를 제외하고 ${maxNewFiles}개까지 가능)`);
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
                // 새 파일 추가 시에도 maxNewFiles를 체크하여 추가합니다.
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
        
        // 💡 [수정]: 파일 입력 필드를 추가하기 전에 최대 허용 개수를 동적으로 체크
        const maxNewFiles = file_total - keepfile_length;
        
        // 현재 존재하는 신규 파일 입력 필드 개수와, 추가될 필드의 개수를 합쳐 maxNewFiles와 비교
        if (allInputs.length + 1 > maxNewFiles) {
            // 이미 추가 가능한 최대 개수만큼 입력 필드가 있거나, 추가 시 초과한다면
            if (!isInitial) { // 초기화가 아닐 때만 경고
                alert(`더 이상 파일 입력 필드를 추가할 수 없습니다. (최대 ${maxNewFiles}개까지 가능)`);
            }
            return; 
        }

        if (!isInitial) {
            fileIndex++;
        }

        const newContainer = document.createElement('div');
        newContainer.id = `file_container_${fileIndex}`;
        newContainer.className = 'file-container';

        const newInput = document.createElement('input');
        newInput.type = 'file';
        newInput.name = `upfile_${fileIndex}`;
        newInput.id = `upfile_${fileIndex}`;
        newInput.accept = '.gif, .jpg, .png';

        newContainer.appendChild(newInput);
        fileArea.appendChild(newContainer);

        // 새로운 필드에 이벤트 리스너 연결
        addEventListenersToFileInput(newInput);
    }
});
</script>