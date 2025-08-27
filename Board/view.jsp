<%@ page import="review.board.BoardDAO"%>
<%@ page import="review.board.BoardDTO"%>
<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String reviewIdx = request.getParameter("reviewId");
    
    if (reviewIdx == null || reviewIdx.trim().isEmpty()) {
        response.sendRedirect("list2.jsp?page=1");
        return;
    }
    
    BoardDAO dao = new BoardDAO();
    
    // 조회수 증가
    dao.updateVisitCount(reviewIdx);
    
    // 리뷰 정보 가져오기
    BoardDTO review = dao.selectView(reviewIdx);
    
    if (review == null) {
        dao.close();
        response.sendRedirect("list2.jsp?page=1");
        return;
    }
    
    // 간단한 이미지 조회 테스트
    String reviewImageUrl = null;
    try {
        reviewImageUrl = dao.getReviewImageUrl(review.getReview_idx());
        System.out.println("=== 이미지 조회 테스트 ===");
        System.out.println("review_idx: " + review.getReview_idx());
        System.out.println("이미지 URL: " + reviewImageUrl);
    } catch (Exception e) {
        System.out.println("이미지 조회 중 오류: " + e.getMessage());
        e.printStackTrace();
    }
    
    // 같은 상품의 다른 리뷰들 가져오기
    List<BoardDTO> relatedReviews = dao.getRecentReviews(review.getProduct_idx(), 6);
    relatedReviews.removeIf(r -> r.getReview_idx() == review.getReview_idx());
    
    dao.close();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= review.getTitle() %> - 리뷰</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Noto Sans 폰트 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="./view.css">
</head>
<body>

<div class="container-fluid py-4 px-lg-5 px-4 nt_font">
    <div class="row justify-content-center">
        <div class="col-12 col-xl-10">
            
            <!-- 게시글 상단 정보 -->
            <div class="bg-light border rounded p-3 mb-3">
                <div class="row align-items-center">
                    <div class="col">
                        <h5 class="mb-1"><%= review.getTitle() %></h5>
                        <div class="d-flex align-items-center gap-3 text-muted small">
                            <span><%= review.getUsername() != null ? review.getUsername() : "익명" %></span>
                            <span><%= review.getPost_date() %></span>
                            <span>조회 <%= review.getVisit_count() %></span>
                            <span class="star-rating"><%= review.getStarRating() %></span>
                        </div>
                    </div>
                    <div class="col-auto">
                        <% if (review.getProductName() != null) { %>
                        <span class="productN p-1"><%= review.getProductName() %></span>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- 리뷰 내용 (이미지 + 텍스트) -->
            <div class="bg-white border rounded p-4 mb-4">
                <% if (reviewImageUrl != null && !reviewImageUrl.trim().isEmpty()) { %>
                <!-- 이미지가 있는 경우: 큰 화면에서 왼쪽 이미지, 오른쪽 텍스트 -->
                <div class="row">
                    <!-- 왼쪽: 이미지 -->
                    <div class="col-12 col-lg-5 mb-3 mb-lg-0">
                        <div class="image-container">
                            <img src="<%= reviewImageUrl %>" alt="리뷰 이미지" 
                                 class="img-fluid">
                        </div>
                    </div>
                    
                    <!-- 오른쪽: 텍스트 내용 -->
                    <div class="col-12 col-lg-7">
                        <div class="review-content d-flex">
                            <div class="w-100">
                                <%= review.getContent() %>
                            </div>
                        </div>
                    </div>
                </div>
                <% } else { %>
                <!-- 이미지가 없는 경우: 텍스트만 전체 너비 -->
                <div class="review-content">
                    <%= review.getContent() %>
                </div>
                <div class="alert alert-info mt-3">
                    <small><i class="fas fa-info-circle"></i> 이 리뷰에는 이미지가 없습니다.</small>
                </div>
                <% } %>
            </div>

            <!-- 버튼 그룹 -->
            <div class="d-flex justify-content-between align-items-center py-3 border-top border-bottom mb-4">
                <div>
                    <a href="list2.jsp?page=1" class="btn btn-outline-secondary btn-sm">목록</a>
                </div>
                <div>
                    <%
                        Integer currentUserId = (Integer) session.getAttribute("user_idx");
                        boolean isAuthor = (currentUserId != null && currentUserId == review.getUser_idx());
                        
                        if (isAuthor) {
                    %>
                    <a href="edit.jsp?reviewId=<%= review.getReview_idx() %>" class="btn btn-outline-primary btn-sm me-1">수정</a>
                    <button type="button" class="btn btn-outline-danger btn-sm" 
                            onclick="deleteReview(<%= review.getReview_idx() %>)">삭제</button>
                    <% } %>
                </div>
            </div>
            
            <!-- 관련 리뷰 -->
            <% if (!relatedReviews.isEmpty()) { %>
            <div class="related-reviews">
                <h6 class="mb-3 text-muted">같은 상품의 다른 리뷰 (<%= relatedReviews.size() %>개)</h6>
                
                <% for (BoardDTO relatedReview : relatedReviews) { %>
                <div class="border-bottom py-3" style="cursor: pointer;" 
                     onclick="window.location.href='view.jsp?reviewId=<%= relatedReview.getReview_idx() %>'">
                    <div class="row">
                        <div class="col">
                            <div class="d-flex align-items-start">
                                <div class="me-3">
                                    <div class="bg-light rounded d-flex align-items-center justify-content-center" 
                                         style="width: 40px; height: 40px; font-size: 12px;">📝</div>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="fw-medium mb-1"><%= relatedReview.getTitle() %></div>
                                    <div class="text-muted small mb-1">
                                        <%= relatedReview.getTruncatedContent(80) %>
                                    </div>
                                    <div class="d-flex align-items-center gap-2 text-muted small">
                                        <span><%= relatedReview.getUsername() != null ? relatedReview.getUsername() : "익명" %></span>
                                        <span><%= relatedReview.getPost_date() %></span>
                                        <span class="star-rating" style="color: #ffc107;"><%= relatedReview.getStarRating() %></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-auto text-muted small">
                            조회 <%= relatedReview.getVisit_count() %>
                        </div>
                    </div>
                </div>
                <% } %>
                
                <div class="text-center mt-3">
                    <a href="list2.jsp?page=1" class="btn btn-outline-secondary btn-sm">전체 리뷰 보기</a>
                </div>
            </div>
            <% } else { %>
            <div class="text-center py-4">
                <p class="text-muted mb-3">이 상품에 대한 다른 리뷰가 없습니다.</p>
                <a href="list2.jsp" class="btn btn-primary btn-sm">목록 돌아가기</a>
            </div>
            <% } %>
            
        </div>
    </div>
</div>

<!-- 삭제 확인 모달 -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">리뷰 삭제</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>정말로 이 리뷰를 삭제하시겠습니까?</p>
                <p class="text-danger"><small>삭제된 리뷰는 복구할 수 없습니다.</small></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-danger" id="confirmDelete">삭제</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>

<script>
// 리뷰 삭제
function deleteReview(reviewId) {
    const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
    deleteModal.show();
    
    document.getElementById('confirmDelete').onclick = function() {
        fetch('deleteReview.jsp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'reviewId=' + reviewId
        })
        .then(response => response.text())
        .then(data => {
            if (data.trim() === 'success') {
                alert('리뷰가 삭제되었습니다.');
                window.location.href = 'list2.jsp?page=1';
            } else {
                alert('삭제에 실패했습니다.');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('삭제 중 오류가 발생했습니다.');
        });
        
        deleteModal.hide();
    };
}
</script>

</body>
</html>