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
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Noto Sans KR', Arial, sans-serif;
        background-color: #f5f5f5;
    }

    .ticket-info {
        max-width: 1200px;
        margin: 20px auto;
        background: white;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        overflow: hidden;
    }

    #ticketId, #placeId {
        display: none;
    }

    .titleArea {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 30px;
        text-align: center;
    }

    .match-title {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        margin-bottom: 15px;
    }

    .matchTitle {
        font-size: 28px;
        font-weight: bold;
    }

    .stadiumName {
        font-size: 18px;
        opacity: 0.9;
    }

    .match-date {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 15px;
    }

    #homeTeamLogo {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: white;
        padding: 5px;
    }

    .matchDate {
        font-size: 16px;
        font-weight: 500;
    }

    .section-select {
        width: 100%;
        padding: 15px;
        font-size: 16px;
        border: none;
        background: #f8f9fa;
        margin: 20px 0;
        text-align: center;
        cursor: pointer;
    }

    .ticket-reservation-section {
        display: flex;
        padding: 30px;
        gap: 40px;
    }

    .seat-map {
        flex: 2;
        background: #f8f9fa;
        border-radius: 12px;
        padding: 20px;
        position: relative;
        min-height: 500px;
    }

    .stadium-info {
        text-align: center;
        margin-bottom: 20px;
        padding: 15px;
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .stadium-name {
        font-size: 18px;
        font-weight: bold;
        color: #333;
        margin-bottom: 5px;
    }

    .selected-info {
        font-size: 14px;
        color: #666;
    }

    .seat-grid {
        display: grid;
        grid-template-columns: repeat(13, 1fr);
        gap: 8px;
        max-width: 800px;
        margin: 0 auto;
    }

    .seat {
        width: 40px;
        height: 35px;
        border: 2px solid #ddd;
        border-radius: 6px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 11px;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s ease;
        position: relative;
    }

    .seat.available {
        background: #e3f2fd;
        border-color: #2196f3;
        color: #1976d2;
    }

    .seat.available:hover {
        background: #bbdefb;
        transform: scale(1.1);
    }

    .seat.selected {
        background: #4caf50;
        border-color: #388e3c;
        color: white;
        transform: scale(1.1);
    }

    .seat.occupied {
        background: #ffcdd2;
        border-color: #f44336;
        color: #c62828;
        cursor: not-allowed;
    }

    .seat.disabled {
        background: #f5f5f5;
        border-color: #e0e0e0;
        color: #bdbdbd;
        cursor: not-allowed;
    }

    .row-label {
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        color: #666;
        font-size: 12px;
    }

    .section-divider {
        grid-column: span 13;
        height: 20px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        color: #888;
        font-size: 14px;
        border-top: 2px solid #ddd;
        margin: 10px 0;
    }

    .person-count {
        flex: 1;
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 30px 20px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 15px rgba(0,0,0,0.1);
        height: fit-content;
    }

    .person-count label {
        font-size: 24px;
        font-weight: bold;
        color: #333;
        margin-bottom: 20px;
    }

    #personCount {
        font-size: 20px;
        color: #666;
        margin-bottom: 20px;
    }

    .rangeInput {
        width: 100%;
        height: 8px;
        border-radius: 5px;
        background: #ddd;
        outline: none;
        margin-bottom: 30px;
        -webkit-appearance: none;
    }

    .rangeInput::-webkit-slider-thumb {
        -webkit-appearance: none;
        appearance: none;
        width: 25px;
        height: 25px;
        border-radius: 50%;
        background: #667eea;
        cursor: pointer;
    }

    .rangeInput::-moz-range-thumb {
        width: 25px;
        height: 25px;
        border-radius: 50%;
        background: #667eea;
        cursor: pointer;
        border: none;
    }

    .reserveButton {
        width: 100%;
        padding: 15px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 18px;
        font-weight: bold;
        cursor: pointer;
        transition: transform 0.2s ease;
    }

    .reserveButton:hover {
        transform: translateY(-2px);
    }

    .reserveButton:disabled {
        background: #ccc;
        cursor: not-allowed;
        transform: none;
    }

    .seat-legend {
        display: flex;
        justify-content: center;
        gap: 20px;
        margin: 20px 0;
        font-size: 12px;
    }

    .legend-item {
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .legend-seat {
        width: 20px;
        height: 18px;
        border-radius: 3px;
        border: 1px solid;
    }

    .loading {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 300px;
        font-size: 18px;
        color: #666;
    }

    @media (max-width: 768px) {
        .ticket-reservation-section {
            flex-direction: column;
            padding: 20px;
        }

        .seat-grid {
            grid-template-columns: repeat(10, 1fr);
            gap: 4px;
        }

        .seat {
            width: 30px;
            height: 28px;
            font-size: 10px;
        }
    }
</style>
<div class="ticket-info">
    <input id="ticketId" disabled>
    <input id="placeId" disabled>

    <select id="sectionSelect" class="section-select">
        <!-- 구역 나누기 -->
    </select>

    <div class="ticket-reservation-section">
        <div id="seatMap" class="seat-map">
            <div class="stadium-info">
                <div class="stadium-name">서울 ⟷ 창원</div>
                <div class="selected-info">선택좌석 (0명 좌석 선택/총 1명)</div>
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
            <button id="reserveButton" class="reserveButton">예매하기</button>
        </div>
    </div>
</div>

<script>
    class SeatReservationSystem {
        constructor() {
            this.selectedSeats = [];
            this.maxPersons = 1;
            this.seatData = null;
            this.currentSection = '5';

            this.initializeEventListeners();
            this.loadSeatData();
        }

        initializeEventListeners() {
            // 인원 수 변경
            const personRange = document.getElementById('personRange');
            const personCount = document.getElementById('personCount');

            personRange.addEventListener('input', (e) => {
                this.maxPersons = parseInt(e.target.value);
                personCount.textContent = `${'${this.maxPersons}'}인`;
                this.updateSelectedSeatsDisplay();
                this.validateSelection();
            });

            // 구역 변경
            const sectionSelect = document.getElementById('sectionSelect');
            sectionSelect.addEventListener('change', (e) => {
                this.currentSection = e.target.value;
                if (this.currentSection) {
                    this.selectedSeats = [];
                    this.loadSeatData();
                }
            });

            // 예매 버튼
            const reserveButton = document.getElementById('reserveButton');
            reserveButton.addEventListener('click', () => {
                this.makeReservation();
            });
        }

        async loadSeatData() {
            const seatGrid = document.getElementById('seatGrid');
            seatGrid.innerHTML = '<div class="loading">좌석 정보를 불러오는 중...</div>';

            try {
                // 실제 환경에서는 서버 API 호출
                // const response = await fetch(`/api/seats?section=${this.currentSection}`);
                // const data = await response.json();

                // 데모용 데이터 시뮬레이션
                await this.simulateApiCall();
                this.seatData = this.generateDemoSeatData();

                this.renderSeatMap();
            } catch (error) {
                console.error('좌석 데이터 로딩 실패:', error);
                seatGrid.innerHTML = '<div class="loading" style="color: #f44336;">좌석 정보를 불러올 수 없습니다.</div>';
            }
        }

        async simulateApiCall() {
            // API 호출 시뮬레이션
            return new Promise(resolve => setTimeout(resolve, 1000));
        }

        generateDemoSeatData() {
            // 실제로는 서버에서 받아올 데이터
            const seats = [];
            const rows = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13'];
            const columns = ['A', 'B', 'C', 'D'];

            rows.forEach(row => {
                columns.forEach(col => {
                    const seatNumber = row + col;
                    const isOccupied = Math.random() < 0.3; // 30% 확률로 예약됨
                    const isDisabled = Math.random() < 0.1; // 10% 확률로 운행안함

                    seats.push({
                        id: seatNumber,
                        row: row,
                        column: col,
                        status: isDisabled ? 'disabled' : (isOccupied ? 'occupied' : 'available'),
                        price: 25000
                    });
                });
            });

            return seats;
        }

        renderSeatMap() {
            const seatGrid = document.getElementById('seatGrid');
            seatGrid.innerHTML = '';

            // 좌석 배치는 실제 KTX 좌석 배치를 모방
            const rows = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13'];

            rows.forEach((row, index) => {
                // 통로 구분을 위한 빈 공간
                if (index === 0) {
                    // 첫 번째 행 헤더
                    ['', '2A', '3A', '4A', '5A', '6A', '7A', '8A', '9A', '10A', '11A', '12A', '13A'].forEach(header => {
                        const headerElement = document.createElement('div');
                        headerElement.className = 'row-label';
                        headerElement.textContent = header;
                        seatGrid.appendChild(headerElement);
                    });
                }

                // 행 번호
                const rowLabel = document.createElement('div');
                rowLabel.className = 'row-label';
                rowLabel.textContent = row + 'C';
                seatGrid.appendChild(rowLabel);

                // 좌석들
                ['A', 'B', 'C', 'D'].forEach(col => {
                    ['2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13'].forEach(seatRow => {
                        const seatId = seatRow + col;
                        const seatData = this.seatData.find(s => s.id === seatId);

                        if (seatData) {
                            const seatElement = this.createSeatElement(seatData);
                            seatGrid.appendChild(seatElement);
                        } else {
                            // 빈 좌석 (통로 등)
                            const emptySeat = document.createElement('div');
                            emptySeat.className = 'seat disabled';
                            seatGrid.appendChild(emptySeat);
                        }
                    });
                });

                // 행별 구분선 (특정 행에만)
                if ([4, 8].includes(index)) {
                    const divider = document.createElement('div');
                    divider.className = 'section-divider';
                    divider.textContent = '---';
                    seatGrid.appendChild(divider);
                }
            });
        }

        createSeatElement(seatData) {
            const seat = document.createElement('div');
            seat.className = `seat ${seatData.status}`;
            seat.textContent = seatData.id;
            seat.dataset.seatId = seatData.id;
            seat.dataset.price = seatData.price;

            if (seatData.status === 'available') {
                seat.addEventListener('click', () => {
                    this.toggleSeatSelection(seatData.id, seat);
                });
            }

            return seat;
        }

        toggleSeatSelection(seatId, seatElement) {
            const isSelected = this.selectedSeats.includes(seatId);

            if (isSelected) {
                // 선택 해제
                this.selectedSeats = this.selectedSeats.filter(id => id !== seatId);
                seatElement.classList.remove('selected');
                seatElement.classList.add('available');
            } else {
                // 선택
                if (this.selectedSeats.length < this.maxPersons) {
                    this.selectedSeats.push(seatId);
                    seatElement.classList.remove('available');
                    seatElement.classList.add('selected');
                } else {
                    alert(`최대 ${'${this.maxPersons}'}명까지 선택 가능합니다.`);
                    return;
                }
            }

            this.updateSelectedSeatsDisplay();
            this.validateSelection();
        }

        updateSelectedSeatsDisplay() {
            const selectedInfo = document.querySelector('.selected-info');
            selectedInfo.textContent = `선택좌석 (${'${this.selectedSeats.length}'}명 좌석 선택/총 ${'${this.maxPersons}'}명)`;
        }

        validateSelection() {
            const reserveButton = document.getElementById('reserveButton');
            const isValid = this.selectedSeats.length === this.maxPersons;

            reserveButton.disabled = !isValid;
            reserveButton.textContent = isValid ? '예매하기' : `${'${this.maxPersons - this.selectedSeats.length}'}명 더 선택해주세요`;
        }

        async makeReservation() {
            if (this.selectedSeats.length !== this.maxPersons) {
                alert('인원 수만큼 좌석을 선택해주세요.');
                return;
            }

            const reservationData = {
                section: this.currentSection,
                seats: this.selectedSeats,
                personCount: this.maxPersons,
                totalPrice: this.selectedSeats.length * 25000
            };

            try {
                // 실제 환경에서는 서버로 예매 요청
                // const response = await fetch('/api/reservation', {
                //     method: 'POST',
                //     headers: { 'Content-Type': 'application/json' },
                //     body: JSON.stringify(reservationData)
                // });

                // 데모용 성공 시뮬레이션
                await this.simulateApiCall();

                alert(`예매가 완료되었습니다!\n구역: ${this.currentSection}호차\n좌석: ${this.selectedSeats.join(', ')}\n총 금액: ${reservationData.totalPrice.toLocaleString()}원`);

                // 예매 완료 후 초기화
                this.selectedSeats = [];
                this.loadSeatData();

            } catch (error) {
                console.error('예매 실패:', error);
                alert('예매 중 오류가 발생했습니다. 다시 시도해주세요.');
            }
        }
    }

    // 시스템 초기화
    document.addEventListener('DOMContentLoaded', () => {
        new SeatReservationSystem();
    });

    // AJAX 호출 예시 함수들 (실제 사용시 참고)
    async function fetchSeatData(section) {
        try {
            const response = await fetch(`/api/seats`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    section: section,
                    trainType: 'ITX',
                    carNumber: '1031'
                })
            });

            if (!response.ok) {
                throw new Error('Network response was not ok');
            }

            return await response.json();
        } catch (error) {
            console.error('좌석 데이터 요청 실패:', error);
            throw error;
        }
    }

    async function makeReservationRequest(reservationData) {
        try {
            const response = await fetch('/api/reservation', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.getAttribute('content')
                },
                body: JSON.stringify(reservationData)
            });

            if (!response.ok) {
                throw new Error('예매 요청 실패');
            }

            return await response.json();
        } catch (error) {
            console.error('예매 요청 실패:', error);
            throw error;
        }
    }
</script>
