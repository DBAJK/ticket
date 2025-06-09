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
<link href="/resources/css/trainForm.css" rel="stylesheet" type="text/css">
<div class="popup-body">
<div class="popup-overlay">
    <div class="popup-container">
        <div class="popup-header">
            <h2 class="popup-title" id="popup-title"></h2>
            <button class="close-btn" onclick="closePopup()">&times;</button>
        </div>

        <div class="ticket-info">
            <div class="train-info">
                <select id="sectionSelect" class="section-select">
                </select>
            </div>

            <div class="ticket-reservation-section">
                <div id="seatMap" class="seat-map">
                    <div class="stadium-info">
                        <div class="selected-info" id="selectedInfo">선택좌석 (0명 좌석 선택/총 1명)</div>
                    </div>

                    <div class="seat-legend">
                        <div class="legend-item">
                            <div class="legend-seat available" style="background: #e3f2fd; border-color: #2196f3;"></div>
                            <span>선택가능</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-seat selected" style="background: #4caf50; border-color: #388e3c;"></div>
                            <span>선택됨</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-seat occupied" style="background: #ffcdd2; border-color: #f44336;"></div>
                            <span>예약됨</span>
                        </div>
                    </div>

                    <div id="seatGrid" class="seat-grid">
                        <!-- 좌석이 동적으로 삽입됩니다 -->
                    </div>
                </div>

                <div class="person-count">
                    <label>인원 선택</label>
                    <span id="personCount">1인</span>
                    <input type="range" id="personRange" class="rangeInput" min="1" max="8" value="1" />
                    <button id="reserveButton" class="reserveButton" disabled>예매하기</button>
                </div>
            </div>
        </div>
    </div>
