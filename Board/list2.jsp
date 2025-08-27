<%@ page import="java.util.List"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="review.board.BoardDAO"%> 
<%@ page import="review.board.BoardDTO"%>
<%@ page import="product.ProductDAO"%>
<%@ page import="product.ProductDTO"%>
<%@ page import="product.CategoryDAO"%>
<%@ page import="product.CategoryDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<% 
	String userName = (String)session.getAttribute("user_name");
  Integer user_idx = (Integer) session.getAttribute("user_idx");
	//int user_idx = (int)session.getAttribute("user_idx");
	String user_id = (String)session.getAttribute("user_id");
	String phone = (String)session.getAttribute("phone");
%>

<% 
    // 페이지 번호만 JSP에서 받기
    int pageNo = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.trim().equals("")) {
        try {
            pageNo = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            pageNo = 1;
        }
    }

    // DAO를 생성해 DB에 연결
    BoardDAO dao = new BoardDAO();
    ProductDAO productDAO = new ProductDAO();
    CategoryDAO categoryDAO = new CategoryDAO();
    
    // 카테고리 목록 조회
    List<CategoryDTO> categories = categoryDAO.getAllCategories();
    
    // 사용자가 입력한 검색 조건을 Map에 저장
    Map<String, Object> param = new HashMap<String, Object>();
    String searchField = request.getParameter("searchField");
    String searchWord = request.getParameter("searchWord");
    String categoryIdxStr = request.getParameter("categoryIdx");
    
    if (searchField == null) searchField = "";
    if (searchWord == null) searchWord = "";
    
    param.put("searchField", searchField);
    param.put("searchWord", searchWord);
    param.put("pageNo", pageNo);
    
    // 카테고리 검색인 경우 카테고리 인덱스 추가
    if ("category".equals(searchField) && categoryIdxStr != null && !categoryIdxStr.trim().isEmpty()) {
        try {
            int categoryIdx = Integer.parseInt(categoryIdxStr);
            param.put("categoryIdx", categoryIdx);
        } catch (NumberFormatException e) {
            searchField = ""; // 잘못된 카테고리 인덱스면 검색 취소
        }
    }

    // 총 게시물 수 조회
    int totalCount = dao.selectCount(param);
    
    // 페이지네이션 정보 계산 (Java에서 처리)
    Map<String, Object> pagination = dao.calculatePagination(totalCount, pageNo);
    
    // 게시물 목록 받기 (페이지 크기는 Java에서 관리)
    List<BoardDTO> boardLists = dao.selectList(param);
    
    // 페이지네이션 정보 추출
    int currentPage = (Integer) pagination.get("pageNo");
    int pageSize = (Integer) pagination.get("pageSize");
    int totalPages = (Integer) pagination.get("totalPages");
    int startPage = (Integer) pagination.get("startPage");
    int endPage = (Integer) pagination.get("endPage");
    
    // 리뷰 이미지 정보 가져오기 (성능 최적화)
    Map<Integer, String> reviewImages = new HashMap<>();
    if (!boardLists.isEmpty()) {
        List<Integer> reviewIdxList = new ArrayList<>();
        for (BoardDTO board : boardLists) {
            reviewIdxList.add(board.getReview_idx());
        }
        reviewImages = dao.getReviewImagesMap(reviewIdxList);
    }
    
    // 상품별 리뷰 통계를 위한 Map
    Map<String, Integer> reviewCounts = new HashMap<>();
    Map<String, List<BoardDTO>> productReviews = new HashMap<>();
    
    // 상품별로 리뷰 그룹화
    for (BoardDTO board : boardLists) {
        String productId = board.getProduct_idx();
        if (!productReviews.containsKey(productId)) {
            productReviews.put(productId, new ArrayList<BoardDTO>());
        }
        productReviews.get(productId).add(board);
    }
    
    dao.close();
    productDAO.close();
    categoryDAO.close();
    
    
%>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>리뷰게시판</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="./list2.css">
    <link rel="stylesheet" href="./getProductReviews.css">
    <link rel="stylesheet" href="./main.css">
