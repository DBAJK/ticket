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

<style>
    .container {
        font-family: 'Pretendard', 'Malgun Gothic', Arial, sans-serif;
        background: #f7f9fa;
        margin: 0;
        padding: 0;
        width: 100%;
    }
    .main-container {
        max-width: 1500px;
        margin: 32px auto;
        background: #fff;
        border-radius: 16px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        padding: 32px 32px 24px 32px;
    }
    .search-bar {
        display: flex;
        align-items: center;
        gap: 14px;
        margin-bottom: 18px;
    }
    .search-bar input,
    .search-bar select {
        font-size: 16px;
        padding: 6px 10px;
        border-radius: 6px;
        border: 1px solid #d0d4d7;
    }
    .search-bar label {
        font-size: 16px;
        margin-right: 6px;
    }
    .option-bar {
        display: flex;
        align-items: center;
        gap: 18px;
        margin-bottom: 18px;
        font-size: 15px;
    }
    .option-bar label {
        margin-right: 2px;
    }
    .train-list-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 12px;
    }
    .train-list-table th, .train-list-table td {
        border-bottom: 1px solid #e5e7ea;
        padding: 16px 8px;
        text-align: center;
        font-size: 16px;
    }
    .train-list-table th {
        background: #f2f4f7;
        font-weight: bold;
        color: #222;
    }
    .train-list-table td {
        background: #fff;
        color: #222;
        vertical-align: middle;
    }
    .train-logo {
        width: 52px;
        height: 22px;
        object-fit: contain;
        vertical-align: middle;
        margin-right: 6px;
    }
    .soldout {
        color: #bbb;
        background: #f8f8f8;
    }
    .info-badge {
        background: #f2f4f7;
        color: #3d4db7;
        border-radius: 6px;
        padding: 2px 8px;
        font-size: 13px;
        margin-left: 6px;
        display: inline-block;
    }
</style>
<div class="container">
    <div class="main-container">
        <form class="search-bar">
            <label for="departure">출발지:</label>
            <select id="departure">
                <option value="seoul">서울</option>
                <option value="kt">수원</option>
                <option value="hanwha">대전</option>
                <option value="kia">광주</option>
                <option value="samsung">대구</option>
                <option value="lotte">부산</option>
                <option value="nc">창원</option>
            </select>

            <label for="destination">도착지:</label>
            <select id="destination">
            </select>
            <input type="date" id="todayDate" style="width:130px;">
            <select>
                <option value="1">총 1명</option>
                <option value="2">총 2명</option>
                <option value="3">총 3명</option>
                <option value="4">총 4명</option>
            </select>
        </form>
        <table class="train-list-table">
            <thead>
                <tr>
                    <th style="width:120px">열차</th>
                    <th>구간/시간</th>
                    <th>비고</th>
                    <th>일반실</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><img class="train-logo" src="https://www.letskorail.com/images/ekr/ekr_train_ktx.png" alt="KTX">021</td>
                    <td>서울 → 부산<br><span style="font-size:13px;">09:58 ~ 12:46</span><br><span style="font-size:12px;color:#888;">소요시간: 2시간 48분</span></td>
                    <td></td>
                    <td class="soldout">매진</td>
                </tr>
                <tr>
                    <td><img class="train-logo" src="https://www.letskorail.com/images/ekr/ekr_train_ktx.png" alt="KTX">123</td>
                    <td>서울 → 부산<br><span style="font-size:13px;">10:12 ~ 13:35</span><br><span style="font-size:12px;color:#888;">소요시간: 3시간 23분</span></td>
                    <td><span class="info-badge">수원정차</span></td>
                    <td class="soldout">매진</td>
                </tr>
                <tr>
                    <td><img class="train-logo" src="https://www.letskorail.com/images/ekr/ekr_train_ktx.png" alt="KTX">163</td>
                    <td>서울 → 부산<br><span style="font-size:13px;">10:18 ~ 13:32</span><br><span style="font-size:12px;color:#888;">소요시간: 3시간 14분</span></td>
                    <td><span class="info-badge">서대구,구포정차</span></td>
                    <td class="soldout">매진</td>
                </tr>
                <tr>
                    <td><img class="train-logo" src="https://www.letskorail.com/images/ekr/ekr_train_itx.png" alt="ITX">1005</td>
                    <td>서울 → 부산<br><span style="font-size:13px;">10:23 ~ 15:21</span><br><span style="font-size:12px;color:#888;">소요시간: 4시간 58분</span></td>
                    <td></td>
                    <td class="soldout">매진</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<script>
    $(document).ready(function () {
        init();
    });

    function init(){
        const today = new Date();
        const yyyy = today.getFullYear();
        const mm = String(today.getMonth() + 1).padStart(2, '0');
        const dd = String(today.getDate()).padStart(2, '0');
        const formatted = `${'${yyyy}'}-${'${mm}'}-${'${dd}'}`;
        document.getElementById('todayDate').value = formatted;
    }

    const destinations = [
        { place: '수원', team: 'kt' },
        { place: '대전', team: '한화' },
        { place: '광주', team: '기아' },
        { place: '대구', team: '삼성' },
        { place: '부산', team: '롯데' },
        { place: '창원', team: 'NC' }
    ];

    const departureSelect = document.getElementById('departure');
    const destinationSelect = document.getElementById('destination');
    const teamInfoDiv = document.getElementById('teamInfo');

    function populateDestinations() {
        destinationSelect.innerHTML = '';
        destinations.forEach(dest => {
            const option = document.createElement('option');
            option.value = dest.place;
            option.textContent = dest.place;
            destinationSelect.appendChild(option);
        });
        updateTeamInfo();
    }

    function updateTeamInfo() {
        const selectedPlace = destinationSelect.value;
        const team = destinations.find(d => d.place === selectedPlace)?.team || '';
        teamInfoDiv.textContent = `팀(연고지): ${team}`;
    }

    departureSelect.addEventListener('change', () => {
        // 현재 출발지는 서울만 있으므로 도착지 목록 갱신
        if (departureSelect.value === '서울') {
            populateDestinations();
        } else {
            destinationSelect.innerHTML = '';
            const option = document.createElement('option');
            option.value = '서울';
            option.textContent = '서울';
            destinationSelect.appendChild(option);
            teamInfoDiv.textContent = '';
        }
    });

    destinationSelect.addEventListener('change', updateTeamInfo);

    // 초기화
    populateDestinations();
</script>
