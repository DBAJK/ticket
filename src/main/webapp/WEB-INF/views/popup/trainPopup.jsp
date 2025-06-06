<%--
  Created by IntelliJ IDEA.
  User: jgkim
  Date: 2025-05-25
  Time: 오후 8:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<div class="ticket-info">
    <input id="ticketId" disabled>
    <input id="placeId" disabled>
    <div class="titleArea">
        <div class="match-title">
            <span id="matchTitle" class="matchTitle"></span>
            <span class="stadiumName"> | </span>
            <span id="stadiumName" class="stadiumName"></span>
        </div>
        <div class="match-date">
            <img id="homeTeamLogo">
            <span id="matchDate" class="matchDate"></span>
        </div>
    </div>
    <select id="sectionSelect" class="section-select">
        <!-- 섹션(구역) 동적으로 삽입 -->
    </select>

    <div class="ticket-reservation-section">
        <div id="seatMap" class="seat-map">
            <!-- 좌석 정보 동적으로 삽입 -->
        </div>

        <div class="person-count">
            <label style="font-size: 40px; font-weight: bold;">인원 선택</label>
            <span id="personCount" style="font-size: 21px;">1인</span>
            <input type="range" id="personRange" class="rangeInput" min="1" max="8" value="1" />
            <button id="reserveButton" class="reserveButton">예매하기</button>
        </div>
    </div>

</div>