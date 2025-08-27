<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="review.board.BoardDAO"%> 
<%@ page import="review.board.BoardDTO"%>
<%@ page import="product.ProductDAO"%>
<%@ page import="product.ProductDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String productId = request.getParameter("productId");
    
    if (productId == null || productId.trim().isEmpty()) {
        out.println("<div class='alert alert-warning'>상품 정보가 없습니다.</div>");
        return;
    }
    
    BoardDAO dao = new BoardDAO();
    ProductDAO productDAO = new ProductDAO();
    
    // 리뷰 목록 가져오기
    List<BoardDTO> reviews = dao.getRecentReviews(productId, 50);
    
    // 통계 데이터 가져오기 (서버에서 계산)
    double averageRating = dao.getAverageRating(productId);
    int totalReviews = dao.getReviewCount(productId);
    Map<Integer, Integer> ratingStats = dao.getRatingStatistics(productId);
    
    // 이미지 없을때 상품이미지로 대체해보기
    String productImgUrl = BoardDAO.getProductImageUrl(productId);
    
    dao.close();
    productDAO.close();
    
%>

<% if (reviews.isEmpty()) { %>
    <div class="text-center py-4">
        <p class="text-muted">이 상품에 대한 리뷰가 없습니다.</p>
    </div>
<% } else { %>
    <!-- 리뷰 통계 -->
    <div class="border-bottom pb-3 mb-4">
        <!-- 전체 평점 표시 -->
        <div class="text-center mb-3">
            <div style="color: #ffc107; font-size: 1.5rem; margin-bottom: 0.5rem;">
                <% 
                // 평균 별점 표시
                for (int i = 1; i <= 5; i++) {
                    if (i <= Math.round(averageRating)) {
                        out.print("★");
                    } else {
                        out.print("☆");
                    }
                }
                %>
            </div>
            <div class="h4 mb-1">
                <strong><%= String.format("%.1f", averageRating) %></strong> 점 
                <span class="text-muted">(<%= totalReviews %>)</span>
            </div>
        </div>
        
        <!-- 별점별 분포 -->
        <div>
            <% for (int rating = 5; rating >= 1; rating--) { %>
            <div class="d-flex align-items-center mb-1">
                <small class="me-2 text-muted" style="width: 30px;"><%= rating %>점</small>
                <div class="progress flex-grow-1 me-2" style="height: 8px;">
                    <div class="progress-bar bg-warning" 
                         style="width: <%= totalReviews > 0 ? (ratingStats.get(rating) * 100.0 / totalReviews) : 0 %>%">
                    </div>
                </div>
                <small class="text-muted" style="width: 35px; font-size: 0.8rem;">
                    <%= String.format("%.0f%%", totalReviews > 0 ? (ratingStats.get(rating) * 100.0 / totalReviews) : 0) %>
                </small>
            </div>
            <% } %>
        </div>
    </div>

    <!-- 리뷰 목록 -->
    <div class="row">
        <% for (BoardDTO review : reviews) { %>
        <div class="col-12 mb-3">
            <div class="card review-item" style="cursor: pointer; max-width: 100%;" 
                 onclick="window.location.href='view.jsp?reviewId=<%= review.getReview_idx() %>'">
                <div class="card-body">
                    <div class="d-flex align-items-start">
                        <!-- 이미지 -->
                        <div class="bg-light rounded d-flex align-items-center justify-content-center icon">
                            <img src="<%= productImgUrl %>" class="product-image">
                        </div>
                        <div class="flex-grow-1 d-flex">
                            <!-- 왼쪽: 제목, 작성자, 별점 -->
                            <div class="review-left-column me-3">
                                <h5 class="card-title mb-1"><%= review.getTitle() %></h5>
                                <small class="text-muted d-block mb-2">
                                    <%= review.getUsername() != null ? review.getUsername() : "익명" %>
                                </small>
                                <div class="star-rating">
                                    <%= review.getStarRating() %>
                                </div>
                            </div>
                            
                            <!-- 중간: 내용 -->
                            <div class="review-content-column flex-grow-1 me-3">
                                <div class="review-content-preview text-muted">
                                    <%= review.getContent() %>
                                </div>
                            </div>
                            
                            <!-- 오른쪽: 작성일자, 조회수 -->
                            <div class="review-right-column text-end">
                                <small class="text-muted d-block mb-1"><%= review.getPost_date() %></small>
                                <small class="text-muted">조회 <%= review.getVisit_count() %></small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    
    <div class="text-center mt-3">
        <small class="text-muted">총 <%= totalReviews %>개의 리뷰</small>
    </div>
<% } %>