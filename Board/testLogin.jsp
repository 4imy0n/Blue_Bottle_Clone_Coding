<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 간단한 테스트용 로그인 - 실제 프로젝트에서는 보안을 강화해야 함
    String action = request.getParameter("action");
    
    if ("login".equals(action)) {
        String userId = request.getParameter("userId");
        
        // 샘플 사용자들의 idx 매핑 (실제로는 DB에서 조회해야 함)
        int userIdx = 1; // 기본값
        if ("admin".equals(userId)) {
            userIdx = 1;
        } else if ("guest".equals(userId)) {
            userIdx = 2;
        }
        
        // 세션에 사용자 정보 저장
        session.setAttribute("user_idx", userIdx);
        session.setAttribute("user_id", userId);
        
        response.sendRedirect("list2.jsp?page=1");
        return;
    }
    
    if ("logout".equals(action)) {
        session.invalidate();
        response.sendRedirect("testLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>테스트 로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h4 class="text-center">테스트 로그인</h4>
                </div>
                <div class="card-body">
                    <% 
                    Integer currentUserId = (Integer) session.getAttribute("user_idx");
                    String currentUserName = (String) session.getAttribute("user_id");
                    
                    if (currentUserId != null) { 
                    %>
                        <div class="alert alert-success">
                            <strong><%= currentUserName %></strong>님으로 로그인되었습니다.
                        </div>
                        <div class="d-grid gap-2">
                            <a href="list2.jsp?page=1" class="btn btn-primary">리뷰 게시판으로</a>
                            <a href="write.jsp" class="btn btn-outline-primary">리뷰 작성하기</a>
                            <a href="testLogin.jsp?action=logout" class="btn btn-danger">로그아웃</a>
                        </div>
                    <% } else { %>
                        <form method="post" action="testLogin.jsp">
                            <input type="hidden" name="action" value="login">
                            
                            <div class="mb-3">
                                <label for="userId" class="form-label">테스트 사용자 선택</label>
                                <select class="form-select" name="userId" required>
                                    <option value="">사용자를 선택하세요</option>
                                    <option value="admin">hong gildong</option>
                                    <option value="guest">hong gilsun</option>
                                </select>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary">로그인</button>
                            </div>
                        </form>
                    <% } %>
                </div>
            </div> 
        </div>
    </div>
</div>
</body>
</html>