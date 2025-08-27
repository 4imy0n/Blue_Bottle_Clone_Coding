<%@ page import="java.util.List"%>
<%@ page import="review.board.BoardDAO"%>
<%@ page import="review.board.BoardDTO"%>
<%@ page import="review.board.OrderDTO"%>
<%@ page import="product.ProductDAO"%>
<%@ page import="product.ProductDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // === 1단계: 세션 및 로그인 체크 ===
  Integer userIdxObj = (Integer) session.getAttribute("user_idx");
  String currentUserId = (String) session.getAttribute("user_id");
  
  if (userIdxObj == null) {
    response.sendRedirect("testLogin.jsp");
    return;
  }
  int user_idx = userIdxObj.intValue();
  
  // === 2단계: URL 파라미터에서 수정할 리뷰 ID 가져오기 ===
  String reviewIdStr = request.getParameter("reviewId");
  if (reviewIdStr == null || reviewIdStr.trim().isEmpty()) {
    response.sendRedirect("list2.jsp?page=1");
    return;
  }
  int reviewId = Integer.parseInt(reviewIdStr);
  
  System.out.println("=== edit.jsp: 리뷰 수정 페이지 ===");
  System.out.println("수정할 리뷰 ID: " + reviewId);
  System.out.println("현재 사용자 ID: " + user_idx);
  
  // === 3단계: DB에서 기존 리뷰 데이터 조회 ===
  BoardDAO dao = new BoardDAO();
  BoardDTO review = dao.selectView(reviewIdStr);
  
  // === 4단계: 권한 체크 (본인 리뷰인지 확인) ===
  if (review == null) {
    System.out.println("에러: 리뷰를 찾을 수 없음");
    dao.close();
    response.sendRedirect("list2.jsp?page=1");
    return;
  }
  
  if (review.getUser_idx() != user_idx) {
    System.out.println("에러: 수정 권한 없음 (작성자: " + review.getUser_idx() + ", 현재사용자: " + user_idx + ")");
    dao.close();
    response.sendRedirect("list2.jsp?page=1");
    return;
  }
  
  System.out.println("기존 리뷰 데이터 조회 성공:");
  System.out.println("- 제목: " + review.getTitle());
  System.out.println("- 별점: " + review.getRating());
  System.out.println("- 상품: " + review.getProduct_idx());
  
  // === 5단계: 관련 데이터 조회 ===
  // 리뷰 이미지 가져오기
  String existingImageUrl = dao.getReviewImageUrl(reviewId);
  System.out.println("- 기존 이미지: " + existingImageUrl);
  
  // 상품 정보 가져오기 (상품명 표시용)
  ProductDAO productDAO = new ProductDAO();
  ProductDTO currentProduct = productDAO.getProductById(review.getProduct_idx());
  
  dao.close();
  productDAO.close();
  
  System.out.println("=== 데이터 조회 완료, 폼 렌더링 시작 ===");
%>
<!DOCTYPE html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>리뷰 수정</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
<link rel="stylesheet" href="write.css">
</head>
<body>

