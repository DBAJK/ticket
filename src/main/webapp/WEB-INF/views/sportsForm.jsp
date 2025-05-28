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
<style>
    .main-content-area {
        background: #fff;
        border-radius: 12px;
        padding: 20px;
        width: 100%;
    }

    .main-slider {
        position: relative;
        width: 100%;
        height: 55%;
        margin-bottom: 30px;
        background: transparent;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .slider-placeholder {
        width: 100%;
        height: 100%;
        background: #d3d3d3;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 2rem;
        color: #888;
        position: relative;
        z-index: 1;
    }

    .arrow {
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        background: #fff;
        border: 1.5px solid #d0d2d8;
        border-radius: 50%;
        width: 38px;
        height: 38px;
        font-size: 1.5rem;
        color: #4a5cc6;
        cursor: pointer;
        z-index: 2;
        box-shadow: 0 2px 8px rgba(0,0,0,0.07);
        transition: background 0.2s;
    }

    .arrow.left {
        left: 12px;
    }

    .arrow.right {
        right: 12px;
    }

    .arrow:hover {
        background: #f5f6fa;
    }

    .slider-pagination {
        position: absolute;
        left: 24px;
        bottom: 16px;
        background: rgba(255,255,255,0.8);
        padding: 2px 10px;
        border-radius: 8px;
        font-size: 1rem;
        color: #444;
        z-index: 2;
        font-weight: bold;
    }

    .ticket-section {
        width: 100%;
    }

    .ticket-header {
        display: flex;
        align-items: center;
        margin-bottom: 16px;
        gap: 16px;
    }

    .open-title {
        font-weight: bold;
        color: #3653c6;
        font-size: 1.1rem;
        margin-right: 10px;
    }

    .wait-title {
        color: #b0b5c1;
        font-size: 1.1rem;
        margin-right: auto;
    }

    .nav-btns button {
        background: #f5f6fa;
        border: 1px solid #d0d2d8;
        border-radius: 4px;
        width: 28px;
        height: 28px;
        margin-left: 4px;
        cursor: pointer;
        font-size: 1rem;
    }

    .ticket-cards {
        display: flex;
        gap: 18px;
    }
    .ticket-card {
        width: 300px;
        height: 350px;
        border: 1px solid #eee;
        border-radius: 12px;
        display: flex;
        align-items: flex-end;
        justify-content: center;
        padding: 16px;
        margin-bottom: 16px;
        background: #f5f6fa;
        padding-bottom: 18px;
        box-sizing: border-box;
    }
    .teams-row img {
        border-radius: 50%;
        background: #f5f5f5;
    }

    .ticket-card button {
        width: 90%;
        height: 36px;
        background: #3653c6;
        color: #fff;
        border: none;
        border-radius: 8px;
        font-size: 1rem;
        font-weight: bold;
        cursor: pointer;
    }

    .ticket-card button:disabled {
        background: #ccc;
        color: #888;
        cursor: not-allowed;
    }

</style>
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
        <div class="ticket-cards open-tickets"></div>
        <div class="ticket-cards wait-tickets" style="display:none;"></div>
    </div>

    <img src="${pageContext.request.contextPath}/resources/images/a.jpg" />
</div>
<script>
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

    // 페이지 진입 시 기본 예매오픈 탭 보이기
    $(document).ready(function() {
        loadTickets();
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
        '/resources/images/a.jpg',
        '/resources/images/b.jpg',
        '/resources/images/c.jpg'
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
                const todayDate = new Date();
                const openContainer = $('.open-tickets');
                const waitContainer = $('.wait-tickets');

                openContainer.empty();
                waitContainer.empty();
                data.forEach(ticket => {
                    const matchDate = new Date(ticket.matchDate);
                    const openDate = new Date(ticket.openDate); // 예매 오픈일
                    const todayDate = new Date();
                    todayDate.setHours(0, 0, 0, 0);
                    matchDate.setHours(0, 0, 0, 0);

                    // 카드 전체 div
                    const card = $('<div>').addClass('ticket-card');

                    // --- 상단: 팀 로고와 vs ---
                    const teamsDiv = $('<div>').addClass('teams-row').css({
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        gap: '10px'
                    });
                    const homeLogo = $('<img>').attr('src', ticket.homeTeam.logo).attr('alt', ticket.homeTeam.name).css({width: '48px', height: '48px'});
                    const vsText = $('<span>').text('vs').css({fontWeight: 'bold', fontSize: '20px', margin: '0 8px'});
                    const awayLogo = $('<img>').attr('src', ticket.awayTeam.logo).attr('alt', ticket.awayTeam.name).css({width: '48px', height: '48px'});
                    teamsDiv.append(homeLogo, vsText, awayLogo);

                    // --- 경기 정보 ---
                    const infoDiv = $('<div>').addClass('match-info').css({textAlign: 'center', margin: '10px 0'});
                    infoDiv.append(
                        $('<div>').text(`${matchDate.toLocaleDateString('ko-KR')} (${['일','월','화','수','목','금','토'][matchDate.getDay()]}) ${ticket.matchDate.substring(11,16)}`),
                        $('<div>').text(ticket.stadium)
                    );

                    // --- 버튼 또는 오픈예정 안내 ---
                    let buttonDiv;
                    if (todayDate >= openDate) {
                        // 예매 가능
                        const button = $('<button>').text('예매하기');
                        buttonDiv = $('<div>').append(button);
                    } else {
                        // 예매대기 (비활성 버튼 또는 안내)
                        buttonDiv = $('<div>').append(
                            $('<button>').text(`${openDate.toLocaleDateString('ko-KR')} (${['일','월','화','수','목','금','토'][openDate.getDay()]}) ${openDate.toTimeString().slice(0,5)} 오픈예정`)
                                .prop('disabled', true)
                                .css({background: '#eee', color: '#888', cursor: 'not-allowed', width: '100%'})
                        );
                    }

                    // 카드에 요소 추가
                    card.append(teamsDiv, infoDiv, buttonDiv);

                    // openContainer, waitContainer에 분류
                    if (todayDate >= openDate) {
                        openContainer.append(card);
                    } else {
                        waitContainer.append(card);
                    }
                });

            },
            error: function (xhr, status, error) {
                console.error('AJAX 요청 실패:', status, error);
                alert('티켓 정보를 불러오는 데 실패했습니다.');
            }
        });
    }

</script>