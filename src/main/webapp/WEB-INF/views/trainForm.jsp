<%--
  Created by IntelliJ IDEA.
  User: jgkim
  Date: 2025-05-17
  Time: 오후 9:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="/resources/css/trainForm.css" rel="stylesheet" type="text/css">
<div class="container">
    <div class="main-container">
        <form class="search-bar">
            <label for="departure">출발지:</label>
            <select id="departure">
                <option value="seoul">서울</option>
                <option value="daejeon">대전</option>
                <option value="gwangju">광주</option>
                <option value="daegu">대구</option>
                <option value="busan">부산</option>
                <option value="masan">창원</option>
            </select>

            <label for="destination">도착지:</label>
            <select id="destination">
            </select>
            <input type="date" id="todayDate" style="width:130px;">
            <button type="button" id="searchBtn" style="padding: 8px 16px; background: #1976d2; color: white; border: none; border-radius: 4px; cursor: pointer;">조회</button>
        </form>
        <table class="train-list-table">
            <thead>
            <tr>
                <th style="width:120px">열차</th>
                <th>구간/시간</th>
                <th>일반실</th>
            </tr>
            </thead>
            <tbody id="trainTableBody">
            </tbody>
        </table>
    </div>
</div>
<script>
    let allTrains = []; // 전체 열차 데이터
    let currentPage = 1; // 현재 페이지
    const itemsPerPage = 10; // 페이지당 항목 수

    $(document).ready(function () {
        init();
        loadTrains(); // 초기 데이터 로드
    });

    function init(){
        const today = new Date();
        const yyyy = today.getFullYear();
        const mm = String(today.getMonth() + 1).padStart(2, '0');
        const dd = String(today.getDate()).padStart(2, '0');
        const formatted = `${'${yyyy}'}-${'${mm}'}-${'${dd}'}`;
        document.getElementById('todayDate').value = formatted;
        populateDestinations();
        updateDestinations();
    }

    const seoulDestinations = [
        { place: '대전', team: 'daejeon' },
        { place: '광주', team: 'gwangju' },
        { place: '대구', team: 'daegu' },
        { place: '부산', team: 'busan' },
        { place: '창원', team: 'masan' }
    ];
    function updateDestinations() {
        destinationSelect.innerHTML = ''; // 기존 옵션 초기화

        if (departureSelect.value === 'seoul') {
            seoulDestinations.forEach(dest => {
                const option = document.createElement('option');
                option.value = dest.team;
                option.textContent = dest.place;
                destinationSelect.appendChild(option);
            });
        } else {
            const seoulOption = document.createElement('option');
            seoulOption.value = 'seoul';
            seoulOption.textContent = '서울';
            destinationSelect.appendChild(seoulOption);
        }
    }

    const korCityMap = {
        seoul: '서울',
        busan: '부산',
        daejeon: '대전',
        daegu: '대구',
        masan: '마산',
        gwangju: '광주송정'
    };

    const departureSelect = document.getElementById('departure');
    const destinationSelect = document.getElementById('destination');

    function populateDestinations() {
        destinationSelect.innerHTML = '';
        const selectedDeparture = departureSelect.value;

        seoulDestinations.forEach(dest => {
            if (dest.team !== selectedDeparture) {
                const option = document.createElement('option');
                option.value = dest.team;
                option.textContent = dest.place;
                destinationSelect.appendChild(option);
            }
        });
    }

    function loadTrains() {
        const departure = document.getElementById('departure').value;
        const destination = document.getElementById('destination').value;
        const date = document.getElementById('todayDate').value;

        $.ajax({
            url: '/api/trains',
            method: 'GET',
            data: {
                awayTeam: departure,
                homeTeam: destination,
                startDate: date
            },
            success: function(trains) {
                renderTrains(trains);
            },
            error: function(xhr, status, error) {
                console.error('Error loading trains:', error);
                $('#trainTableBody').html('<tr><td colspan="4">조회된 열차가 없습니다.</td></tr>');
            }
        });
    }

    function renderTrains(trains) {
        allTrains = trains; // 전체 데이터 저장
        currentPage = 1; // 페이지 초기화
        renderCurrentPage();
        renderPagination();

    }

    function renderCurrentPage() {
        const tbody = document.getElementById('trainTableBody');
        tbody.innerHTML = '';

        if (allTrains.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4">조회된 열차가 없습니다.</td></tr>';
            return;
        }
        // 현재 페이지에 표시할 데이터 계산
        const startIndex = (currentPage - 1) * itemsPerPage;
        const endIndex = startIndex + itemsPerPage;
        const currentTrains = allTrains.slice(startIndex, endIndex);

        currentTrains.forEach(function(train) {
            const row = document.createElement('tr');
            // 한글 도시명으로 변환
            const homeKor = korCityMap[train.homeTeamName] || train.homeTeamName;
            const awayKor = korCityMap[train.awayTeamName] || train.awayTeamName;
            const formattedRoute = `${'${awayKor} → ${homeKor}'}`;

            row.innerHTML = `
                <td>
                    <div class="train-info">
                        <div class="train-name">${'${train.ticketName}'}</div>
                    </div>
                </td>
                <td>
                    <div>${'${formattedRoute}'}</div>
                    <div class="time-info">(${'${train.description}'})</div>
                </td>
                <td>
                    <button class="seat-button"
                            onclick="selectSeat(${'${train.ticketId}'},${'${train.placeId}'})">
                        예매하기
                    </button>
                </td>
            `;
            tbody.appendChild(row);
        });
    }
    function renderPagination() {
        const totalPages = Math.ceil(allTrains.length / itemsPerPage);
        const paginationContainer = document.getElementById('paginationContainer');

        if (!paginationContainer) {
            // 페이지네이션 컨테이너가 없으면 생성
            const tableContainer = document.querySelector('.train-list-table').parentNode;
            const paginationDiv = document.createElement('div');
            paginationDiv.id = 'paginationContainer';
            paginationDiv.className = 'pagination-container';
            tableContainer.appendChild(paginationDiv);
        }

        const pagination = document.getElementById('paginationContainer');
        pagination.innerHTML = '';

        if (totalPages <= 1) {
            return; // 페이지가 1개 이하면 페이지네이션 숨김
        }

        // 이전 버튼
        const prevBtn = document.createElement('button');
        prevBtn.className = 'pagination-btn';
        prevBtn.textContent = '이전';
        prevBtn.disabled = currentPage === 1;
        prevBtn.onclick = () => {
            if (currentPage > 1) {
                currentPage--;
                renderCurrentPage();
                renderPagination();
            }
        };
        pagination.appendChild(prevBtn);

        // 페이지 번호 버튼들
        const maxVisiblePages = 5; // 표시할 최대 페이지 수
        let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
        let endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);

        // 끝 페이지 기준으로 시작 페이지 재조정
        if (endPage - startPage + 1 < maxVisiblePages) {
            startPage = Math.max(1, endPage - maxVisiblePages + 1);
        }

        // 첫 페이지 (1이 표시 범위에 없을 때)
        if (startPage > 1) {
            const firstBtn = document.createElement('button');
            firstBtn.className = 'pagination-btn';
            firstBtn.textContent = '1';
            firstBtn.onclick = () => goToPage(1);
            pagination.appendChild(firstBtn);

            if (startPage > 2) {
                const ellipsis = document.createElement('span');
                ellipsis.className = 'pagination-ellipsis';
                ellipsis.textContent = '...';
                pagination.appendChild(ellipsis);
            }
        }

        // 페이지 번호들
        for (let i = startPage; i <= endPage; i++) {
            const pageBtn = document.createElement('button');
            pageBtn.className = 'pagination-btn';
            if (i === currentPage) {
                pageBtn.classList.add('active');
            }
            pageBtn.textContent = i;
            pageBtn.onclick = () => goToPage(i);
            pagination.appendChild(pageBtn);
        }

        // 마지막 페이지 (마지막이 표시 범위에 없을 때)
        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                const ellipsis = document.createElement('span');
                ellipsis.className = 'pagination-ellipsis';
                ellipsis.textContent = '...';
                pagination.appendChild(ellipsis);
            }

            const lastBtn = document.createElement('button');
            lastBtn.className = 'pagination-btn';
            lastBtn.textContent = totalPages;
            lastBtn.onclick = () => goToPage(totalPages);
            pagination.appendChild(lastBtn);
        }

        // 다음 버튼
        const nextBtn = document.createElement('button');
        nextBtn.className = 'pagination-btn';
        nextBtn.textContent = '다음';
        nextBtn.disabled = currentPage === totalPages;
        nextBtn.onclick = () => {
            if (currentPage < totalPages) {
                currentPage++;
                renderCurrentPage();
                renderPagination();
            }
        };
        pagination.appendChild(nextBtn);

        // 페이지 정보 표시
        const pageInfo = document.createElement('div');
        pageInfo.className = 'page-info';
        pageInfo.textContent = `${'${currentPage}'} / ${'${totalPages}'} 페이지 (총 ${'${allTrains.length}'}개)`;
        pagination.appendChild(pageInfo);
    }

    function goToPage(page) {
        currentPage = page;
        renderCurrentPage();
        renderPagination();
    }

    function selectSeat(ticketId, placeId) {
        const startDate = document.getElementById('todayDate').value;
        window.open('popup/trainPopup?ticketId=' + ticketId + '&placeId=' + placeId + '&startDate=' + startDate, "trainPopup", "width=1350,height=1200");
    }

    departureSelect.addEventListener('change', () => {
        populateDestinations();
        updateDestinations();
    });

    document.getElementById('searchBtn').addEventListener('click', loadTrains);
</script>