<%--
  Created by IntelliJ IDEA.
  User: jgkim
  Date: 2025-05-17
  Time: 오후 7:48
  To change this template use File | Settings | File Templates.
--%>
<!-- /layout/leftmenu.jsp -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link href="/resources/css/main.css" rel="stylesheet" type="text/css">

<div id="leftmenu" class="leftmenu">
    <div>
        <span class="menu-title">Menu</span>
    </div>

    <div class="menu-item" data-path="/sportsForm">
        <a href="/sportsForm" class="menu-link">Sports</a>
    </div>

    <div class="menu-item" data-path="/trainForm">
        <a href="/trainForm" class="menu-link">Train</a>
    </div>

    <hr>

    <div class="menu-item" data-path="/reservationForm">
        <a href="/reservationForm" class="menu-link">Reservation</a>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const urlParams = new URLSearchParams(window.location.search);
        const formType = urlParams.get("formType"); // ex: "trainForm"

        if (!formType) return;

        document.querySelectorAll('.menu-item').forEach(item => {
            const path = item.getAttribute('data-path'); // ex: "/trainForm"
            if (path.includes(formType)) {
                const link = item.querySelector('.menu-link');
                link.classList.add('active');
            }
        });
    });
</script>