</head>
<body>

    <!-- 네비게이션 바 -->
    <header class="my_header">
        <nav class="navbar navbar-expand-lg custom-navbar p-0">
            <div class="container-fluid">               
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav me-auto ms-4 mb-2 mb-lg-0">
                        <li class="nav-item me-3">
                            <a class="nav-link active" href="#">쇼핑</a>
                        </li>
                        <li class="nav-item me-3">
                            <a class="nav-link active" href="../shopping/bestseller.jsp">베스트셀러</a>
                        </li>
                        <li class="nav-item me-3">
                            <a class="nav-link active" href="../shopping/sets.jsp">세트</a>
                        </li>
                        <li class="nav-item me-3">
                            <a class="nav-link active" href="../cafe-list/cafe-list.jsp">카페</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="../Board/list2.jsp">리뷰</a>
                        </li>
                    </ul>

                    <ul class="navbar-nav navbar-center mb-2 mb-lg-0">
                        <a class="navbar-brand" href="../main/index.jsp">
                            <img src="./images/logo2.png" alt="" width="20%">
                        </a>
                    </ul>

                    <ul class="navbar-nav ms-auto me-4 mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link active" href="../search/search.jsp?search=">
                                <svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
                                <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0"/>
                                </svg>
                            </a>
                        </li>
                        <li class="nav-item ms-3">
                        <% if(user_idx == null){ %>
	                            <a class="nav-link active" href="../login/bluebottlecoffee_account_login.jsp">
	                                <svg xmlns="http://www.w3.org/2000/svg" width="23" height="23" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
	                                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
	                                </svg>
	                            </a>
                            <% }else{ %>
	                            <a class="nav-link active" href="../mypage/bluebottlecoffee_account.jsp">
	                                <svg xmlns="http://www.w3.org/2000/svg" width="23" height="23" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
	                                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
	                                </svg>
	                            </a>
                            <% } %>
                        </li>
                        <li class="nav-item ms-3">
	                            <a class="nav-link active" href="../cart/cart.jsp?idx=<%=user_idx%>">
	                                <svg xmlns="http://www.w3.org/2000/svg" width="19" height="19" fill="currentColor" class="bi bi-bag" viewBox="0 0 16 16">
	                                <path d="M8 1a2.5 2.5 0 0 1 2.5 2.5V4h-5v-.5A2.5 2.5 0 0 1 8 1m3.5 3v-.5a3.5 3.5 0 1 0-7 0V4H1v10a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V4zM2 5h12v9a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1z"/>
	                                </svg>
	                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>



