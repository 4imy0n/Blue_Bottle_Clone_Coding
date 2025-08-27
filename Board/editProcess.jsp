<%@ page import="java.io.File" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="review.board.BoardDTO" %>
<%@ page import="review.board.BoardDAO" %>
<%@ page import="review.image.ImageDAO" %>
<%@ page import="review.image.ImageDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
try {
    System.out.println("=== editProcess.jsp 시작 ===");
    
    // === 1단계: 세션 체크 ===
    Integer userIdxObj = (Integer) session.getAttribute("user_idx");
    if (userIdxObj == null) {
        System.out.println("에러: 로그인되지 않은 사용자");
        response.sendRedirect("testLogin.jsp");
        return;
    }
    int sessionUserId = userIdxObj.intValue();
    
    // === 2단계: 파일 업로드 설정 ===
    String saveDirectory = application.getRealPath("/uploads");
    
 	// uploads 폴더가 없으면 생성
    File uploadDir = new File(saveDirectory);
    if (!uploadDir.exists()) {
        uploadDir.mkdirs();
        System.out.println("uploads 폴더 생성됨: " + saveDirectory);
    }
    
    int maxPostSize = 10 * 1024 * 1024; // 10MB
    String encoding = "utf-8";

    System.out.println("MultipartRequest 생성 시작...");
    
 	// === 3단계: MultipartRequest로 폼 데이터 + 파일 처리
	MultipartRequest mr = new MultipartRequest(request, saveDirectory, maxPostSize, encoding, new DefaultFileRenamePolicy());

    System.out.println("MultipartRequest 생성 완료!");
    
    
    // === 4단계: 폼 데이터 가져오기 ===
    String reviewIdStr = mr.getParameter("reviewId");
    String title = mr.getParameter("title");
    String content = mr.getParameter("content");
    String product_idx = mr.getParameter("product_idx");
    String ratingStr = mr.getParameter("rating");
    String deleteImageStr = mr.getParameter("deleteImage");
    String existingImage = mr.getParameter("existing_image");
    
    System.out.println("=== 폼 데이터 ===");
    System.out.println("reviewId: " + reviewIdStr);
    System.out.println("title: " + title);
    System.out.println("product_idx: " + product_idx);
    System.out.println("rating: " + ratingStr);
    System.out.println("deleteImage: " + deleteImageStr);
    System.out.println("existingImage: " + existingImage);
    
    // 새로 업로드된 파일
    String newFileName = mr.getFilesystemName("upload");
    System.out.println("새로 업로드된 파일: " + newFileName);
    
    // === 5단계: 유효성 검사 ===
    if (reviewIdStr == null || reviewIdStr.trim().isEmpty()) {
        throw new Exception("리뷰 ID가 없습니다.");
    }
    if (title == null || title.trim().isEmpty()) {
        throw new Exception("제목이 입력되지 않았습니다.");
    }
    if (content == null || content.trim().isEmpty()) {
        throw new Exception("내용이 입력되지 않았습니다.");
    }
    if (ratingStr == null || ratingStr.trim().isEmpty()) {
        throw new Exception("별점이 선택되지 않았습니다.");
    }
    
    int reviewId = Integer.parseInt(reviewIdStr);
    int rating = Integer.parseInt(ratingStr);
    boolean deleteImage = "true".equals(deleteImageStr);
    
    
    // === 6단계: 권한 체크 ===
    BoardDAO boardDAO = new BoardDAO();
    BoardDTO existingReview = boardDAO.selectView(reviewIdStr);
    
    if (existingReview == null) {
        System.out.println("에러: 리뷰를 찾을 수 없음");
        boardDAO.close();
        throw new Exception("수정할 리뷰를 찾을 수 없습니다.");
    }
    
    if (existingReview.getUser_idx() != sessionUserId) {
        System.out.println("에러: 권한 없음 (작성자: " + existingReview.getUser_idx() + ", 현재사용자: " + sessionUserId + ")");
        boardDAO.close();
        throw new Exception("수정 권한이 없습니다.");
    }
    
    System.out.println("권한 체크 통과");
    
    // === 7단계: 리뷰 텍스트 정보 업데이트 ===
    BoardDTO updateBoard = new BoardDTO();
    updateBoard.setReview_idx(reviewId);
    updateBoard.setTitle(title.trim());
    updateBoard.setContent(content.trim());
    updateBoard.setRating(rating);
    
    System.out.println("리뷰 업데이트 시작...");
    int updateResult = boardDAO.updateEdit(updateBoard);
    
    if (updateResult <= 0) {
        System.out.println("에러: 리뷰 업데이트 실패");
        boardDAO.close();
        throw new Exception("리뷰 수정에 실패했습니다.");
    }
    
    System.out.println("리뷰 텍스트 수정 완료 (영향받은 행: " + updateResult + ")");
    
    // === 8단계: 이미지 처리 ===
    ImageDAO imageDAO = new ImageDAO();
    
    // 8-1. 기존 이미지 삭제 요청이 있거나 새 이미지가 업로드된 경우
    if (deleteImage || (newFileName != null && !newFileName.trim().isEmpty())) {
        System.out.println("기존 이미지 삭제 처리 시작...");
        
        // DB에서 기존 이미지 정보 삭제
        int deleteResult = imageDAO.deleteReviewImage(reviewId);
        System.out.println("DB 이미지 정보 삭제 결과: " + deleteResult);
        
        // 실제 파일도 삭제 (선택사항)
        if (existingImage != null && !existingImage.trim().isEmpty()) {
            try {
                String realPath = application.getRealPath(existingImage);
                File oldFile = new File(realPath);
                if (oldFile.exists()) {
                    boolean fileDeleted = oldFile.delete();
                    System.out.println("기존 파일 삭제 " + (fileDeleted ? "성공" : "실패") + ": " + realPath);
                } else {
                    System.out.println("기존 파일이 존재하지 않음: " + realPath);
                }
            } catch (Exception e) {
                System.out.println("기존 파일 삭제 중 오류: " + e.getMessage());
            }
        }
    }
    
    // 8-2. 새 이미지가 업로드된 경우 저장
    if (newFileName != null && !newFileName.trim().isEmpty()) {
        System.out.println("새 이미지 저장 시작...");
        
        ImageDTO newImageDto = new ImageDTO();
        newImageDto.setReview_idx(reviewId);
        // 컨텍스트 패스 포함
        newImageDto.setImage_url(request.getContextPath() + "/uploads/" + newFileName);
        
        int imageInsertResult = imageDAO.insertReviewImage(newImageDto);
        
        if (imageInsertResult > 0) {
            System.out.println("새 이미지 정보 저장 성공: /uploads/" + newFileName);
        } else {
            System.out.println("새 이미지 정보 저장 실패");
            // 이미지 저장 실패시 업로드된 파일 삭제
            try {
                File uploadedFile = new File(saveDirectory, newFileName);
                if (uploadedFile.exists()) {
                    uploadedFile.delete();
                    System.out.println("실패한 업로드 파일 삭제됨");
                }
            } catch (Exception e) {
                System.out.println("실패한 업로드 파일 삭제 중 오류: " + e.getMessage());
            }
        }
    }
    
    // === 9단계: 리소스 정리 ===
    imageDAO.close();
    boardDAO.close();
    
    System.out.println("=== 수정 처리 완료 ===");
    System.out.println("리다이렉트: view.jsp?reviewId=" + reviewId);
    
    // === 10단계: 수정 완료 후 상세보기 페이지로 이동 ===
    response.sendRedirect("view.jsp?reviewId=" + reviewId);
    
} catch (Exception e) {
    System.out.println("=== 에러 발생 ===");
    System.out.println("에러 메시지: " + e.getMessage());
    e.printStackTrace();
    
    // 사용자에게 에러 메시지 표시 후 이전 페이지로 이동
%>
    <script>
        alert("수정 중 오류가 발생했습니다: <%= e.getMessage().replaceAll("'", "\\\\'").replaceAll("\"", "\\\\\"") %>");
        history.back();
    </script>
<%
}
%>