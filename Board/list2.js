// list2.jsp의 JavaScript 부분 - 대폭 간소화

// 상품별 리뷰 목록 모달은 유지 (이건 유용함)
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

// 리뷰 상세 - 모달 대신 페이지 이동으로 변경
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

function validateSearch() {
    const searchWord = document.querySelector('input[name="searchWord"]').value.trim();
    if (searchWord === '') {
        alert('검색어를 입력해주세요!!!');
        return false; // 폼 제출 중단
    }
    return true; // 폼 제출 허용
}