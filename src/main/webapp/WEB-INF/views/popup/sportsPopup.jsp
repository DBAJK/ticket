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
<style>
    .titleArea {
        display: flex;
        width: 100%;
        align-items: center;
        justify-content: space-between;
    }

    .match-title {
        background-color: #62676c;
        flex: 6;
        display: flex;
        align-items: center;
        padding: 10px;
    }

    .matchTitle {
        font-size: 60px;
        font-weight: bold;
        color: #000000;
        margin-left: 15px;
    }

    .stadiumName {
        font-size: 25px;
        color: #6189e0;
        margin-left: 5px;
    }

    .match-date {
        flex: 1;
        display: flex;
        font-size: 23px;
        flex-direction: column; /* 위아래 정렬 */
        align-items: center;
        justify-content: center;
        gap: 8px;
    }

    .match-date img {
        width: 50px;
        height: 50px;
    }

    .section-select {
        width: 500px;
        height: 70px;
        font-size: 24px;
        font-weight: bold;
        padding: 0 12px;
        border: 1.5px solid #d0d2d8;
        border-radius: 6px;
        background: #f5f6fa;
        outline: none;
        transition: border 0.2s;
        box-sizing: border-box;
    }

    .ticket-reservation-section{
        display: flex;
    }

    .person-count{
        gap: 6px;
        margin-top: 20px;
        flex: 2;
    }

    .seat-map {
        background-color: #a7acb6;
        border: #62676c;
        display: grid;
        gap: 6px;
        padding: 20px 25px 0px;
        flex: 7;
    }
    .seat-zone {
        margin-bottom: 16px;
    }

    .seat-row {
        margin-bottom: 6px;
        display: flex;
    }

    .seat {
        width: 35px;
        height: 35px;
        display: inline-block;
        margin: 4px;
        background-color: #3b73c4; /* 기본 파란색 */
        border-radius: 30% 30% 40% 40% / 50% 50% 20% 20%; /* 이미지와 유사한 곡선 */
        box-shadow:
                inset -1px -1px 2px rgba(255, 255, 255, 0.3),
                inset 2px 2px 4px rgba(0, 0, 0, 0.3),
                1px 1px 2px rgba(0, 0, 0, 0.2);
        cursor: pointer;
        transition: all 0.2s ease-in-out;
    }

    .seat:hover {
        transform: scale(1.1);
        box-shadow:
                inset -1px -1px 2px rgba(255, 255, 255, 0.4),
                inset 2px 2px 4px rgba(0, 0, 0, 0.4),
                2px 2px 3px rgba(0, 0, 0, 0.3);
    }

    .seat.unavailable {
        background-color: #ccc;
        box-shadow: none;
        cursor: not-allowed;
    }

    .seat.selected {
        background-color: #8e44ad; /* 선택 시 보라색 */
        box-shadow:
                inset -1px -1px 2px rgba(255, 255, 255, 0.2),
                inset 2px 2px 3px rgba(0, 0, 0, 0.4);
    }

    .reserveButton {
        margin: 25px 0px 0px 5px;
        border-radius: 8px;
        font-weight: 700;
        font-size: 18px;
        line-height: 28px;
        width: 100%;
        height: 48px;
        letter-spacing: -0.04em;
        cursor: pointer;
        transition: background-color 0.2s, border-color 0.2s;
        padding: 0 24px; /* 너비를 적당히 주기 위해 padding 사용 */
        text-align: center;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background-color: #4a5cc6;
        border: 1px solid #4a5cc6;
        color: #fff;
    }
    .reserveButton:hover,
    .reserveButton:focus {
        background-color: #3c4db8;
        border-color: #3c4db8;
    }
    #personRange {
        height: 30px; /* 원하는 높이로 조절 */
    }
    .rangeInput{
        width: 100%;
        margin: 10px 0px 10px 5px;
        background: linear-gradient(to right, #4a5cc6 0%, #4a5cc6 12.5%, #ececec 12.5%, #ececec 100%);
        border-radius: 8px;
        outline: none;
        transition: background 450ms ease-in;
        -webkit-appearance: none;
        accent-color: #4a5cc6;
    }
</style>
<div class="ticket-info">
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

<script>
    $(document).ready(function () {
        const urlParams = new URLSearchParams(window.location.search);
        const placeId = urlParams.get('placeId');
        let globalSeatData = []; // 전역으로 저장할 seat 데이터

        // 경기 정보 및 구역 리스트 로딩
        $.ajax({
            url: '/api/matchSeat',
            method: 'GET',
            dataType: 'json',
            data: {'placeId' : placeId},
            success: function (data) {
                const logoUrl = data[0].homeTeamLogo; // 예: 'https://example.com/logo.png'
                if (homeTeamLogo) {
                    $("#homeTeamLogo").attr("src", logoUrl);
                } else {
                    $("#homeTeamLogo").attr("alt", data[0].placeName); // 기본값 처리
                }

                $('#matchTitle').text(data[0].ticketName);
                $('#stadiumName').text(data[0].placeName);
                $('#matchDate').text(formatMatchDate(data[0].startDate));

                globalSeatData = data; // 전역 저장

                const select = $('#sectionSelect');
                const seatMap = $('#seatMap');
                const uniqueZones = new Set();

                seatMap.empty(); // 초기화
                const lastRowPerZone = {}; // 각 구역마다 마지막 생성된 row를 추적
                const seatRowMapPerZone = {}; // zone별로 rowDiv 저장

                globalSeatData.forEach(seat => {
                    const zone = seat.seatZone;
                    const row = seat.seatRow;
                    const col = seat.seatCol;

                    // 구역 초기화
                    if (!uniqueZones.has(zone)) {
                        uniqueZones.add(zone);
                        select.append(`<option value="${'${zone}'}">구역 ${'${zone}'}</option>`);
                        seatMap.append(`<div class="seat-zone" id="zone-${'${zone}'}" style="display:none;"></div>`);
                        lastRowPerZone[zone] = null;
                        seatRowMapPerZone[zone] = {};  // 초기화
                    }

                    const zoneDiv = $(`#zone-${'${zone}'}`);

                    // 좌석 행이 처음 등장했을 경우 seat-row div 생성
                    if (!seatRowMapPerZone[zone][row]) {
                        const rowDiv = $(`<div class="seat-row" id="zone-${'${zone}'}-row-${'${row}'}"></div>`);
                        zoneDiv.append(rowDiv);
                        seatRowMapPerZone[zone][row] = rowDiv;
                    }

                    // 좌석 엘리먼트 생성
                    const seatEl = $('<span>')
                        .addClass('seat')
                        .addClass('available')
                        .data('seat-id', `${'${row}'}-${'${col}'}`)
                        .text(`${'${row}'}-${'${col}'}`) // 필요 시 제거
                        .on('click', function () {
                            if (!$(this).hasClass('available')) return;
                            $(this).toggleClass('selected');
                        });

                    seatRowMapPerZone[zone][row].append(seatEl);
                });

                // 첫 구역만 보이기
                const firstZone = [...uniqueZones][0];
                showZone(firstZone);
            },
            error: function (xhr, status, error) {
                console.error('경기 정보 로딩 실패:', status, error);
                alert('경기 정보를 불러오는 데 실패했습니다.');
            }
        });

        // 구역 선택 변경 시 좌석 다시 로딩
        $('#sectionSelect').on('change', function () {
            const sectionId = $(this).val();
            showZone(sectionId);
        });

        // 인원 선택 슬라이더
        $('#personRange').on('input', function () {
            console.log($('#personRange').val());
            $('#personCount').text($(this).val() + '인');
        });

        // 예매하기 클릭 시
        $('#reserveButton').on('click', function () {
            const selectedSeats = $('.seat.selected').map((i, el) => $(el).data('seat-id')).get();
            const personCount = parseInt($('#personRange').val());

            if (selectedSeats.length !== personCount) {
                alert('선택한 좌석 수가 인원 수와 다릅니다.');
                return;
            }

            // 예매 요청
            $.post('/api/reserve', {
                matchId,
                seats: selectedSeats
            }, function (response) {
                alert('예매 완료!');
                // 리디렉션 또는 상태 갱신
            }).fail(function () {
                alert('예매 실패');
            });
        });
    });
    function showZone(sectionId) {
        $('.seat-zone').hide();               // 모두 숨기고
        $(`#zone-${'${sectionId}'}`).show();      // 선택한 구역만 표시
    }

    document.querySelector('.rangeInput').addEventListener('input',function(event){
        var gradient_value = 100 / event.target.attributes.max.value;
        event.target.style.background = 'linear-gradient(to right, #4a5cc6 0%, #4a5cc6 '
            +gradient_value * event.target.value +'%, rgb(236, 236, 236) '
            +gradient_value *  event.target.value + '%, rgb(236, 236, 236) 100%)';
    });

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