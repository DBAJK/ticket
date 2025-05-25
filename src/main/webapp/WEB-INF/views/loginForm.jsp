<%--
  Created by IntelliJ IDEA.
  User: jgkim
  Date: 2025-05-13
  Time: 오후 7:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>

<script type="text/javascript" >
    function loginChk(){
        var params =$("#loginForm").serialize();
        console.log(params);
        $.ajax({
            type : "post",
            url : "/service/loginForm",
            data : params,
            success : function(data){
                if(data == "loginOk"){
                    location.href = '/sportsForm';
                } else {
                    alert("로그인에 실패하였습니다.\nID와 비밀번호를 확인해주세요.");
                }
            },
            error : function(request, status, error){
                console.log(request.status);
                console.log(error);
            }
        });
    }

</script>
<style>

    #loginForm input {
        width: 100%;
        height: 62px;
        padding: 0 12px;
        margin-bottom: 15px;
        font-size: 1rem;
        border: 1.5px solid #d0d2d8;
        border-radius: 6px;
        background: #f5f6fa;
        outline: none;
        transition: border 0.2s;
        box-sizing: border-box;
    }

    #loginForm input:focus {
        border: 1.5px solid #4a5cc6;
        background: #fff;
    }
</style>
<body>
    <!-- 로그인 폼 영역 -->
    <div style="width:600px; text-align:center;">
        <h1 style="color:#4a5cc6; font-size: 70px">LOGIN</h1>
        <form id="loginForm" name="loginForm" method="post">
            <input type="text" id="userId" name="userId" placeholder="ID" /><br/>
            <input type="password" id="userPw" name="userPw" placeholder="PASSWORD" /><br/>
            <div style="margin-bottom:20px; color:#888;">
                <a href="joinForm" >회원가입</a>
            </div>
            <button type="button" onclick="loginChk();" style="width:100%; height:45px; background:#4a5cc6; color:#fff; font-size:20px; border:none; border-radius:5px;">Login</button>
        </form>
    </div>
</body>
