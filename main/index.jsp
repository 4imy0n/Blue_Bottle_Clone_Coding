<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	String userName = (String)session.getAttribute("user_name");
  Integer user_idx = (Integer) session.getAttribute("user_idx");
	//int user_idx = (int)session.getAttribute("user_idx");
	String user_id = (String)session.getAttribute("user_id");
	String phone = (String)session.getAttribute("phone");
%>

<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>main</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="./main.css">
    <!-- <link rel="stylesheet" href="./main3.css">
    <link rel="stylesheet" href="./main4.css"> -->
      <style>
          * {
              margin: 0;
              padding: 0;
              box-sizing: border-box;
          }
          .side-bar-container {
              position: fixed;
              top: 0;
              left: -500px; /* 처음엔 화면 밖에 위치 */
              transition: left 0.3s ease;
              background-color: white;
              width: 500px;
              height: 100vh;
              z-index: 999;
          }
          .side-bar-container.active {
              left: 0;  /* active 클래스가 붙으면 화면에 보임 */
          }

          .side-bar-sub {
              margin-top: 180px;
          }

          .close-btn {
              border: 0;
              background-color: inherit;
              position: absolute;
              right: 20px;
              top: 5rem;
              padding: 10px;
          }

          .side-bar-sub ul,li {
              list-style: none none;
          }

          .side-bar-sub a {
              color: black;

          }

          .side-bar-ul li {
              cursor: pointer;
              display: flex;
              align-items: center;
              padding: 10px 30px;
          }

          .side-bar-ul li>p {
              font-size: 0.9rem;
              margin-bottom: 0;
          }

          .side-bar-ul li> p:hover {
              border-bottom: 1px solid black;
          }

      </style>
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
   <div class="side-bar-container">
       <div class="side-bar-sub">
           <button class="close-btn">
               <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon icon-close drawer-toggle">
                   <g id="close X">
                       <rect id="Rectangle 13" y="13.125" width="18.5616" height="1.23744" transform="rotate(-45 0 13.125)" fill="#333333"></rect>
                       <rect id="Rectangle 14" x="0.875" width="18.5616" height="1.23744" transform="rotate(45 0.875 0)" fill="#333333"></rect>
                   </g>
               </svg>
           </button>
           <ul class="side-bar-ul">
               <a href="../shopping/coffee.jsp"><li><p>커피</p></li></a>
               <a href="../shopping/Cup&Tumbler.jsp"><li><p>컵과 텀블러</p></li></a>
               <a href="../shopping/Brewing_Tools.jsp"><li><p>브루잉 도구</p></li></a>
               <a href="../shopping/Leaf_Style.jsp"><li><p>라이프 스타일</p></li></a>
           </ul>
       </div>
   </div>

    <!-- 베스트셀러 이미지 -->
    <div id="carouselExampleFade" class="carousel slide carousel-fade">
        <div class="carousel-inner">
            <div class="carousel-item active position-relative">
                <img src="./images/bstt1.jpg" class="d-block w-100" alt="...">
                <div class="carousel-caption text-start my_carousel">
                    <h2 class="fw-bold">새로운 시즌 아이템</h2>
                    <p>무료배송 혜택으로 만나는 베스트셀러</p>
                    <a href="../shopping/bestseller.jsp" class="btn btn-light rounded-0 text-dark fw-bold" style="width: 290px;">자세히 보기</a>
                </div>
            </div>
            <div class="carousel-item position-relative">
                <img src="./images/bstt2.jpg" class="d-block w-100" alt="...">
                <div class="carousel-caption text-start my_carousel">
                    <h2 class="fw-bold">선물 제안</h2>
                    <p>소중한 분을 위한 블루보틀 선물세트</p>
                    <a href="../shopping/sets.jsp" class="btn btn-light rounded-0 text-dark fw-bold" style="width: 290px;">자세히 보기</a>
                </div>
            </div>
            <div class="carousel-item position-relative">
                <img src="./images/bstt3.jpg" class="d-block w-100" alt="...">
                <div class="carousel-caption text-start my_carousel">
                    <h2 class="fw-bold">마리메꼬 X 블루보틀 커피</h2>
                    <p>마리메꼬와 블루보틀의 콜라보레이션을 자금 만나보세요</p>
                    <a href="../shopping/coffee.jsp" class="btn btn-light rounded-0 text-dark fw-bold" style="width: 290px;">자세히 보기</a>
                </div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleFade" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleFade" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </div><br><br><br><br>

    <!-- 베스트셀러 제품 1 -->
    <div id="carouselExample" class="carousel slide">
        <div class="carousel-inner">
            <div class="carousel-item active">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-md-4">
                            <div class="line">
                                <div class="card-body">
                                    <h5 class="card-title">그레이 코튼 쿨러백</h5>
                                    <p class="card-text">크래트프 인스턴트 커피 익스프레소</p>
                                </div>
                                <a href="../products/life-gray-cooler-bag.jsp">
                                    <img src="./images/240703_Gray-Cooler-Bag_1.webp" class="img-fluid" alt="...">
                                </a>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="line">
                                <div class="card-body">
                                    <h5 class="card-title">벨라 도노반</h5>
                                    <p class="card-text">블루보틀 시그니처 블렌드</p>
                                </div>
                                <a href="../products/coffee-bella-donovan.jsp">
                                    <img src="./images/D1_bella_1600.webp" class="img-fluid" alt="...">
                                </a>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card-body">
                                <h5 class="card-title">클리어 콜드 텀블러 20oz</h5>
                                <p class="card-text">넉넉한 사이즈와 실용적인 디자인</p>
                            </div>
                            <a href="../products/cup-clear-cold-tumbler-20oz-591-ml.jsp">
                                <img src="./images/M1_ClearColdTumbler20oz_Hero.webp" class="img-fluid" alt="...">
                            </a>
                        </div>
                    </div>
                </div>
            </div>
          <div class="carousel-item">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-md-4">
                            <div class="line">
                                <div class="card-body">
                                    <h5 class="card-title">하리오 우드 주전자</h5>
                                    <p class="card-text">간편하게 즐기는 스페셜티 커피</p>
                                </div>
                                <a href="../products/brew_hario-wood-kettle.jsp">
                                    <img src="./images/D1_1600x1600_20250116_717d8b2e-d942-46b7-92b9-9c5735d46523.webp" class="img-fluid" alt="...">
                                </a>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="line">
                                <div class="card-body">
                                    <h5 class="card-title">블루보틀 머그</h5>
                                    <p class="card-text">커피 한 잔을 위한 완벽한 조력자</p>
                                </div>
                            <a href="../products/cup-blue-bottle-mug.jsp">
                                <img src="./images/Claska-Mug.png" class="img-fluid" alt="...">
                            </a>
                        </div>
                      </div>
                        <div class="col-md-4">
                            <div class="card-body">
                                <h5 class="card-title">제이드 포셀린 라운드 컵</h5>
                                <p class="card-text">중국 전통 도자기 원료와 청색 유약으로 제작</p>
                            </div>
                            <a href="../products/cup-lny-ceramic-cup.jsp">
                                <img src="./images/LNYJadeCup.png" class="img-fluid" alt="...">
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
  
    
        <button class="carousel-control-prev" type="button" data-bs-target="#carouselExample" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#carouselExample" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </div><br><br><br><br>

    <!-- 시그니처 이미지 -->
    <div class="carousel-inner">
        <div class="carousel-item active position-relative my_carouselImage">
            <img src="./images/signiture.jpg" class="d-block w-100" alt="...">
            <div class="carousel-caption text-start my_carousel2">
                <h2 class="fw-bold">핀란드 커피 문화에 담긴 일상의 아름다움</h2>
                <p>커피 한잔의 예술과 프린트 디자인의 아름다움이 만났습니다.<br>핀란드 디자인 하우스 마리메꼬와의 특별한 콜라보레이셔 스토리를 만나보세요.</p>
                <a href="../shopping/Cup&Tumbler.jsp" class="btn btn-light rounded-0 text-dark fw-bold" style="width: 290px;">자세히 보기</a>
            </div>
        </div>
    </div><br><br><br><br>

    <!-- 베스트셀러 제품 2 -->
    <div class="row ms-4 my_best">
        <div class="container">
            <h3 class="mb-3">베스트셀러</h3>
        </div>
        
        <div class="col-auto">
            <div class="card card-1 position-relative" style="width: 25rem;">
                <div class="card-body">
                    <h5 class="card-title mt-5">크래프트 인스턴트 커피 브라이트</h5>
                </div>
                <div class="image-wrapper">
                    <img src="../search/images/1600x1600_BBCK_craft-instant-coffee_bright_outer-box.webp" class="card-img-top base-img w-75 mx-auto d-block" alt="...">
                    <img src="../search/images/1000x1250_BBC_SPR23_DAY1_S21_0386-edited_bright.webp" class="card-img-top hover-img w-75 mx-auto d-block" alt="...">
                </div>
                <div class="card-body">
                    <p class="card-text mt-3">블루보틀을 대표하는 시그니처 블렌드</p>
                </div>
                <a href="../products/coffee-instant-bright-ms.jsp" class="btn btn-light detail-btn my-detail">자세히 보기</a>
            </div>
        </div>
        <div class="col-auto">
            <div class="card card-1 position-relative" style="width: 25rem;">
                <div class="card-body">
                    <h5 class="card-title mt-5">블루보틀 커피 드리퍼</h5>
                </div>
                <div class="image-wrapper">
                    <img src="../search/images/Blue-Bottle-Coffee-Dripper-M1-Hero.webp" class="card-img-top base-img w-75 mx-auto d-block" alt="...">
                    <img src="../search/images/20240729_1000x1250px_Blue-Bottle-Coffee-Dripper-Image_01.webp" class="card-img-top hover-img w-75 mx-auto d-block" alt="...">
                </div>
                <div class="card-body">
                    <p class="card-text mt-3">블루보틀 카페에서 사용되는 컵과 소서 세트</p>
                </div>
                <a href="../products/brew_bluebottle-coffee-dripper.jsp" class="btn btn-light detail-btn my-detail">자세히 보기</a>
            </div>
        </div>
        <div class="col-auto">
            <div class="card card-1 position-relative" style="width: 25rem;">
                <div class="card-body">
                    <h5 class="card-title mt-5 mb-2">엠브로이더리 에코 백<br>-커피 리프-</h5>
                </div>
                <div class="image-wrapper">
                    <img src="../search/images/M1_EmbroideredTote_Hero.webp" class="card-img-top base-img w-75 mx-auto d-block" alt="...">
                    <img src="../search/images/Hover_EmbroideredTote_2a8ef12a-a809-4bb9-8530-2d909f6377d6.webp" class="card-img-top hover-img w-75 mx-auto d-block" alt="...">
                </div>
                <div class="card-body">
                    <p class="card-text mt-3">간편하게 즐기는 카페 퀄리티의 라떼</p>
                </div>
                <a href="../products/life_embroidered-eco-bag-coffee-leaves.jsp" class="btn btn-light detail-btn my-detail">자세히 보기</a>
            </div>
        </div>
        <div class="col-auto">
            <div class="card card-1 position-relative" style="width: 25rem;">
                <div class="card-body">
                    <h5 class="card-title mt-5">블루보틀 텀블러</h5>
                </div>
                <div class="image-wrapper">
                    <img src="../search/images/D1_Main_1600x1600_f3f43bab-d63e-4688-adc1-d2a78a251312.webp" class="card-img-top base-img w-75 mx-auto d-block" alt="...">
                    <img src="../search/images/D1_Sub-Hover.webp" class="card-img-top hover-img w-75 mx-auto d-block" alt="...">
                </div>
                <div class="card-body">
                    <p class="card-text mt-3">간결한 디자인에 기능이 더해진 텀블러</p>
                </div>
                <a href="../products/cup-blue-bottle-coffee-tumbler.jsp" class="btn btn-light detail-btn my-detail">자세히 보기</a>
            </div>
        </div>
    </div><br><br><br><br>

    <!-- 푸어오버 키트 -->
    <div class="row">
        <div class="col" style="margin-left: 8%; margin-right: 5%; margin-bottom: 15%;">
            <img src="./images/pouroverkit.jpg" alt="" class="" style="width: 720px; height: 650px;">
        </div>
        <div class="col" style="padding-top: 5%;">
            <p class="fs-4 fw-medium mb-4">온라인 스토어 단독<br>푸어 오버 키트를 만나보세요</p>
            <p class="fw-bold">커피 드리퍼</p>
            <p class="mb-5">최상의 푸어 오버를 위해 탄생한 정교한 디자인과 기능</p>
            <p class="fw-bold">커피 카라페</p>
            <p class="mb-5">드리퍼와 함께 편리하게 사용할 수 있는 디자인과 사이즈</p>
            <p class="fw-bold">커피 필터</p>
            <p class="mb-5">블루보틀의 노하우를 담은 독창적 디자인의 필터</p>
            <div class="text-start">
                <a href="../products/brew_blue-bottle-pour-over-kit.jsp" class="btn w-50 rounded-0 d-block py-3 px-4 fw-medium" type="button" style="background-color: white; color: black; border-color: black; margin-bottom: 150px;">푸어 오버 키트 보기</a>
            </div>
        </div>
    </div>

    <!-- 브루잉 도구 -->
     <div class="row">
        <div class="col" style="margin-left: 8%; margin-right: 5%; margin-top: 6%;">
            <p class="fs-4 fw-medium mb-4">새롭게 선보이는<br>브루잉 도구를 만나보세요</p>
            <p class="fw-bold">콜드브루 피쳐</p>
            <p class="mb-5">대용량을 만나는 콜드브루 보틀</p>
            <p class="fw-bold">프렌치 프레스</p>
            <p class="mb-5">간편한 추출로 즐기는 커피 본연의 풍미</p>
            <p class="fw-bold">푸어 오버 키트</p>
            <p class="mb-5">집에서 즐기는 시그니처 푸어 오버</p>
            <div class="text-start">
                <a href="../shopping/Brewing_Tools.jsp" class="btn rounded-0 d-block py-3 px-4 fw-medium" type="button" style="background-color: white; color: black; border-color: black; margin-bottom: 150px; width: 63%;">브루잉 도구 보기</a>
            </div>
        </div>
        <div class="col" style="margin-left: 0; margin-right: 8%;">
            <img src="./images/bruing.jpg" alt="" class="" style="width: 720px; height: 650px;">
        </div>
    </div>
    
    
    <!-- 카페 찾기 -->
    <div class="my_find_coffee">
        <div id="carouselExampleAutoplaying" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="./images/find_coffee.webp" class="d-block w-100" alt="...">
                    <p class="fs-6 fw-bold">블루보틀 부산 기장 카페</p>
                </div>
                <div class="carousel-item">
                    <img src="./images/find_coffee2.webp" class="d-block w-100" alt="...">
                    <p class="fs-6 fw-bold">블루보틀 연남 카페</p>
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleAutoplaying" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleAutoplaying" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>

        <div class="row text-center mt-4">
            <div class="fs-4 fw-normal mb-4">가까운 블루보틀 카페를 확인해보세요</div>
            <div class="d-grid gap-2 col-6 mx-auto">
                <a href="../cafe-list/cafe-list.jsp" class="btn w-50 rounded-0 mx-auto d-block py-3 px-4 fw-medium" type="button" style="background-color: white; color: black; border-color: black; margin-bottom: 150px;">카페 찾기</a>
            </div>
        </div>

        <div class="my_footer">
            <div class="container text-white py-5">
                <div class="row row-cols-1 row-cols-md-4 mb-4">
                <!-- 첫 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">블루보틀 커피</h6>
                        <a href="../cafe-list/cafe-list.jsp" class="text-decoration-none"><p class="mb-1">카페 찾기</p></a>
                        <a href="../footer/bluebottlecoffee_location-Korea.jsp" class="text-decoration-none"><p class="mb-1">커리어</p></a>
                    </div>
                    <!-- 두 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">알아보기</h6>
                        <a href="../footer/bluebottlecoffee_pages_about-us.jsp" class="text-decoration-none"><p class="mb-1">브랜드 소개</p></a>
                        <a href="../footer/bluebottlecoffee_pages_our-coffee.jsp" class="text-decoration-none"><p class="mb-1">블루보틀 커피</p></a>
                        <a href="../footer/bluebottlecoffee_pages-blue-bottle-sustainability.jsp" class="text-decoration-none"><p class="mb-1">지속가능성</p></a>
                        <a href="../footer/Cup&Tumbler.jsp" class="text-decoration-none"><p class="mb-1">브루잉 가이드</p></a>
                        <a href="../Board/list2.jsp" class="text-decoration-none"><p class="mb-1">리뷰</p></a>
                    </div>
                    <!-- 세 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">문의</h6>
                        <a href="../footer/bluebottlecoffee_pages-faq.jsp" class="text-decoration-none"><p class="mb-1">자주 묻는 질문</p></a>
                    </div>
                    <!-- 네 번째 열 -->
                    <div>
                        <h6 class="fw-bold mb-3">구독하고 최신 정보를 받아보세요.</h6>
                        <p class="mb-2">이메일 뉴스레터에 가입하여 혜택과 소식을 받아보세요.</p>

                        <div>
                        	<i class="bi bi-facebook mx-1">
	                        	<a href="https://www.facebook.com/bluebottlecoffee" 
														   class="link list-social__link d-inline-block mx-1" 
														   target="_blank" 
														   aria-label="Facebook">
														    <svg width="18px" height="18px" aria-hidden="true" focusable="false" 
														         class="icon icon-facebook" viewBox="0 0 20 20" 
														         fill="currentColor" color="rgb(218, 218, 218)">
														        <path d="M18 10.049C18 5.603 14.419 2 10 2c-4.419 0-8 3.603-8 8.049C2 14.067 4.925 17.396 8.75 18v-5.624H6.719v-2.328h2.03V8.275c0-2.017 1.195-3.132 3.023-3.132.874 0 1.79.158 1.79.158v1.98h-1.009c-.994 0-1.303.621-1.303 1.258v1.51h2.219l-.355 2.326H11.25V18c3.825-.604 6.75-3.933 6.75-7.951Z"/>
														    </svg>
														</a>
													</i>
							
													<i class="bi bi-twiter mx-1">
														<a href="https://x.com/bluebottleroast" 
														   class="link list-social__link d-inline-block mx-1" 
														   target="_blank" 
														   aria-label="Twitter">
														    <svg width="18px" height="18px" aria-hidden="true" focusable="false" 
														         class="icon icon-facebook" viewBox="0 0 20 20" 
														         fill="currentColor" color="rgb(218, 218, 218)">
														        <path d="M7.27274 2.8L10.8009 7.82176L15.2183 2.8H16.986L11.5861 8.93887L17.3849 17.1928H12.7272L8.99645 11.8828L4.32555 17.1928H2.55769L8.21157 10.7657L2.61506 2.8H7.27274ZM13.5151 15.9248L5.06895 4.10931H6.4743L14.9204 15.9248H13.5151Z"/>
														    </svg>
														</a>
													</i>
							
													<i class="bi bi-instagram mx-1">
														<a href="https://www.instagram.com/bluebottlekorea/" 
														   class="link list-social__link d-inline-block mx-1" 
														   target="_blank" 
														   aria-label="Twitter">
														    <svg width="18px" height="18px" aria-hidden="true" focusable="false" 
														         class="icon icon-facebook" viewBox="0 0 20 20" 
														         fill="currentColor" color="rgb(218, 218, 218)">
														         <path fill="currentColor" fill-rule="evenodd" d="M13.23 3.492c-.84-.037-1.096-.046-3.23-.046-2.144 0-2.39.01-3.238.055-.776.027-1.195.164-1.487.273a2.43 2.43 0 0 0-.912.593 2.486 2.486 0 0 0-.602.922c-.11.282-.238.702-.274 1.486-.046.84-.046 1.095-.046 3.23 0 2.134.01 2.39.046 3.229.004.51.097 1.016.274 1.495.145.365.319.639.602.913.282.282.538.456.92.602.474.176.974.268 1.479.273.848.046 1.103.046 3.238.046 2.134 0 2.39-.01 3.23-.046.784-.036 1.203-.164 1.486-.273.374-.146.648-.329.921-.602.283-.283.447-.548.602-.922.177-.476.27-.979.274-1.486.037-.84.046-1.095.046-3.23 0-2.134-.01-2.39-.055-3.229-.027-.784-.164-1.204-.274-1.495a2.43 2.43 0 0 0-.593-.913 2.604 2.604 0 0 0-.92-.602c-.284-.11-.703-.237-1.488-.273ZM6.697 2.05c.857-.036 1.131-.045 3.302-.045 1.1-.014 2.202.001 3.302.045.664.014 1.321.14 1.943.374a3.968 3.968 0 0 1 1.414.922c.41.397.728.88.93 1.414.23.622.354 1.279.365 1.942C18 7.56 18 7.824 18 10.005c0 2.17-.01 2.444-.046 3.292-.036.858-.173 1.442-.374 1.943-.2.53-.474.976-.92 1.423a3.896 3.896 0 0 1-1.415.922c-.51.191-1.095.337-1.943.374-.857.036-1.122.045-3.302.045-2.171 0-2.445-.009-3.302-.055-.849-.027-1.432-.164-1.943-.364a4.152 4.152 0 0 1-1.414-.922 4.128 4.128 0 0 1-.93-1.423c-.183-.51-.329-1.085-.365-1.943C2.009 12.45 2 12.167 2 10.004c0-2.161 0-2.435.055-3.302.027-.848.164-1.432.365-1.942a4.44 4.44 0 0 1 .92-1.414 4.18 4.18 0 0 1 1.415-.93c.51-.183 1.094-.33 1.943-.366Zm.427 4.806a4.105 4.105 0 1 1 5.805 5.805 4.105 4.105 0 0 1-5.805-5.805Zm1.882 5.371a2.668 2.668 0 1 0 2.042-4.93 2.668 2.668 0 0 0-2.042 4.93Zm5.922-5.942a.958.958 0 1 1-1.355-1.355.958.958 0 0 1 1.355 1.355Z" clip-rule="evenodd"/>
														   </svg>
														 </a>
													 </i>
							 
													 <i class="bi bi-youtube mx-1">
														 <a href="https://www.youtube.com/channel/UCyki4e6RG84BT_xzi4oYkRw" 
														   class="link list-social__link d-inline-block mx-1" 
														   target="_blank" 
														   aria-label="Twitter">
														    <svg width="18px" height="18px" aria-hidden="true" focusable="false" 
														         class="icon icon-facebook" viewBox="0 0 20 20" 
														         fill="currentColor" color="rgb(218, 218, 218)">
														         <path fill="currentColor" d="M18.16 5.87c.34 1.309.34 4.08.34 4.08s0 2.771-.34 4.08a2.125 2.125 0 0 1-1.53 1.53c-1.309.34-6.63.34-6.63.34s-5.321 0-6.63-.34a2.125 2.125 0 0 1-1.53-1.53c-.34-1.309-.34-4.08-.34-4.08s0-2.771.34-4.08a2.173 2.173 0 0 1 1.53-1.53C4.679 4 10 4 10 4s5.321 0 6.63.34a2.173 2.173 0 0 1 1.53 1.53ZM8.3 12.5l4.42-2.55L8.3 7.4v5.1Z"/>
													        </svg>
														 </a>
													 </i>
													
													 <i class="bi bi-kakaotalk mx-1">
														 <a href="http://pf.kakao.com/_yShcxj" 
														    class="link list-social__link d-inline-block mx-1" 
														    target="_blank" 
														    aria-label="Twitter">
														    <svg width="18px" height="18px" aria-hidden="true" focusable="false" 
														         class="icon icon-facebook" viewBox="0 0 20 20" 
														         fill="currentColor" color="rgb(218, 218, 218)">
														         <path id="Vector" d="M9.00091 0C4.02898 0 0 3.10133 0 6.92915C0 9.41946 1.70716 11.6042 4.26973 12.8245C4.08187 13.5084 3.5876 15.3042 3.48911 15.6878C3.36691 16.1639 3.66785 16.1586 3.86483 16.0307C4.01986 15.9294 6.33073 14.3983 7.3284 13.7393C7.8701 13.8175 8.42821 13.8583 8.99909 13.8583C13.9692 13.8583 18 10.757 18 6.92915C18 3.10133 13.971 0 9.00091 0Z" fill="#DADADA"/>
														         </svg>
														 </a>
													 </i>
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


    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const sidebar = document.querySelector('.side-bar-container');
            const closeBtn = document.querySelector('.close-btn');
            const shoppingMenu = document.querySelectorAll('.nav-link')[0]; // 첫 번째 nav-link가 쇼핑

            shoppingMenu.addEventListener('click', function(e) {
                e.preventDefault();
                sidebar.classList.add('active');
                document.body.style.overflow = 'hidden'; // 스크롤 막기
            });

            closeBtn.addEventListener('click', function() {
                sidebar.classList.remove('active');
                document.body.style.overflow = ''; // 스크롤 다시 허용
            });
        });
    </script>
  </body>
</html>