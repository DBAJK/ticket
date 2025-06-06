<%--
  Created by IntelliJ IDEA.
  User: jgkim
  Date: 2025-05-25
  Time: 오후 8:51
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
    .ticket-container {
        font-family: 'Pretendard', 'Malgun Gothic', Arial, sans-serif;
        width: 90%;
        min-height: 80vh;          /* 화면 높이의 80% */
        margin: 40px auto;
        border: 1px solid #e5e5e5;
        border-radius: 14px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        background: #fff;
        padding: 0 0 24px 0;
        display: flex;
        flex-direction: column;
    }
    .ticket-title {
        margin: 24px 0 16px 0;
        text-align: center;
        letter-spacing: -1px;
    }
    .ticket-qr {
        display: flex;
        height: 430px;
        justify-content: center;
        align-items: center;
        margin-bottom: 16px;
    }
    .ticket-divider {
        border-top: 2px solid #ececec;
        margin: 0 0 20px 0;
    }
    .ticket-content {
        padding: 0 24px;
        font-size: 25px;
        color: #222;
    }
    .ticket-content p {
        margin: 12px 0 0 0;
        line-height: 1.6;
    }
    .ticket-content .label {
        font-weight: bold;
        margin-right: 4px;
    }
    .ticket-content .value {
        font-weight: 400;
    }
    .ticket-actions {
        margin-top: auto;
        display: flex;
        flex-direction: column;
        align-items: center;
        bottom: 0;
    }
    .cancel-btn {
        color: #3d4db7;
        font-size: 20px;
        font-weight: 500;
        cursor: pointer;
        background: none;
        border-radius: 8px;
        padding: 8px 32px;
        transition: background 0.2s, color 0.2s;
        text-align: center;
        margin: 0 auto;
    }
    .cancel-btn:hover {
        background: #3d4db7;
        color: #fff;
    }

</style>

<div class="ticket-container">
    <h1 class="ticket-title">티켓 확인</h1>
    <div class="ticket-qr">
        <!-- QR코드 SVG 예시 (이미지로 교체 가능) -->
        <svg width="120" height="120" viewBox="0 0 120 120">
            <rect width="120" height="120" fill="#fff"/>
            <rect x="12" y="12" width="24" height="24" fill="#5c6bc0"/>
            <rect x="12" y="48" width="24" height="24" fill="#5c6bc0"/>
            <rect x="48" y="12" width="24" height="24" fill="#5c6bc0"/>
            <rect x="84" y="12" width="24" height="24" fill="#5c6bc0"/>
            <rect x="84" y="48" width="24" height="24" fill="#5c6bc0"/>
            <rect x="48" y="48" width="24" height="24" fill="#5c6bc0"/>
            <rect x="48" y="84" width="24" height="24" fill="#5c6bc0"/>
            <rect x="84" y="84" width="24" height="24" fill="#5c6bc0"/>
            <rect x="12" y="84" width="24" height="24" fill="#5c6bc0"/>
        </svg>
    </div>
    <div class="ticket-divider"> </div>
    <div class="ticket-content"> </div>
    <div class="ticket-actions">
        <a class="cancel-btn" id="cnlBtn">예매취소</a>
    </div>
</div>

<script>
    $(document).ready(function () {
        searchTicketInfo();

        $("#cnlBtn").click(function(){
            if (!confirm('정말 예매를 취소하시겠습니까?')) return;
            const params = new URLSearchParams(window.location.search);
            const ticketId = params.get('ticketId');
            const placeId = params.get('placeId');

            $.ajax({
                url: '/api/ticketCancel',
                type: 'post',
                data: {ticketId, placeId},
                success: function(data) {
                    alert('예매가 취소되었습니다.');
                    window.close(); // 팝업이면 닫기
                },
                error: function(xhr) {
                    alert('예매 취소에 실패했습니다.');
                }
            });
        });
    });

    function searchTicketInfo() {
        const params = new URLSearchParams(window.location.search);
        const ticketId = params.get('ticketId');
        const placeId = params.get('placeId');

        $.ajax({
            url: '/reservation/ticketInfo',
            type: 'GET',
            data: { ticketId, placeId },
            dataType: 'json',
            success: function (data) {
                var seatList = data.map(function(item) { return item.seatFull; }).join(', ');
                $('.ticket-content').html(
                    '<p><span class="label">티켓 내용 :</span> <span class="value">' + (data[0].ticketName || '') + '</span></p>' +
                    '<p><span class="label">일시 :</span> <span class="value">' + (data[0].usedDt || '') + '</span></p>' +
                    '<p><span class="label">장소 :</span> <span class="value">' + (data[0].placeName || '') + '</span></p>' +
                    '<p><span class="label">좌석 :</span> <span class="value">' + seatList + '</span></p>'
                );
            },
            error: function () {
                alert('예매 정보를 불러오는 데 실패했습니다.');
            }
        });
    }

</script>