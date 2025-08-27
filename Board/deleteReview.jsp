<%@ page import="java.io.File" %>
<%@ page import="review.board.BoardDTO" %>
<%@ page import="review.board.BoardDAO" %>
<%@ page import="review.image.ImageDAO" %>
<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8" %><%
try {
    System.out.println("=== deleteReview.jsp (AJAX) 시작 ===");
    
    // 세션 체크
    Integer userIdxObj = (Integer) session.getAttribute("user_idx");
    if (userIdxObj == null) {
        out.print("error");
        return;
    }
    int sessionUserId = userIdxObj.intValue();
    
    // 파라미터 받기
    String reviewIdStr = request.getParameter("reviewId");
    if (reviewIdStr == null || reviewIdStr.trim().isEmpty()) {
        out.print("error");
        return;
    }
    int reviewId = Integer.parseInt(reviewIdStr);
    
    System.out.println("삭제할 리뷰 ID: " + reviewId);
    System.out.println("현재 사용자: " + sessionUserId);
    
    // 권한 체크
    BoardDAO boardDAO = new BoardDAO();
    BoardDTO review = boardDAO.selectView(reviewIdStr);
    
    if (review == null || review.getUser_idx() != sessionUserId) {
        System.out.println("권한 없음 또는 리뷰 없음");
        boardDAO.close();
        out.print("error");
        return;
    }
    
    // 기존 이미지 URL 가져오기
    String existingImageUrl = boardDAO.getReviewImageUrl(reviewId);
    
    // 1. 먼저 이미지 삭제 (외래키 제약조건)
    ImageDAO imageDAO = new ImageDAO();
    imageDAO.deleteReviewImage(reviewId);
    
    // 2. 실제 이미지 파일 삭제
    if (existingImageUrl != null && !existingImageUrl.trim().isEmpty()) {
        try {
            String cleanPath = existingImageUrl;
            if (cleanPath.startsWith(request.getContextPath())) {
                cleanPath = cleanPath.substring(request.getContextPath().length());
            }
            String realPath = application.getRealPath(cleanPath);
            File imageFile = new File(realPath);
            if (imageFile.exists()) {
                imageFile.delete();
                System.out.println("이미지 파일 삭제: " + realPath);
            }
        } catch (Exception e) {
            System.out.println("이미지 파일 삭제 실패: " + e.getMessage());
        }
    }
    
    // 3. 리뷰 삭제
    int deleteResult = boardDAO.deletePost(review);
    
    imageDAO.close();
    boardDAO.close();
    
    if (deleteResult > 0) {
        System.out.println("리뷰 삭제 성공");
        out.print("success");
    } else {
        System.out.println("리뷰 삭제 실패");
        out.print("error");
    }
    
} catch (Exception e) {
    System.out.println("삭제 중 오류: " + e.getMessage());
    e.printStackTrace();
    out.print("error");
}
%>