</div>
</div>
<script>
    let selectedSeats = [];
    let maxPersons = 1;
    let globalSeatData = [];
    let currentZone = '';
    const params = new URLSearchParams(window.location.search);
    const ticketId = params.get('ticketId');
    const placeId = params.get('placeId');
    const startDate = params.get('startDate');

    // Ajax로 좌석 데이터 로드
    function loadSeatData() {
        // jQuery 없이 순수 JavaScript로 Ajax 요청
        $.ajax({
            url: '/api/trainSeat',
            method: 'GET',
            dataType: 'json',
            data: {'placeId' : placeId, 'ticketId' : ticketId},
            success: function (data) {
                if (data && data.length > 0) {
                    // 기차 정보 업데이트
                    document.querySelector('#popup-title').textContent = `좌석선택(${'${data[0].ticketName}'})`;

                    globalSeatData = data;
                    initializeSeats();
                }
            },
            error: function (xhr, status, error) {
                console.error('좌석 정보 로딩 실패:', error);
                alert('좌석 정보를 불러오는 데 실패했습니다.');
            }
        });
    }

    function initializeSeats() {
        const seatGrid = document.getElementById('seatGrid');
        const sectionSelect = document.getElementById('sectionSelect');

        // 섹션 선택 옵션 초기화
        sectionSelect.innerHTML = '';
        seatGrid.innerHTML = '';

        const uniqueZones = new Set();
        const seatRowMapPerZone = {};

        // 구역별로 데이터 분류
        globalSeatData.forEach(seat => {
            const zone = seat.seatZone;
            const row = seat.seatRow;
            if (!uniqueZones.has(zone)) {
                uniqueZones.add(zone);
                const isSelected = uniqueZones.size === 1 ? 'selected' : '';
                sectionSelect.innerHTML += `<option value="${'${zone}'}" ${'${isSelected}'}>${'${zone}'} 호차</option>`;
                seatRowMapPerZone[zone] = {};
            }


            if (!seatRowMapPerZone[zone][row]) {
                seatRowMapPerZone[zone][row] = [];
            }

            seatRowMapPerZone[zone][row].push(seat);
        });

        // 첫 번째 구역을 기본으로 설정
        if (uniqueZones.size > 0) {
            currentZone = [...uniqueZones][0];
            sectionSelect.value = currentZone;
            showZone(currentZone, seatRowMapPerZone);
        }
    }

    function showZone(zone, seatRowMapPerZone = null) {
        const seatGrid = document.getElementById('seatGrid');
        seatGrid.innerHTML = '';
        currentZone = zone;

        if (!seatRowMapPerZone) {
            // 구역 변경 시 다시 데이터 분류
            seatRowMapPerZone = {};
            globalSeatData.forEach(seat => {
                const seatZone = seat.seatZone;
                const row = seat.seatRow;

                if (!seatRowMapPerZone[seatZone]) {
                    seatRowMapPerZone[seatZone] = {};
                }

                if (!seatRowMapPerZone[seatZone][row]) {
                    seatRowMapPerZone[seatZone][row] = [];
                }

                seatRowMapPerZone[seatZone][row].push(seat);
            });
        }

        const zoneData = seatRowMapPerZone[zone];
        if (!zoneData) return;

        // 행별로 정렬해서 렌더링
        const sortedRows = Object.keys(zoneData).sort((a, b) => parseInt(a) - parseInt(b));

        sortedRows.forEach(row => {
            const seatRow = document.createElement('div');
            seatRow.className = 'seat-row';

            const rowLabel = document.createElement('div');
            rowLabel.className = 'row-label';
            rowLabel.textContent = row;
            seatRow.appendChild(rowLabel);

            const leftGroup = document.createElement('div');
            leftGroup.className = 'seat-group';

            const rightGroup = document.createElement('div');
            rightGroup.className = 'seat-group';

            // 좌석을 열 순서대로 정렬
            const sortedSeats = zoneData[row].sort((a, b) => parseInt(a.seatCol) - parseInt(b.seatCol));

            sortedSeats.forEach((seatData, index) => {
                const seat = document.createElement('div');
                seat.className = 'seat';
                seat.textContent = `${'${row}'}${'${seatData.seatCol}'}`;
                seat.dataset.seatId = `${'${zone}'}-${'${row}'}-${'${seatData.seatCol}'}`;
                seat.dataset.seatPrice = seatData.seatPrice;

                // 좌석 상태 설정
                if (seatData.seatStatus === 'booked') {
                    seat.classList.add('occupied');
                } else {
                    seat.classList.add('available');
                    seat.addEventListener('click', () => toggleSeat(seat.dataset.seatId, seat));
                }

                // 창가 표시 (양 끝 좌석)
                if (index === 0) {
                    seat.classList.add('window-side');
                } else if (index === sortedSeats.length - 1) {
                    seat.classList.add('window-side', 'right');
                }

                // 좌석 배치 (2-2 구조)
                if (index < Math.ceil(sortedSeats.length / 2)) {
                    leftGroup.appendChild(seat);
                } else {
                    rightGroup.appendChild(seat);
                }
            });

            // 통로 추가
            const aisle = document.createElement('div');
            aisle.className = 'aisle';

            seatRow.appendChild(leftGroup);
            seatRow.appendChild(aisle);
            seatRow.appendChild(rightGroup);
            seatGrid.appendChild(seatRow);
        });
    }

    function toggleSeat(seatId, seatElement) {
        if (seatElement.classList.contains('selected')) {
            // 선택 해제
            selectedSeats = selectedSeats.filter(id => id !== seatId);
            seatElement.classList.remove('selected');
            seatElement.classList.add('available');
        } else {
            // 선택
            if (selectedSeats.length < maxPersons) {
                selectedSeats.push(seatId); // id만 저장
                seatElement.classList.remove('available');
                seatElement.classList.add('selected');
            } else {
                alert(`최대 ${'${maxPersons}'}명까지 선택 가능합니다.`);
            }
        }

        updateSelectedInfo();
        updateReserveButton();
    }

    function updateSelectedInfo() {
        const selectedInfo = document.getElementById('selectedInfo');
        selectedInfo.textContent = `선택좌석 (${'${selectedSeats.length}'}명 좌석 선택/총 ${'${maxPersons}'}명)`;
    }

    function updateReserveButton() {
        const reserveButton = document.getElementById('reserveButton');
        reserveButton.disabled = selectedSeats.length !== maxPersons;
    }

    function updatePersonCount() {
        const personRange = document.getElementById('personRange');
        const personCount = document.getElementById('personCount');

        maxPersons = parseInt(personRange.value);
        personCount.textContent = `${'${maxPersons}'}인`;

        // 선택된 좌석이 인원수를 초과하면 조정
        if (selectedSeats.length > maxPersons) {
            const excessSeats = selectedSeats.splice(maxPersons);
            excessSeats.forEach(seatId => {
                const seatElement = document.querySelector(`[data-seat-id="${'${seatId}'}"]`);
                if (seatElement) {
                    seatElement.classList.remove('selected');
                    seatElement.classList.add('available');
                }
            });
        }

        updateSelectedInfo();
        updateReserveButton();
    }

    function makeReservation() {
        const seatIds = selectedSeats.map(seat => seat.id);

        const totalPrice = selectedSeats.reduce((sum, seatId) => {
            // seatId로 해당 좌석 element 찾기 (data-seat-id 속성 사용)
            const seatElement = document.querySelector(`[data-seat-id="${'${seatId}'}"]`);
            // 좌석 가격 추출 (없으면 0)
            const seatPrice = seatElement ? parseInt(seatElement.dataset.seatPrice, 10) : 0;
            return sum + seatPrice;
        }, 0);

        const requestData = {
            placeId: placeId,
            seats: selectedSeats,
            ticketId: ticketId,
            price: totalPrice,
            usedDt: startDate
        };

        console.log(requestData);
        $.ajax({
            url: '/api/reserveInsert',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(requestData),
            success: function (response) {
                if (confirm(`좌석 ${'${selectedSeats}'}이 예매되었습니다!\n총 금액: ${'${totalPrice}'}원\n창을 닫으시겠습니까?`)) {
                    window.close(); // 팝업 닫기
                }
            },
            error: function (xhr) {
                if (xhr.status == 400 && xhr.responseText == 9083) {
                    alert('포인트가 부족합니다.');
                } else if (xhr.status == 401) {
                    alert('로그인 후 예매해주세요.');
                    if (confirm("로그인 화면으로 이동하시겠습니까?")) {
                        window.opener.location.href = "/loginForm";
                        window.close();
                    } else {
                        window.opener.location.reload();
                        window.close();
                    }
                } else {
                    alert('예매 실패');
                }
            }
        });
    }

    // 이벤트 리스너 설정
    document.getElementById('personRange').addEventListener('input', updatePersonCount);
    document.getElementById('reserveButton').addEventListener('click', makeReservation);
    document.getElementById('sectionSelect').addEventListener('change', () => {
        selectedSeats = [];
        showZone(e.target.value);
        updateSelectedInfo();
        updateReserveButton();
    });

    // 초기화
    loadSeatData();
    updateSelectedInfo();
    updateReserveButton();

    // ESC 키로 팝업 닫기
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            window.close();
        }
    });

</script>
