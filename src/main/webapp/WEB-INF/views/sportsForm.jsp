<%--
  Created by IntelliJ IDEA.
  User: jgkim
  Date: 2025-05-17
  Time: 오후 8:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<link href="/resources/css/sportsForm.css" rel="stylesheet" type="text/css">
<div class="main-content-area">
    <div class="main-slider">
        <!-- 슬라이드/배너 이미지 또는 콘텐츠 (예시로 회색 박스) -->
        <button class="arrow left" onclick="prevSlide()">&#60;</button>
        <div class="slider-placeholder" id="sliderImage">
            <!-- 실제 이미지 또는 배너가 들어갈 자리 -->
        </div>
        <button class="arrow right" onclick="nextSlide()">&#62;</button>
        <div class="slider-pagination">
            <span id="slideIndex">1</span>/<span id="slideTotal">3</span>
        </div>
    </div>
    <div class="ticket-section">
        <div class="ticket-header">
            <span class="open-title">예매오픈</span>
            <span class="wait-title">예매대기</span>
            <div class="nav-btns">
                <button>&lt;</button>
                <button>&gt;</button>
            </div>
        </div>
        <div class="ticket-cards open-tickets"></div>       <%--예매 오픈 카드--%>
        <div class="ticket-cards wait-tickets" style="display:none;"></div> <%--예매 대기 카드--%>
    </div>
</div>
<script>
    // 페이지 진입 시 기본 예매오픈 탭 보이기
    $(document).ready(function() {
        loadTickets();
        $(document).on('click', '.reserveButton', function () { //
            const placeId = '10010';
            window.open('popup/sportsPopup?placeId=' + placeId, "sportsPopupForm", "width=1300,height=900");
        });
        // 탭 클릭 이벤트
        $('.open-title').on('click', function() {
            $('.open-tickets').show();
            $('.wait-tickets').hide();
            // 탭 스타일 활성화 처리도 필요하면 추가
        });

        $('.wait-title').on('click', function() {
            $('.open-tickets').hide();
            $('.wait-tickets').show();
            // 탭 스타일 활성화 처리도 필요하면 추가
        });

        $('.open-tickets').show();
        $('.wait-tickets').hide();
    });


    // 초기 표시
    document.addEventListener('DOMContentLoaded', function() {
        showSlide(currentSlide);
        loadTickets(); // 티켓 카드 초기화
    });

    // 예시용 슬라이드 데이터 (이미지 경로 또는 텍스트)
    const contextPath = '${pageContext.request.contextPath}';
    const slides = [
        '/resources/images/homeImage.avif',
        '/resources/images/landersField.jfif',
        '/resources/images/eaglesPark.webp'
    ];

    let currentSlide = 0;

    function showSlide(idx) {
        if (idx < 0 || idx >= slides.length) {
            console.error("슬라이드 인덱스가 범위를 벗어났습니다.");
            return;
        }
        const slider = document.getElementById('sliderImage');
        slider.innerHTML = `
            <img src=" ${'${slides[idx]}'}"
                 alt="슬라이드 이미지"
                 style="width: 100%; height: 100%; object-fit: cover;">
        `;
        document.getElementById('slideIndex').textContent = idx + 1;
        document.getElementById('slideTotal').textContent = slides.length;
    }

    function prevSlide() {
        currentSlide = (currentSlide - 1 + slides.length) % slides.length;
        showSlide(currentSlide);
    }

    function nextSlide() {
        currentSlide = (currentSlide + 1) % slides.length;
        showSlide(currentSlide);
    }

    function loadTickets() {
        $.ajax({
            url: '/getTicketList', // 티켓 리스트 API
            method: 'GET',
            dataType: 'json',
            success: function (data) {
                const now = new Date(); // 현재 시각
                const openContainer = $('.open-tickets');
                const waitContainer = $('.wait-tickets');

                openContainer.empty();
                waitContainer.empty();

                data.forEach(ticket => {
                    const matchDate = new Date(ticket.matchDate); // 예: 2025-06-06T18:30
                    const openDate = new Date(ticket.openDate);    // 오픈일시
                    const now = new Date();
                    const matchformatDate = formatMatchDate(matchDate);
                    // --- 최상단 카드 컨테이너 ---
                    const card = $('<div>').addClass('match_card');

                    // --- 시각 영역: 로고 및 vs ---
                    const visual = $('<div>').addClass('match_card_visual');
                    const teamGroup = $('<div>').addClass('match_team_group');

                    const homeImgBox = $('<div>').addClass('match_team_imgbox');
                    const homeImg = $('<img>').addClass('match_team_img')
                        .attr('src', ticket.homeTeamLogo)
                        .attr('alt', ticket.homeTeamName);
                    homeImgBox.append(homeImg);

                    const vsIcon = $('<span>').addClass('common_icon icon_versus').text('vs');

                    const awayImgBox = $('<div>').addClass('match_team_imgbox');
                    const awayImg = $('<img>').addClass('match_team_img')
                        .attr('src', ticket.awayTeamLogo)
                        .attr('alt', ticket.awayTeamName);
                    awayImgBox.append(awayImg);

                    teamGroup.append(homeImgBox, vsIcon, awayImgBox);
                    visual.append(teamGroup);

                    // --- 경기 정보 영역 ---
                    const info = $('<div>').addClass('match_card_info');
                    info.append(
                        $('<span>').addClass('match_card_date').text(matchformatDate),
                        $('<span>').addClass('match_card_place').text(ticket.stadium)
                    );

                    // --- 버튼 영역 ---
                    const btnArea = $('<div>').addClass('match_card_btnarea');
                    const btnBox = $('<div>').addClass('common_btn_box');

                    if (now >= openDate) {
                        const reserveBtn = $('<button>')
                            .attr('data-match-area', ticket.stadium) // 예시: 식별을 위한 데이터 속성
                            .addClass('common_btn btn_primary btn_large plan_sale reserveButton')
                            .text('예매하기');
                        btnBox.append(reserveBtn);
                    } else {
                        const openDateStr = formatMatchDate(openDate);
                        const disabledBtn = $('<a>')
                            .addClass('common_btn btn_primary btn_large plan_sale')
                            .attr('aria-disabled', 'true')
                            .text(openDateStr);
                        btnBox.append(disabledBtn);
                    }

                    btnArea.append(btnBox);

                    // --- 카드 조립 ---
                    card.append(visual, info, btnArea);

                    // --- DOM 삽입 ---
                    if (now >= openDate) {
                        $('.open-tickets').append(card);
                    } else {
                        $('.wait-tickets').append(card);
                    }
                });
            },
            error: function (xhr, status, error) {
                console.error('AJAX 요청 실패:', status, error);
                alert('티켓 정보를 불러오는 데 실패했습니다.');
            }
        });
    }
    function formatMatchDate(dateString) {  // 날짜 변환
        const date = new Date(dateString); // 예: "2025-06-06T18:30"

        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0'); // 1월이 0이므로 +1
        const day = String(date.getDate()).padStart(2, '0');
        const weekday = ['일','월','화','수','목','금','토'][date.getDay()];
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        const formatDate = year + '.' + month + '.' + day + '(' + weekday + ')' +  hours + ':' + minutes;
        return formatDate;
    }

</script>