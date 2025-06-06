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
        padding-left: 35px;
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
        padding-right: 25px;
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

    .user-dropdown {
        position: relative;
        display: inline-block;
        cursor: pointer;
    }

    .user-name {
        font-weight: bold;
    }

    .dropdown-toggle {
        margin-left: 4px;
    }

    .dropdown-menu {
        position: absolute;
        top: 100%;
        right: 0;
        background-color: white;
        border: 1px solid #ccc;
        box-shadow: 0px 4px 6px rgba(0,0,0,0.1);
        z-index: 1000;
        min-width: 120px;
    }

    .dropdown-item {
        display: block;
        padding: 8px 12px;
        text-decoration: none;
        color: black;
    }

    .dropdown-item:hover {
        background-color: #f0f0f0;
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
    // JSP에서 세션 값 전달
    const userName = '<c:out value="${sessionScope.userName}" default="" />';
    const isLoggedIn = userName !== '';

    const userSection = document.getElementById('user-section');
    if (isLoggedIn) {
        userSection.innerHTML = `
            <div class="user-dropdown">
                <span class="dropdown-toggle"><span class="user-name">\${userName}  ▼</span></span>
                <div class="dropdown-menu" style="display: none;">
                    <a href="/myPage" class="dropdown-item">마이페이지</a>
                    <a href="/logout" class="dropdown-item">로그아웃</a>
                </div>
            </div>
        `;
    } else {
        userSection.innerHTML = `
            <button class="login-button" onclick="location.href='/loginForm'">로그인</button>
        `;
    }
    // 이벤트 위임 방식 사용
    document.addEventListener("click", function(e) {
        const toggle = document.querySelector('.dropdown-toggle');
        const menu = document.querySelector('.dropdown-menu');
        if (!toggle || !menu) return;

        if (toggle.contains(e.target)) {
            // 토글 누르면 메뉴 보이기/숨기기
            menu.style.display = (menu.style.display === 'block') ? 'none' : 'block';
        } else if (!menu.contains(e.target)) {
            // 바깥 클릭 시 닫기
            menu.style.display = 'none';
        }
    });

    document.querySelector('.header-left').onclick = function() {
        window.location.href = '/sportsForm';
    };
</script>
