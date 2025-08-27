const editor = document.getElementById('editor');

function checkPlaceholder() {
  const isEmpty = editor.innerText.trim() === '' || editor.innerHTML.trim() === '' || editor.innerHTML.trim() === '<br>' || editor.innerHTML.trim() === '<p><br></p>';
  editor.classList.toggle('empty', isEmpty);
}

// 글자가 입력되거나 삭제될 때 감지
editor.addEventListener('input', checkPlaceholder);

// 페이지 로딩 시 초기 체크
window.addEventListener('DOMContentLoaded', checkPlaceholder);

// 이미지 업로드 및 미리보기 처리
const imageUpload = document.getElementById('image-upload');
const previewImg = document.getElementById('preview-img');
const noImageText = document.getElementById('no-image-text');

// 파일 업로드 시 미리보기
imageUpload.addEventListener('change', function () {
  const file = this.files[0];
  
  if (file) {
    // 파일 크기 체크 (10MB 제한)
    if (file.size > 10 * 1024 * 1024) {
      alert('파일 크기는 10MB를 초과할 수 없습니다.');
      this.value = '';
      return;
    }
    
    // 파일 타입 체크
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
    if (!allowedTypes.includes(file.type)) {
      alert('JPG, PNG, GIF 파일만 업로드 가능합니다.');
      this.value = '';
      return;
    }
    
    const reader = new FileReader();
    reader.onload = function (e) {
      previewImg.src = e.target.result;
      previewImg.style.display = 'block';
      if (noImageText) noImageText.style.display = 'none';
      
      // 이미지가 로드되면 부모 컨테이너 스타일 업데이트
      const imgBox = previewImg.closest('.img-box');
      if (imgBox) {
        imgBox.style.border = '1px solid #28a745';
        imgBox.style.backgroundColor = '#f8fff8';
      }
    };
    reader.readAsDataURL(file);
  } else {
    // 파일이 선택되지 않은 경우
    resetImagePreview();
  }
});

// 이미지 미리보기 초기화 함수
function resetImagePreview() {
  previewImg.src = './images/review/sample.jpg';
  previewImg.style.display = 'block';
  if (noImageText) noImageText.style.display = 'block';
  
  const imgBox = previewImg.closest('.img-box');
  if (imgBox) {
    imgBox.style.border = '1px solid #ccc';
    imgBox.style.backgroundColor = '#f8f9fa';
  }
}

// 이미지 제거 함수  edit.jsp
function removeImage() {
  imageUpload.value = '';
  resetImagePreview();
  console.log('이미지가 제거되었습니다.');
  document.getElementById('deleteImageFlag').value="true";
}

// editor 내용 복사
const hidden = document.getElementById('editor-hidden');

// 에디터 입력이 바뀔 때마다 hidden에 복사
function updateEditorHidden() {
  hidden.value = editor.innerHTML;
}

// 에디터 체크
function checkEmpty() {
  // editor의 텍스트가 공백만 있거나 <br> 하나만 있을 경우 빈 상태로 처리
  const content = editor.innerHTML.trim();
  const textContent = editor.innerText.trim();

  if (content === '' || content === '<br>' || content === '<p><br></p>' || content === '<div><br></div>' || textContent === '') {
    editor.innerHTML = '';
    hidden.value = '';
    editor.classList.add('empty');
  } else {
    editor.classList.remove('empty');
    updateEditorHidden();
  }
  
  console.log('Editor empty check:', editor.classList.contains('empty'), content);
}

// input 이벤트에 빈 상태 체크와 hidden 업데이트 연결
editor.addEventListener('input', checkEmpty);

// 초기 로드 시 빈 상태 체크
checkEmpty();

// 폼 유효성 검사
function validateForm(form) {
  // 제목 체크
  if(form.title.value.trim() == "") {
    alert("제목을 입력하세요.");
    form.title.focus();
    return false;
  }
  
  // 상품 선택 체크
  if(form.product_idx.value == "") {
    alert("상품을 선택하세요.");
    form.product_idx.focus();
    return false;
  }
  
  // 별점 체크
  const ratingChecked = document.querySelector('input[name="rating"]:checked');
  if(!ratingChecked) {
    alert("별점을 선택하세요.");
    return false;
  }
  
  // 내용 체크 - 에디터의 실제 텍스트 내용을 확인
  const editorText = editor.innerText.trim();
  if(editorText == "" || editor.innerHTML.trim() === '<br>' || editor.innerHTML.trim() === '<p><br></p>') {
    alert("내용을 입력하세요.");
    editor.focus();
    return false;
  }
  
  // 에디터 내용을 hidden input에 복사
  updateEditorHidden();
  
  return true;
}

// 기본 이미지 띄우기
window.addEventListener('DOMContentLoaded', function () {
  checkPlaceholder();
  
  // 기본 이미지 설정
  if (previewImg.src === '' || previewImg.src === window.location.href) {
    previewImg.src = './images/review/sample.jpg';
    previewImg.style.display = 'block';
  }
});

// 컬러선택 박스 표시
const colorBox = document.getElementById("colorBox");
const colorButton = document.getElementById("colorButton");

function toggleColorBox(event) {
  event.stopPropagation(); // 클릭 전파 방지
  colorBox.style.display = colorBox.style.display === "block" ? "none" : "block";
}

// 아웃포커싱
document.addEventListener("click", e => {
  if (colorButton && !colorButton.contains(e.target)) {
    colorBox.style.display = "none";
  }
});


// 텍스트 컬러 변경 - 수정된 함수
function applyColor(color) {
  // 에디터에 포커스
  editor.focus();
  
  // 선택된 텍스트가 있는지 확인
  const selection = window.getSelection();
  
  if (selection.rangeCount > 0 && !selection.isCollapsed) {
    // 텍스트가 선택된 경우
    document.execCommand('foreColor', false, color);
  } else {
    // 텍스트가 선택되지 않은 경우 - 현재 커서 위치에서 색상 적용
    document.execCommand('foreColor', false, color);
  }
  
  // 컬러 박스 닫기
  colorBox.style.display = "none";
}

// 이미지 박스 클릭 이벤트 (JSP의 onclick과 중복 방지를 위해 함수로만 정의)
function handleImageBoxClick(event) {
  console.log('이미지 박스 클릭됨');
  // 제거 버튼 클릭이 아닐 때만 파일 선택 창 열기
  if (!event.target.classList.contains('img-remove-btn')) {
    console.log('파일 선택 창 열기');
    const fileInput = document.getElementById('image-upload');
    if (fileInput) {
      fileInput.click();
    }
  }
}

// DOM 로드 완료 후 실행
document.addEventListener('DOMContentLoaded', function() {
  // 컬러 박스 클릭 이벤트 추가
  const colorBoxes = document.querySelectorAll('.color-box');
  colorBoxes.forEach(box => {
    box.addEventListener('click', function() {
      const color = this.getAttribute('data-color');
      applyColor(color);
    });
  });
});