<div class="container mt-4">
  <h2 class="mb-4">리뷰 수정</h2>
  
  <form id="reviewForm" method="post" action="editProcess.jsp" enctype="multipart/form-data" onsubmit="return validateForm(this)">
    <!-- 숨겨진 필드 -->
    <input type="hidden" name="reviewId" value="<%= reviewId %>">
    <input type="hidden" name="user_idx" value="<%= user_idx %>">
    <input type="hidden" name="existing_image" value="<%= existingImageUrl != null ? existingImageUrl : "" %>">
    <input type="hidden" name="deleteImage" id="deleteImageFlag" value="false">
    
    <div class="row">
      <div class="col-lg-4 mb-4">
        <!-- 이미지 미리보기 박스 -->
        <div class="img-box mb-3" onclick="document.getElementById('image-upload').click()">
          <% if (existingImageUrl != null && !existingImageUrl.trim().isEmpty()) { %>
            <img id="preview-img" src="<%= existingImageUrl %>" alt="기존 이미지" class="img-fluid" style="max-height: 300px;">
            <div id="no-image-text" class="text-center text-muted mt-3" style="display: none;">
              <p>이미지를 업로드하세요<br><small>클릭하여 파일 선택</small></p>
            </div>
          <% } else { %>
            <img id="preview-img" src="./images/review/sample.jpg" alt="이미지를 선택하세요" class="img-fluid" style="max-height: 300px;">
            <div id="no-image-text" class="text-center text-muted mt-3">
              <p>이미지를 업로드하세요<br><small>클릭하여 파일 선택</small></p>
            </div>
          <% } %>
          <button type="button" class="img-remove-btn" onclick="removeImage(); event.stopPropagation();" title="이미지 제거">&times;</button>
        </div>
        
        <!-- 숨겨진 파일 입력 -->
        <input type="file" id="image-upload" name="upload" accept="image/*" style="display: none;">
        

        <!-- 상품 선택 (수정시에는 기존 상품으로 고정, 변경 불가) -->
        <div class="mb-3">
          <label for="product-select" class="form-label">상품 *</label>
          <div class="form-control bg-light" style="cursor: not-allowed;">
            <%= currentProduct != null ? currentProduct.getName() : review.getProduct_idx() %> 
            <small class="text-muted">(수정 불가)</small>
          </div>
          <!-- 실제 전송용 hidden 필드 -->
          <input type="hidden" name="product_idx" value="<%= review.getProduct_idx() %>">
          <small class="text-muted">상품은 리뷰 작성 후 변경할 수 없습니다.</small>
        </div>

        <!-- 별점 선택 -->
        <div class="mb-3">
          <div class="d-flex align-items-center gap-3">
            <label class="form-label mb-0">별점 *</label>
            <div class="rating-input">
              <!-- 기존 별점으로 체크 -->
              <input type="radio" id="star5" name="rating" value="5" <%= review.getRating() == 5 ? "checked" : "" %> required>
              <label for="star5" class="star">★</label>
              <input type="radio" id="star4" name="rating" value="4" <%= review.getRating() == 4 ? "checked" : "" %>>
              <label for="star4" class="star">★</label>
              <input type="radio" id="star3" name="rating" value="3" <%= review.getRating() == 3 ? "checked" : "" %>>
              <label for="star3" class="star">★</label>
              <input type="radio" id="star2" name="rating" value="2" <%= review.getRating() == 2 ? "checked" : "" %>>
              <label for="star2" class="star">★</label>
              <input type="radio" id="star1" name="rating" value="1" <%= review.getRating() == 1 ? "checked" : "" %>>
              <label for="star1" class="star">★</label>
            </div>
          </div>
          <small class="text-muted">별을 클릭하여 평점을 선택하세요</small>
        </div>

      </div>

      <!-- 제목 및 내용 입력 부분 -->
      <div class="col-lg-8">
        <!-- 제목 (기존 값으로 미리 채워짐) -->
        <div class="mb-3">
          <label for="title-input" class="form-label">제목 *</label>
          <input type="text" id="title-input" name="title" class="form-control" 
                 placeholder="리뷰 제목을 입력하세요" required maxlength="100" 
                 value="<%= review.getTitle().replaceAll("\"", "&quot;") %>">
          <small class="text-muted">기존: "<%= review.getTitle() %>"</small>
        </div>

        <!-- 툴바 -->
        <div class="editor-toolbar mb-2">
          <!-- 볼드 -->
          <button type="button" class="btn btn-outline-secondary btn-sm" onclick="document.execCommand('Bold')" title="굵게 (Ctrl+B)">
              <img src="./images/tool_bar/format_bold.svg" alt="굵게">
          </button>
          <!-- 기울게 -->
          <button type="button" class="btn btn-outline-secondary btn-sm" onclick="document.execCommand('Italic')" title="기울임 (Ctrl+I)">
              <img src="./images/tool_bar/format_italic.svg" alt="기울임">
          </button>
          <!-- 밑줄 -->
          <button type="button" class="btn btn-outline-secondary btn-sm" onclick="document.execCommand('Underline')" title="밑줄 (Ctrl+U)">
              <img src="./images/tool_bar/format_underlined.svg" alt="밑줄">
          </button>
          <!-- 취소선 -->
          <button type="button" class="btn btn-outline-secondary btn-sm" onclick="document.execCommand('strikethrough')" title="취소선">
              <img src="./images/tool_bar/strikethrough.svg" alt="취소선">
          </button>
          <!-- 색상선택 -->
          <button type="button" class="btn btn-outline-secondary btn-sm" id="colorButton" title="텍스트 색상">
              <img src="./images/tool_bar/format_color.svg" alt="색상" onclick="toggleColorBox(event)">
              <div id="colorBox" class="color-select">
                <div class="color-grid">
                  <div class="color-box" style="background:#61BD6D;" data-color="#61BD6D"></div>
                  <div class="color-box" style="background:#1ABC9C;" data-color="#1ABC9C"></div>
                  <div class="color-box" style="background:#54ACD2;" data-color="#54ACD2"></div>
                  <div class="color-box" style="background:#2C82C9;" data-color="#2C82C9"></div>
                  <div class="color-box" style="background:#9365B8;" data-color="#9365B8"></div>
                  <div class="color-box" style="background:#475577;" data-color="#475577"></div>
                  <div class="color-box" style="background:#CCCCCC;" data-color="#CCCCCC"></div>
                  <div class="color-box" style="background:#41A85F;" data-color="#41A85F"></div>
                  <div class="color-box" style="background:#00A885;" data-color="#00A885"></div>
                  <div class="color-box" style="background:#3D8EB9" data-color="#3D8EB9"></div>
                  <div class="color-box" style="background:#2969B0" data-color="#2969B0"></div>
                  <div class="color-box" style="background:#553982" data-color="#553982"></div>
                  <div class="color-box" style="background:#28324E" data-color="#28324E"></div>
                  <div class="color-box" style="background:#000000" data-color="#000000"></div>
                  <div class="color-box" style="background:#F7DA64" data-color="#F7DA64"></div>
                  <div class="color-box" style="background:#FBA026" data-color="#FBA026"></div>
                  <div class="color-box" style="background:#EB6B56" data-color="#EB6B56"></div>
                  <div class="color-box" style="background:#E25041" data-color="#E25041"></div>
                  <div class="color-box" style="background:#A38F84" data-color="#A38F84"></div>
                  <div class="color-box" style="background:#EFEFEF" data-color="#EFEFEF"></div>
                  <div class="color-box" style="background:#FFFFFF" data-color="#FFFFFF"></div>
                  <div class="color-box" style="background:#FAC51C" data-color="#FAC51C"></div>
                  <div class="color-box" style="background:#F37934" data-color="#F37934"></div>
                  <div class="color-box" style="background:#D14841" data-color="#D14841"></div>
                  <div class="color-box" style="background:#B8312F" data-color="#B8312F"></div>
                  <div class="color-box" style="background:#7C706B" data-color="#7C706B"></div>
                  <div class="color-box" style="background:#D1D5D8" data-color="#D1D5D8"></div>
                  <div class="color-box" style="background:#01A1DD" data-color="#01A1DD"></div>
                </div>
              </div>
          </button> 
        </div>

        <!-- 에디터 (기존 내용으로 미리 채워짐) -->
        <div class="mb-3">
          <label for="editor" class="form-label">내용 *</label>
          <div id="editor" class="editor" contenteditable="true" 
               style="min-height: 300px; height: 400px; max-height: 600px; resize: vertical;"
               data-placeholder="상품에 대한 솔직한 리뷰를 작성해주세요."><%= review.getContent() %></div>
          <small class="text-muted">기존 내용이 로드되었습니다. 수정할 부분만 변경하세요.</small>
        </div>

        <!-- 숨겨진 입력 필드 -->
        <input type="hidden" name="content" id="editor-hidden" required>

        <!-- 버튼 -->
        <div class="d-flex gap-3 mt-4 mb-5">
          <button class="btn btn-primary px-4 py-2" type="submit">수정 완료</button>
          <a class="btn btn-secondary px-4 py-2" href="view.jsp?reviewId=<%= reviewId %>">취소</a>
          <a class="btn btn-outline-secondary px-4 py-2" href="list2.jsp">목록으로</a>
        </div>
      </div>
    </div>
  </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
<script src="./write.js"></script>
<script>
// 에디터 처리 div->p
window.onload = () => {
  document.execCommand('defaultParagraphSeparator', false, 'p');
  
  // 기존 내용이 있으면 empty 클래스 제거
  const editor = document.getElementById('editor');
  if (editor.innerHTML.trim() !== '') {
    editor.classList.remove('empty');
  }
};

// 기본 제출 동작 방지
document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('input[type="text"]').forEach(input => {
    input.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        e.preventDefault();
      }
    });
  });
});

</script>
</body>
</html>