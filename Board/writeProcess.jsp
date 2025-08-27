<%@ page import="java.io.File" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="review.board.BoardDTO" %>
<%@ page import="review.board.BoardDAO" %>
<%@ page import="review.image.ImageDAO" %>
<%@ page import="review.image.ImageDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
try {
    System.out.println("=== writeProcess.jsp 시작 ===");
    
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
    String title = mr.getParameter("title");
    String content = mr.getParameter("content");
    String product_idx = mr.getParameter("product_idx");
    String ratingStr = mr.getParameter("rating");
    String userIdxStr = mr.getParameter("user_idx");
    
    System.out.println("파라미터 읽기 완료");
    System.out.println("title: " + title);
    System.out.println("product_idx: '" + product_idx + "'");
    System.out.println("rating: " + ratingStr);
    System.out.println("폼 user_idx: " + userIdxStr);
    System.out.println("세션 user_idx: " + sessionUserId);
    
    // 파일명 처리
    String fileName = mr.getFilesystemName("upload");
    System.out.println("업로드된 파일: " + fileName);
    
    // 유효성 검사
    if (title == null || title.trim().isEmpty()) {
        throw new Exception("제목이 입력되지 않았습니다.");
    }
    if (content == null || content.trim().isEmpty()) {
        throw new Exception("내용이 입력되지 않았습니다.");
    }
    if (product_idx == null || product_idx.trim().isEmpty()) {
        throw new Exception("상품이 선택되지 않았습니다.");
    }
    if (ratingStr == null || ratingStr.trim().isEmpty()) {
        throw new Exception("별점이 선택되지 않았습니다.");
    }
    
    System.out.println("유효성 검사 통과");
    
    int rating = Integer.parseInt(ratingStr);
    // 세션의 user_idx 사용 (폼 데이터 무시)
    int user_idx = sessionUserId;
    
    System.out.println("실제 사용될 user_idx: " + user_idx);
    
    // BoardDTO 생성 및 값 세팅
    BoardDTO board = new BoardDTO();
    board.setTitle(title.trim());
    board.setContent(content.trim());
    board.setUser_idx(user_idx);
    board.setProduct_idx(product_idx);
    board.setRating(rating);
    
    // BoardDAO 생성
    BoardDAO boardDAO = new BoardDAO();
    
    // 이미지가 있는 경우와 없는 경우 분기 처리
    if (fileName != null && !fileName.trim().isEmpty()) {
        System.out.println("이미지 파일이 있음 - 이미지와 함께 리뷰 저장");
        
        // 이미지와 함께 리뷰 저장 (review_idx 반환받음)
        int reviewIdx = boardDAO.insertWriteWithImage(board);
        
        if (reviewIdx > 0) {
            System.out.println("리뷰 저장 성공 - review_idx: " + reviewIdx);
            
            // 이미지 정보 DB에 저장
            ImageDAO imageDAO = new ImageDAO();
            ImageDTO imageDto = new ImageDTO();
            imageDto.setReview_idx(reviewIdx);
            imageDto.setImage_url(request.getContextPath() + "/uploads/" + fileName); // 컨텍스트 패스 포함
            
            int imageResult = imageDAO.insertReviewImage(imageDto);
            imageDAO.close();
            
            if (imageResult > 0) {
                System.out.println("이미지 정보 저장 성공");
            } else {
                System.out.println("이미지 정보 저장 실패");
            }
        } else {
            throw new Exception("리뷰 저장에 실패했습니다.");
        }
        
    } else {
        System.out.println("이미지 파일이 없음 - 텍스트만 저장");
        
        // 이미지 없이 리뷰만 저장
        int result = boardDAO.insertWriteSimple(board);
        
        if (result <= 0) {
            throw new Exception("리뷰 저장에 실패했습니다.");
        }
        
        System.out.println("텍스트 리뷰 저장 완료");
    }
    
    boardDAO.close();
    System.out.println("DAO 연결 해제 완료");
    
    // 처리 완료
    System.out.println("모든 처리 완료 - 리다이렉트 시작");
    response.sendRedirect("list2.jsp?page=1");
    
} catch (Exception e) {
    System.out.println("에러 발생: " + e.getMessage());
    e.printStackTrace();
%>
    <script>
        alert("에러: <%= e.getMessage() %>");
        history.back();
    </script>
<%
}
%>