<div class="container-fluid mt-2 p-3 p-sm-5">
    <!-- 검색 폼 -->
    <div class="row mb-4 mx-3">
        <div class="col-12">
            <form method="get" action="list2.jsp" class="d-flex" onsubmit="return validateSearch()">
                <img src="images/review/bluebottleS.png" class="bluebottle me-2">
                <input type="hidden" name="page" value="1">
                <select name="searchField" class="form-select me-2" style="width: auto;" onchange="toggleCategorySelect(this.value)">
                    <option value="product_name" <%= "product_name".equals(searchField) ? "selected" : "" %>>전체 상품명</option>
                    <option value="category" <%= "category".equals(searchField) ? "selected" : "" %>>카테고리별 상품명</option>
                </select>
                
                <!-- 카테고리 선택 (카테고리별 검색시에만 표시) -->
                <select name="categoryIdx" id="categorySelect" class="form-select me-2" style="width: auto; <%= "category".equals(searchField) ? "" : "display: none;" %>">
                    <option value="">카테고리 선택</option>
                    <% for (CategoryDTO category : categories) { %>
                    <option value="<%= category.getCategory_idx() %>" 
                            <%= categoryIdxStr != null && categoryIdxStr.equals(String.valueOf(category.getCategory_idx())) ? "selected" : "" %>>
                        <%= category.getCategory_name() %>
                    </option>
                    <% } %>
                </select>
                
                <input type="text" name="searchWord" class="form-control me-2" 
                       placeholder="상품명을 입력하세요" value="<%= searchWord %>">
                <button type="submit" class="btn me-2" style="min-width: 80px;">검색</button>
                <% if (!searchWord.trim().isEmpty()) { %>
                <a href="list2.jsp?page=1" class="btn" style="min-width: 80px;">전체</a>
                <% } %>
            </form>
        </div>
    </div>
    
    <!-- 검색 결과 표시 -->
    <% if (!searchWord.trim().isEmpty()) { %>
    <div class="alert alert-info text-center mx-3">
        <% 
        String searchTypeText = "";
        if ("product_name".equals(searchField)) {
            searchTypeText = "전체 상품";
        } else if ("category".equals(searchField)) {
            String categoryName = "카테고리";
            for (CategoryDTO category : categories) {
                if (categoryIdxStr != null && categoryIdxStr.equals(String.valueOf(category.getCategory_idx()))) {
                    categoryName = category.getCategory_name();
                    break;
                }
            }
            searchTypeText = categoryName + " 카테고리";
        }
        %>
        <%= searchTypeText %>에서 "<%= searchWord %>" 검색 결과: 총 <%= totalCount %>개의 리뷰
    </div>
    <% } %>
    
    <% if (boardLists.isEmpty()) { %>  
    <div class="text-center py-5">
        <h4>등록된 리뷰가 없습니다.</h4>
        <% if (!searchWord.trim().isEmpty()) { %>
        <p>다른 검색어로 시도해보세요.</p>
        <% } %>
        
    </div>
    <% } else { %>    
    
    <!-- 리뷰 목록 -->
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 px-4" id="cardContainer">
        <% 
        // 상품별로 그룹화해서 표시
        Map<String, ProductDTO> productCache = new HashMap<>();
        
        for (String productId : productReviews.keySet()) {
        	String productImgUrl = BoardDAO.getProductImageUrl(productId);
        	//상품별
            List<BoardDTO> reviews = productReviews.get(productId);
            if (reviews.isEmpty()) continue;
            
            BoardDTO firstReview = reviews.get(0);
            
            // 상품 정보 가져오기 (캐시 사용)
            ProductDTO product = productCache.get(productId);
            if (product == null) {
                ProductDAO tempDAO = new ProductDAO();
                product = tempDAO.getProductById(productId);
                tempDAO.close();
                if (product != null) {
                    productCache.put(productId, product);
                }
            }
            
            String productName = (product != null) ? product.getName() : "상품명 없음";
            int productPrice = (product != null) ? product.getPrice() : 0;
            
         	// 카테고리명 가져오기 (추가)
            String categoryName = "";
            if (product != null) {
                // 이미 가져온 categories 리스트에서 찾기
                for (CategoryDTO category : categories) {
                    if (category.getCategory_idx() == product.getCategory_idx()) {
                        categoryName = category.getCategory_name();
                        break;
                    }
                }
            }
            
            // 상품 평균 평점 계산
            double avgRating = 0.0;
            if (!reviews.isEmpty()) {
                int totalRating = 0;
                for (BoardDTO review : reviews) {
                    totalRating += review.getRating();
                }
                avgRating = (double) totalRating / reviews.size();
            }         
        %>
        <div class="col px-3 mb-4">
            <div class="card-wrapper">
                <!--상품 대표 이미지 섹션-->
				<div class="image-box position-relative">
				    <a href="#">
				        <img src="<%= productImgUrl %>" alt="<%= productName %>" class="product-image">
				    </a>
				    <!--상품이미지 카테고리 -->
				    <div class="card-article p-1">
				        <p class="mb-1"><%= categoryName %></p>
				    </div>
				</div>
                
                <ul class="review p-2 text-truncate m-0" style="min-height: 180px;">
                    <!-- 상품 정보 및 리뷰 개수 -->
                    <li class="d-flex justify-content-between align-items-start">
                        <div class="flex-grow-1">
                            <!-- 상품명과 가격을 한 줄에 배치 -->
                            <div class="mb-1">
                                <span class="product-name"><%= productName %></span>
                                 
                            </div>
                            
                            <% if (avgRating > 0) { %>
                            <div class="star-rating small">
                            	<small class="text-muted price me-2">₩<%= String.format("%,d", productPrice) %></small>
                                <span style="color: #ffc107;">
                                    <% 
                                    for (int s = 1; s <= 5; s++) {
                                        if (s <= Math.round(avgRating)) {
                                            out.print("★");
                                        } else {
                                            out.print("☆");
                                        }
                                    }
                                    %>
                                </span>
                                <small class="text-muted ms-1"><%= String.format("%.1f", avgRating) %></small>
                            </div>
                            <% } %>
                        </div>
                        <small class="text-end text-muted" style="cursor: pointer;" 
                               onclick="openReviewListModal('<%= productId %>', '<%= productName %>')">
                            <%= reviews.size() %>개의 리뷰
                        </small>
                    </li>
                    <hr>
                    
                    <!-- 최근 리뷰 3개 표시 -->
					<% 
					int displayCount = Math.min(3, reviews.size());
					for (int i = 0; i < displayCount; i++) {
					    BoardDTO review = reviews.get(i);
					    String reviewImageUrl = reviewImages.get(review.getReview_idx());
					%>
					<li class="d-flex review-item" style="cursor: pointer;" 
					    onclick="goToReviewDetail(<%= review.getReview_idx() %>)">
					    
					    <!--리뷰 썸네일 -->
					    <% if (reviewImageUrl != null && !reviewImageUrl.trim().isEmpty()) { %>
					        <div class="review-thumb has-image">
					            <img src="<%= reviewImageUrl %>" alt="리뷰 이미지">
					        </div>
					    <% } else { %>
					        <div class="review-thumb"> 
					        </div>
					    <% } %>
					    
					    <div class="ms-2 flex-grow-1">
					        <div class="review-summary ">
					            <div class="review-title mb-1">
					                <strong class="text-truncate d-block"><%= review.getTitle() %></strong>
					            </div>
					            <div class="review-author">
					                <small class="text-muted">
					                    <%= review.getUsername() != null ? review.getUsername() : "익명" %>
					                </small>
					            </div>
					        </div>
					    </div>
					</li>
					<% if (i < displayCount - 1) { %><hr><% } %>
					<% } %>
					
					<!-- 빈 슬롯 채우기 -->
					<% for (int i = displayCount; i < 3; i++) { %>
					<% if (i > 0) { %><hr><% } %>
					<li class="d-flex text-muted">
					    <div class="review-thumb empty">
					        
					    </div>
					    <div class="ms-2 flex-grow-1">
					        <div class="review-summary">
					            <div class="review-title mb-1">
					                <small>리뷰를 더 기다리고 있어요</small>
					            </div>
					            <div class="review-author">
					                <small>첫 리뷰를 작성해보세요</small>
					            </div>
					        </div>
					    </div>
					</li>
					<% } %>
                </ul>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

    <!-- 페이지네이션 -->
    <% if (totalPages > 1) { %>
    <nav aria-label="페이지네이션" class="mt-4">
        <ul class="pagination justify-content-center">
            <!-- 맨 처음 페이지로 -->
            <% if (currentPage > 1) { %>
            <li class="page-item">
                <a class="page-link" href="?page=1<%= !searchField.isEmpty() ? "&searchField=" + searchField : "" %><%= !searchWord.isEmpty() ? "&searchWord=" + searchWord : "" %><%= (categoryIdxStr != null && !categoryIdxStr.isEmpty()) ? "&categoryIdx=" + categoryIdxStr : "" %>">
                    &laquo;&laquo;
                </a>
            </li>
            <% } %>
            
            <!-- 이전 페이지 블록 -->
            <% if (startPage > 1) { %>
            <li class="page-item">
                <a class="page-link" href="?page=<%= startPage - 1 %><%= !searchField.isEmpty() ? "&searchField=" + searchField : "" %><%= !searchWord.isEmpty() ? "&searchWord=" + searchWord : "" %><%= (categoryIdxStr != null && !categoryIdxStr.isEmpty()) ? "&categoryIdx=" + categoryIdxStr : "" %>">
                    &laquo;
                </a>
            </li>
            <% } %>
            
            <!-- 페이지 번호들 -->
            <% for (int i = startPage; i <= endPage; i++) { %>
            <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                <a class="page-link" href="?page=<%= i %><%= !searchField.isEmpty() ? "&searchField=" + searchField : "" %><%= !searchWord.isEmpty() ? "&searchWord=" + searchWord : "" %><%= (categoryIdxStr != null && !categoryIdxStr.isEmpty()) ? "&categoryIdx=" + categoryIdxStr : "" %>">
                    <%= i %>
                </a>
            </li>
            <% } %>
            
            <!-- 다음 페이지 블록 -->
            <% if (endPage < totalPages) { %>
            <li class="page-item">
                <a class="page-link" href="?page=<%= endPage + 1 %><%= !searchField.isEmpty() ? "&searchField=" + searchField : "" %><%= !searchWord.isEmpty() ? "&searchWord=" + searchWord : "" %><%= (categoryIdxStr != null && !categoryIdxStr.isEmpty()) ? "&categoryIdx=" + categoryIdxStr : "" %>">
                    &raquo;
                </a>
            </li>
            <% } %>
            
            <!-- 맨 마지막 페이지로 -->
            <% if (currentPage < totalPages) { %>
            <li class="page-item">
                <a class="page-link" href="?page=<%= totalPages %><%= !searchField.isEmpty() ? "&searchField=" + searchField : "" %><%= !searchWord.isEmpty() ? "&searchWord=" + searchWord : "" %><%= (categoryIdxStr != null && !categoryIdxStr.isEmpty()) ? "&categoryIdx=" + categoryIdxStr : "" %>">
                    &raquo;&raquo;
                </a>
            </li>
            <% } %>
        </ul>
    </nav>

    <!-- 페이지 정보 표시 -->
    <div class="text-center mt-2">
        <small class="text-muted">
            페이지 <%= currentPage %> / <%= totalPages %> (총 <%= totalCount %>개)
        </small>
    </div>
    <% } %>

    <!-- 리뷰 작성 버튼 -->
    <div class="text-center">
        <a href="write.jsp" class="btn">리뷰 작성</a>
    </div>
</div>

<!-- 상품별 리뷰 목록 모달 -->
<div class="modal fade" id="reviewListModal" tabindex="-1" aria-labelledby="reviewListModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="reviewListModalLabel">상품 리뷰 목록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="reviewListContent">
                <div class="text-center py-4">
                    <div class="spinner-border" role="status">
                        <span class="visually-hidden">로딩중...</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


        <div class="my_footer">
            <div class="container text-white py-5">
                <div class="row row-cols-1 row-cols-md-4 mb-4">
                <!-- 첫 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">블루보틀 커피</h6>
                        <a href="#" class="text-decoration-none"><p class="mb-1">카페 찾기</p></a>
                        <a href="#" class="text-decoration-none"><p class="mb-1">커리어</p></a>
                    </div>
                    <!-- 두 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">알아보기</h6>
                        <a href="#" class="text-decoration-none"><p class="mb-1">브랜드 소개</p></a>
                        <a href="#" class="text-decoration-none"><p class="mb-1">블루보틀 커피</p></a>
                        <a href="#" class="text-decoration-none"><p class="mb-1">지속가능성</p></a>
                        <a href="#" class="text-decoration-none"><p class="mb-1">브루잉 가이드</p></a>
                        <a href="#" class="text-decoration-none"><p class="mb-1">블로그</p></a>
                    </div>
                    <!-- 세 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">문의</h6>
                        <a href="#" class="text-decoration-none"><p class="mb-1">자주 묻는 질문</p></a>
                    </div>
                    <!-- 네 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">구독하고 최신 정보를 받아보세요.</h6>
                        <p class="mb-2">이메일 뉴스레터에 가입하여 혜택과 소식을 받아보세요.</p>

                        <div>
                            <!-- 소셜 아이콘은 여기에 -->
                            <i class="bi bi-instagram mx-1">@</i>
                            <i class="bi bi-youtube mx-1">@</i>
                            <i class="bi bi-facebook mx-1">@</i>
                            <i class="bi bi-twiter mx-1">@</i>
                            <i class="bi bi-kakaotalk mx-1">@</i>
                            <!-- ... -->
                        </div>
                    </div>                                               
                </div>
                <!-- 회사 정보 -->
                <div class="mt-4 mb-3 small">
                    상호: 블루보틀커피코리아 유한회사 | 대표자: KARL WILLIAM STROVINK | 개인정보관리책임자: 임홍주<br>
                    사업자등록번호: 155-81-01195 | 이메일: support_kr@bluebottlecoffee.com | 주소: 서울특별시 성동구 아차산로 7<br>
                    호스팅: Shopify, Inc.
                </div>
                <!-- 하단 -->
                <div class="d-flex justify-content-between align-items-center border-top pt-3 px-0">
                    <div class="d-flex gap-3 flex-wrap">
                        <a href="#" class="small text-white text-decoration-none">개인정보 처리방침</a>
                        <a href="#" class="small text-white text-decoration-none">판매이용약관</a>
                        <a href="#" class="small text-white text-decoration-none">환불 정책</a>
                    </div>
                    <div class="small">© 2023 BLUE BOTTLE COFFEE INC., ALL RIGHTS RESERVED</div>
                </div>
            </div>
        </div>
    </div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
<script src="./list2.js"></script>

<script>
// 카테고리 선택 박스 토글
function toggleCategorySelect(searchType) {
    const categorySelect = document.getElementById('categorySelect');
    if (searchType === 'category') {
        categorySelect.style.display = 'block';
    } else {
        categorySelect.style.display = 'none';
    }
}

// 상품별 리뷰 목록 모달 열기
function openReviewListModal(productId, productName) {
    document.getElementById('reviewListModalLabel').textContent = productName + ' 리뷰 목록';
    
    // AJAX로 해당 상품의 모든 리뷰 가져오기
    fetch('getProductReviews.jsp?productId=' + encodeURIComponent(productId))
        .then(response => response.text())
        .then(data => {
            document.getElementById('reviewListContent').innerHTML = data;
        })
        .catch(error => {
            console.error('Error:', error);
            document.getElementById('reviewListContent').innerHTML = 
                '<div class="alert alert-danger">리뷰 목록을 불러오는데 실패했습니다.</div>';
        });
    
    var reviewListModal = new bootstrap.Modal(document.getElementById('reviewListModal'));
    reviewListModal.show();
}

// 리뷰 상세 - 간단하게 페이지 이동 reviewId=getReview_idx()
function goToReviewDetail(reviewId) {
    window.location.href = 'view.jsp?reviewId=' + reviewId;
}

// 검색폼 엔터키 처리
document.addEventListener('DOMContentLoaded', function() {
    const searchForm = document.querySelector('form');
    const searchInput = document.querySelector('input[name="searchWord"]');
    
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchForm.submit();
            }
        });
    }
});
</script>
    <!-- 네비게이션 바 사라지는 JS -->
    <script>
        let prevScrollpos = window.pageYOffset; // 이전 스크롤 위치 저장

        window.onscroll = function() {
            let currentScrollPos = window.pageYOffset; // 현재 스크롤 위치

            // 스크롤이 위로 올라가면 네비게이션 바 보이게
            if (prevScrollpos > currentScrollPos) {
            document.querySelector('.custom-navbar').classList.remove('hidden');
            document.querySelector('.custom-navbar').classList.add('scrolled');
            } 
            // 스크롤이 아래로 내려가면 네비게이션 바 숨기기
            else {
            document.querySelector('.custom-navbar').classList.add('hidden');
            document.querySelector('.custom-navbar').classList.remove('scrolled');
            }

            prevScrollpos = currentScrollPos; // 이전 스크롤 위치 갱신
        }
    </script>

</body>
</html>