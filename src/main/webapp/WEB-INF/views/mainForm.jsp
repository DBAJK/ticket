<%--
  Created by IntelliJ IDEA.
  User: jgkim
  Date: 2025-05-17
  Time: 오후 8:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
        height: 45%;
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
        background: #f5f6fa;
        border-radius: 12px;
        display: flex;
        align-items: flex-end;
        justify-content: center;
        padding-bottom: 18px;
        box-sizing: border-box;
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
        <div class="ticket-cards">
            <div class="ticket-card"><button>2025.xx.xx 예매</button></div>
            <div class="ticket-card"><button>2025.xx.xx 예매</button></div>
            <div class="ticket-card"><button>2025.xx.xx 예매</button></div>
            <div class="ticket-card"><button>2025.xx.xx 예매</button></div>
        </div>
    </div>
</div>
<script>

    // 예시용 슬라이드 데이터 (이미지 경로 또는 텍스트)
    const slides = [
        "슬라이드 1",
        "슬라이드 2",
        "슬라이드 3"
    ];
    let currentSlide = 0;

    function showSlide(idx) {
        const slider = document.getElementById('sliderImage');
        slider.textContent = slides[idx];
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

    // 초기 표시
    document.addEventListener('DOMContentLoaded', function() {
        showSlide(currentSlide);
    });

</script>