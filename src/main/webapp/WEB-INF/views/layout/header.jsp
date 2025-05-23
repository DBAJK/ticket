<%--
  Created by IntelliJ IDEA.
  User: jgkim
  Date: 2025-05-17
  Time: 오후 7:48
  To change this template use File | Settings | File Templates.
--%>
<!-- /layout/header.jsp -->
<%--
<div id="header" style="width:100%; height:60px; background:#fff; border-bottom:1px solid #ddd; display:flex; align-items:center; justify-content:space-between; padding:0 20px;">
    <div style="display:flex; align-items:center;">
        <div style="width:32px; height:32px; background:#4a5cc6; color:#fff; border-radius:50%; display:flex; align-items:center; justify-content:center; font-weight:bold; margin-right:10px;">
            T
        </div>
        <span style="font-weight:bold;">Ticket</span>
    </div>
    <input type="text" placeholder="search" style="width:300px; height:30px; border:1px solid #ccc; border-radius:4px; padding:0 10px;"/>
    <div style="display:flex; align-items:center;">
        <span style="margin-right:10px;"><img src="user_icon.png" alt="user" style="width:24px; height:24px;"/></span>
        <span>Ticket <p>▼</p></span>
    </div>
</div>
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>
    .header {
        width: 100%;
        height: 80px;
        background: #fff;
        border-bottom: 1px solid #ddd;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .header-left {
        display: flex;
        align-items: center;
    }

    .logo-circle {
        width: 32px;
        height: 32px;
        background: #4a5cc6;
        color: #fff;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        margin-right: 10px;
    }

    .logo-text {
        font-weight: bold;
    }

    .search-input {
        width: 500px;
        height: 40px;
        border: 1px solid #ccc;
        border-radius: 4px;
        padding: 0 10px;
    }

    .search-input {
        width: 500px;
        height: 40px;
        padding: 0 10px;
        font-size: 1rem;
        border: 1.5px solid #d0d2d8;
        border-radius: 6px;
        background: #f5f6fa;
        outline: none;
        transition: border 0.2s;
        box-sizing: border-box;
    }

    .search-input:focus {
        border: 1.5px solid #4a5cc6;
        background: #fff;
    }


    .header-right {
        display: flex;
        align-items: center;
    }

    .user-name {
        display: flex;
        align-items: center;
    }

    .login-button {
        padding: 6px 12px;
        border: 1px solid #4a5cc6;
        background-color: #fff;
        color: #4a5cc6;
        border-radius: 4px;
        cursor: pointer;
        font-weight: bold;
    }
</style>
<div id="header" class="header">
    <div class="header-left">
        <div class="logo-circle">T</div>
        <span class="logo-text">Ticket</span>
    </div>

    <input type="text" placeholder="search" class="search-input"/>

    <div class="header-right" id="user-section">
        <!-- 로그인 상태에 따라 동적 렌더링 -->
    </div>
</div>

<script>
    // 로그인 여부 확인 (예: 세션에서 확인)
    const isLoggedIn = false; // true일 경우 사용자 이름 표시

    const userSection = document.getElementById('user-section');
    if (isLoggedIn) {
        userSection.innerHTML = `
<!--
            <span class="user-icon"><img src="user_icon.png" alt="user"/></span>
-->
            <span class="user-name">홍길동<span>▼</span></span>
        `;
    } else {
        userSection.innerHTML = `
            <button class="login-button" onclick="location.href='/loginForm'">로그인</button>
        `;
    }

    document.querySelector('.header-left').onclick = function() {
        window.location.href = '/mainForm';
    };

</script>
