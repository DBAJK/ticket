<%--
  Created by IntelliJ IDEA.
  User: jgkim
  Date: 2025-05-17
  Time: 오후 9:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
    <title>예매 확인</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .container {
            width: 800px;
            margin: 20px auto;
            font-family: 'Noto Sans KR', sans-serif;
        }

        .container .titleSpan{
            font-size: 50px;
            color: #4a5cc6;
            font-weight: bold;
            margin-right: 20px; /* 버튼과 간격 */
            letter-spacing: 1px;

        }

        .search-box {
            border: 1px solid #ccc;
            padding: 16px;
            display: flex;
            flex-direction: column;
            font-family: 'Noto Sans KR', sans-serif;
        }

        .search-row {
            display: flex;
            align-items: flex-start;
            gap: 0;
        }

        .label-box {
            width: 100px;
            font-weight: bold;
            text-align: center;
            padding: 16px 0;
            border-right: 2px solid #fff;
            box-sizing: border-box;
        }

        .period-box {
            display: flex;
            flex-direction: column;
            gap: 8px;
            padding: 8px 0 8px 16px;
            flex: 1;
        }

        .period-btns {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .date-inputs {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .info-text {
            margin-left: 10px;
            font-size: 0.85rem;
            color: #666;
        }

        .button-box {
            display: flex;
            align-items: center;
            gap: 6px;
            flex: 2; /* 2배 비율로 넓게 */
        }

        .date-box {
            display: flex;
            align-items: center;
            gap: 6px;
            flex: 1; /* 기본 너비 */
        }

        .button-box button {
            padding: 5px 10px;
            border: 1px solid #999;
            background-color: #f0f0f0;
            border-radius: 3px;
            cursor: pointer;
        }

        .button-box button:hover {
            background-color: #ddd;
        }

        .date-input {
            padding: 5px 8px;
            border: 1px solid #ccc;
            border-radius: 3px;
            width: 140px;
        }

        .tilde {
            font-weight: bold;
        }

        .search-btn {
            padding: 6px 12px;
            background-color: #222;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }

        .search-btn:hover {
            background-color: #444;
        }

        .result-table {
            width: 100%;
            border-collapse: collapse;
        }

        .result-table th, .result-table td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: center;
        }

        .result-table th {
            background-color: #f0f0f0;
        }

        .check-link {
            color: blue;
            cursor: pointer;
            text-decoration: underline;
        }

        .check-link.used {
            color: red;
        }
    </style>
</head>
<body>
<div class="container">
    <span class="titleSpan">예매 확인</span>
    <div class="search-box">
        <div class="search-row">
            <div class="label-box">조회기간</div>
            <div class="period-box">
                <div class="period-btns">
                    <button type="button" onclick="setPeriod(14)">2주일</button>
                    <button type="button" onclick="setPeriod(30)">1개월</button>
                    <button type="button" onclick="setPeriod(90)">3개월</button>
                    <span class="info-text">3개월 이전의 내역은 자동 삭제됩니다.</span>
                </div>
                <div class="date-inputs">
                    <input type="date" id="startDate" class="date-input">
                    <span class="tilde">~</span>
                    <input type="date" id="endDate" class="date-input">
                    <button class="search-btn" onclick="searchReservations()">조회하기</button>
                </div>
            </div>
        </div>
    </div>

    <table class="result-table">
        <thead>
        <tr>
            <th>티켓 이름</th>
            <th>티켓 확인</th>
            <th>분류</th>
            <th>기타</th>
            <th>상태</th>
            <th>사용일</th>
        </tr>
        </thead>
        <tbody id="resultTable"></tbody>
    </table>
</div>

</body>
<script>
    $(document).ready(function () {
        setPeriod(1);
        searchReservations();
    });
    function setPeriod(days) {
        const end = new Date();
        const start = new Date();
        start.setDate(end.getDate() - days);

        const formatDate = (date) => {
            return date.toISOString().substring(0, 10);
        };

        $('#startDate').val(formatDate(start));
        $('#endDate').val(formatDate(end));
    }

    function searchReservations() {
        const startDate = $('#startDate').val();
        const endDate = $('#endDate').val();
        $.ajax({
            url: '/reservation/search',
            type: 'GET',
            data: { startDate, endDate },
            success: function (data) {
                const tbody = $('#resultTable');
                tbody.empty();

                if (data.length === 0) {
                    tbody.append('<tr><td colspan="6">조회 결과가 없습니다.</td></tr>');
                    return;
                }

                data.forEach(ticket => {
                    const row = '<tr>' +
                        '<td>' + ticket.ticketName + '</td>' +
                        '<td><a class="check-link" href="#">티켓 확인</a></td>' +
                        '<td>' + ticket.ticketType + '</td>' +
                        '<td>' + ticket.description + '</td>' +
                        '<td>' + ticket.status + '</td>' +
                        '<td>' + ticket.usedDt + '</td>' +
                        '</tr>';
                    tbody.append(row);
                });
            },
            error: function () {
                alert('예매 정보를 불러오는 데 실패했습니다.');
            }
        });
    }
</script>
</html>
