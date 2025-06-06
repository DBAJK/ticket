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
        <div class="slider-track" id="sliderTrack">
            <!-- 이미지 슬라이드들이 여기 들어감 -->
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
                <button class="leftSlide">&lt;</button>
                <button class="rightSlide">&gt;</button>
            </div>
        </div>
        <div class="ticket-cards open-tickets"><%--예매 오픈 카드--%>
            <div class="ticket-track"></div>
        </div>
        <div class="ticket-cards wait-tickets" style="display:none;"> <%--예매 대기 카드--%>
            <div class="ticket-track"></div>
        </div>
    </div>
</div>
<script>
    // 페이지 진입 시 기본 예매오픈 탭 보이기
    $(document).ready(function () {
        $(document).on('click', '.reserveButton', function () { //

            const placeId = $(this).data('place-id');
            window.open('popup/sportsPopup?placeId=' + placeId, "sportsPopupForm", "width=1750,height=1200");
        });
        // 탭 클릭 이벤트
        $('.open-title').on('click', function () {
            $('.open-tickets').show();
            $('.wait-tickets').hide();
            // 탭 스타일 활성화 처리도 필요하면 추가
        });

        $('.wait-title').on('click', function () {
            $('.open-tickets').hide();
            $('.wait-tickets').show();
            // 탭 스타일 활성화 처리도 필요하면 추가
        });

        $('.open-tickets').show();
        $('.wait-tickets').hide();
        loadTickets();
    });


    // 초기 표시
    document.addEventListener('DOMContentLoaded', function () {
        renderSlides();
        loadTickets(); // 티켓 카드 초기화

        // 6초(6000ms)마다 다음 슬라이드로 자동 전환
        setInterval(() => {
            nextSlide();
        }, 6000);
    });

    const slides = [
        '/resources/images/homeImage.avif',
        '/resources/images/landersField.jfif',
        '/resources/images/eaglesPark.webp'
    ];

    let currentSlide = 0;

    let openCardsIndex = 0;
    let waitCardsIndex = 0;
    let openCardsTotal = 0;
    let waitCardsTotal = 0;
    const cardsPerView = 4;


    function renderSlides() {
        const track = document.getElementById('sliderTrack');
        console.log(slides.map);
        track.innerHTML = slides.map(src => `
        <div class="slide">
            <img src="${'${src}'}" alt="슬라이드 이미지">
        </div>
    `).join('');
        document.getElementById('slideTotal').textContent = slides.length;
        updateSlide();
    }

    function updateSlide() {
        const track = document.getElementById('sliderTrack');
        track.style.transform = `translateX(-${'${currentSlide * 100}'}%)`;
        document.getElementById('slideIndex').textContent = currentSlide + 1;
    }

    function prevSlide() {
        currentSlide = (currentSlide - 1 + slides.length) % slides.length;
        updateSlide();
    }

    function nextSlide() {
        currentSlide = (currentSlide + 1) % slides.length;
        updateSlide();
    }

    function loadTickets() {
        $.ajax({
            url: '/getTicketList', // 티켓 리스트 API
            method: 'GET',
            dataType: 'json',
            success: function (data) {
                const now = new Date(); // 현재 시각

                // 기존 컨테이너 초기화
                const openContainer = $('.open-tickets');
                const waitContainer = $('.wait-tickets');
                openContainer.empty();
                waitContainer.empty();

                // 각 트랙(div) 재생성
                const openTrack = $('<div>').addClass('ticket-track');
                const waitTrack = $('<div>').addClass('ticket-track');
                openContainer.append(openTrack);
                waitContainer.append(waitTrack);

                openCardsTotal = 0;
                waitCardsTotal = 0;

                data.forEach(ticket => {
                    const matchDate = new Date(ticket.matchDate);
                    const openDate = new Date(ticket.openDate);
                    const matchformatDate = formatMatchDate(matchDate);

                    const card = $('<div>').addClass('match_card');

                    // 비주얼 영역
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

                    // 정보 영역
                    const info = $('<div>').addClass('match_card_info');
                    info.append(
                        $('<span>').addClass('match_card_date').text(matchformatDate),
                        $('<span>').addClass('match_card_place').text(ticket.stadium)
                    );

                    // 버튼 영역
                    const btnArea = $('<div>').addClass('match_card_btnarea');
                    const btnBox = $('<div>').addClass('common_btn_box');

                    if (now >= openDate) {
                        const reserveBtn = $('<button>')
                            .attr('data-match-area', ticket.stadium)
                            .attr('data-place-id', ticket.placeId)
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

                    // 카드 조립
                    card.append(visual, info, btnArea);

                    // 분기 삽입
                    if (now >= openDate) {
                        openTrack.append(card);
                        openCardsTotal++;
                    } else {
                        waitTrack.append(card);
                        waitCardsTotal++;
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
        const weekday = ['일', '월', '화', '수', '목', '금', '토'][date.getDay()];
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        const formatDate = year + '.' + month + '.' + day + '(' + weekday + ')' + hours + ':' + minutes;
        return formatDate;
    }

    function slideOpenTickets(direction) {
        const track = document.querySelector('.open-tickets .ticket-track');
        const cards = track.querySelector('.match_card');
        if (cards.length === 0) return; // 카드가 없으면 리턴
        const cardWidth = cards.offsetWidth + 16; // 첫 번째 카드 너비 + 간격
        const maxIndex = Math.max(0, openCardsTotal - cardsPerView);

        if (direction === 'prev') openCardsIndex = Math.max(0, openCardsIndex - 1);
        if (direction === 'next') openCardsIndex = Math.min(maxIndex, openCardsIndex + 1);

        track.style.transform = `translateX(-${'${openCardsIndex * cardWidth}'}px)`;
    }

    // 버튼 이벤트 등록
    document.querySelector('.nav-btns .leftSlide').addEventListener('click', () => {
        slideOpenTickets('prev');
    });

    document.querySelector('.nav-btns .rightSlide').addEventListener('click', () => {
        slideOpenTickets('next');
    });

</script>