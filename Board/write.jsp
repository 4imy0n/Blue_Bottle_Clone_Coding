<%@ page import="java.util.List"%>
<%@ page import="review.board.BoardDAO"%>
<%@ page import="review.board.OrderDTO"%>
<%@ page import="review.board.OrderDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // 세션에서 사용자 정보 가져오기
  Integer userIdxObj = (Integer) session.getAttribute("user_idx");
  String currentUserId = (String) session.getAttribute("user_id");
  
  // 로그인 체크
  if (userIdxObj == null) {
	  out.println("<script>alert('로그인 후 이용해주세요');</script>");
	  out.println("<script>history.back();</script>");
    
    return;
  }
  
  int user_idx = userIdxObj.intValue();
  
  System.out.println("=== write.jsp 디버깅 ===");
  System.out.println("세션 user_idx: " + user_idx);
  System.out.println("세션 user_id: " + currentUserId);

  // 리뷰 작성 가능한 상품 목록 가져오기 (리뷰를 작성하지 않은 상품들만)
  OrderDAO order = new OrderDAO();
  List<OrderDTO> reviewableProducts = order.getReviewableProducts(user_idx);
  order.close();
%>
<!DOCTYPE html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>리뷰작성</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
<link rel="stylesheet" href="write.css">
</head>
<body>

<div class="container" style="margin-top: 7%">
  
  <form id="reviewForm" method="post" action="writeProcess.jsp" enctype="multipart/form-data" onsubmit="return validateForm(this)">
    <div class="row">
      <div class="col-lg-4 mb-4">
        <!-- 이미지 미리보기 박스 -->
		<div class="img-box mb-3" onclick="handleImageBoxClick(event)">
		  <img id="preview-img" src="./images/review/sample.jpg" alt="이미지를 선택하세요" class="img-fluid" style="max-height: 300px;">
		  <div id="no-image-text" class="text-center text-muted mt-3">
		    <p>이미지를 업로드하세요<br><small>클릭하여 파일 선택</small></p>
		  </div>
		  <button type="button" class="img-remove-btn" onclick="removeImage(); event.stopPropagation();" title="이미지 제거">&times;</button>
		</div>
		
		<!-- 숨겨진 파일 입력 -->
		<input type="file" id="image-upload" name="upload" accept="image/*" style="display: none;">

        <!-- 상품 선택 -->
        <div class="mb-2">
          <label for="product-select" class="form-label">리뷰 작성할 상품 선택 *</label>
          <select class="form-select" id="product-select" name="product_idx" required>
            <option value="" disabled selected>리뷰 작성 가능한 상품을 선택하세요</option>
            <% 
            if (reviewableProducts != null && !reviewableProducts.isEmpty()) {
              System.out.println("=== 리뷰 작성 가능한 상품 목록 ===");
              for(OrderDTO product : reviewableProducts) { 
                System.out.println("상품: " + product.getProduct_idx() + " - " + product.getProduct_name() + " (주문번호: " + product.getOrder_idx() + ")");
            %>
              <option value="<%= product.getProduct_idx() %>">
                <%= product.getProduct_name() %> (주문번호: <%= product.getOrder_idx() %>)
              </option>
            <% 
              }
              System.out.println("=== 상품 목록 끝 ===");
            } else {
            %>
              <option disabled>리뷰 작성 가능한 상품이 없습니다</option>
            <% } %>
          </select>
          <small class="text-muted">
            현재 사용자: <%= currentUserId %> (ID: <%= user_idx %>) | 
            작성 가능: <%= reviewableProducts != null ? reviewableProducts.size() : 0 %>개
          </small>
        </div>

        <!-- 별점 선택 개선 -->
		<div class="mb-3">
		  <div class="d-flex align-items-center gap-3">
		    <label class="form-label mb-0 pt-2">별점 *</label>
		    <div class="rating-input">
		      <!-- 순서를 거꾸로 배치 -->
		      <input type="radio" id="star5" name="rating" value="5" required>
		      <label for="star5" class="star">★ </label>
		      <input type="radio" id="star4" name="rating" value="4">
		      <label for="star4" class="star">★</label>
		      <input type="radio" id="star3" name="rating" value="3">
		      <label for="star3" class="star">★</label>
		      <input type="radio" id="star2" name="rating" value="2">
		      <label for="star2" class="star">★</label>
		      <input type="radio" id="star1" name="rating" value="1">
		      <label for="star1" class="star">★</label>
		    </div>
		  </div>
		  <small class="text-muted">별을 클릭하여 평점을 선택하세요</small>
		</div>

      </div>

      <!-- 제목 및 내용 입력 부분 -->
      <div class="col-lg-8">
        <!-- 제목 -->
        <div class="mb-2">
          <input type="text" id="title-input" name="title" class="form-control" placeholder="리뷰 제목을 입력하세요" required maxlength="100">
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
                <div  class="color-grid">
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
                  <div class="color-box" style="background:#01A1DD" data-color="#00a9e0"></div>
                </div>
              </div>
          </button> 
        </div>

        <!-- 에디터 -->
		<div class="mb-3">
		  <div id="editor" class="editor" contenteditable="true" 
		       style="min-height: 300px; height: 400px; max-height: 600px; resize: vertical;"
		       data-placeholder="상품에 대한 솔직한 리뷰를 작성해주세요.&#10;&#10;※ 부적절한 내용의 게시글은 경고 없이 삭제될 수 있습니다.">
		  </div>
		</div>

        <!-- 숨겨진 입력 필드 -->
        <input type="hidden" name="content" id="editor-hidden" required>
        <input type="hidden" name="user_idx" value="<%= user_idx %>">

        <!-- 버튼 -->
		<div class="d-flex gap-3 mt-4 mb-5">
		  <% if (reviewableProducts != null && !reviewableProducts.isEmpty()) { %>
		    <button class="btn px-4 py-2 submitBtn" type="submit">리뷰 등록</button>
		  <% } else { %>
		    <button class="btn btn-secondary px-4 py-2" type="button" disabled>리뷰 작성 가능한 상품이 없습니다</button>
		  <% } %>
		  <a class="btn btn-secondary px-4 py-2" href="list2.jsp">목록으로</a>
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
};

// 기본 제출 동작 방지
document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('input[type="text"]').forEach(input => {
    input.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        e.preventDefault(); // 기본 제출 동작 방지
      }
    });
  });
});
</script>
</body>
</html>