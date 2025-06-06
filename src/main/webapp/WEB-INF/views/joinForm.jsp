<%--
  Created by IntelliJ IDEA.
  User: jgkim
  Date: 2025-05-13
  Time: 오후 7:40
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
    .contentArea {
        margin: 20px auto;
        border-radius: 10px;
        font-family: 'Noto Sans KR', sans-serif;
        width: 600px;
    }
    .contentArea .headerArea {
        display: flex;
        align-items: center;
        justify-content: space-between; /* 필요에 따라 space-between 또는 flex-start */
        padding: 0 0 20px 0; /* 아래 여백 등 필요에 따라 조정 */
    }
    .contentArea .headerArea span {
        font-size: 50px;
        color: #4a5cc6;
        font-weight: bold;
        margin-right: 20px; /* 버튼과 간격 */
        letter-spacing: 1px;
    }

    .contentArea .btnPanel,
        #joinForm .btnPanel {
        display: flex;
        gap: 10px;
        margin-top: 24px;
        justify-content: left;
    }

    #joinForm label {
        display: block;
        margin: 18px 0 6px 2px;
        font-size: 1.1rem;
        color: #222;
        font-weight: 500;
    }

    #joinForm input[type="text"],
    #joinForm input[type="password"],
    #joinForm input[type="date"],
    #joinForm input[type="tel"] {
        width: 100%;
        height: 62px;
        padding: 0 12px;
        font-size: 1rem;
        border: 1.5px solid #d0d2d8;
        border-radius: 6px;
        background: #f5f6fa;
        outline: none;
        transition: border 0.2s;
        box-sizing: border-box;
    }

    #joinForm input[type="text"]:focus,
    #joinForm input[type="password"]:focus,
    #joinForm input[type="date"]:focus,
    #joinForm input[type="tel"]:focus {
        border: 1.5px solid #4a5cc6;
        background: #fff;
    }

    #joinForm a,
    .input-with-btn .input-btn {
        margin-left: 8px;
        background: #4a5cc6;
        color: #fff;
        border-radius: 5px;
        font-size: 0.95rem;
        text-decoration: none;
        vertical-align: middle;
        cursor: pointer;
        transition: background 0.2s;
        height: 30px;
        line-height: 1.2;
    }
    #joinForm span {
        magin: 10px;
    }

    #joinForm a:hover,
    .input-with-btn .input-btn:hover {
        background: #3443a6;
    }

    #btnSave {
        background: #4a5cc6;
        color: #fff;
        border: none;
        padding: 12px 0;
        border-radius: 7px;
        font-weight: bold;
        cursor: pointer;
        transition: background 0.2s;
        width: 50px;
    }

    #btnSave:hover {
        background: #3443a6;
    }

    #btnDel {
        background: #f8cfc2;
        color: #fff;
        border: none;
        padding: 12px 0;
        border-radius: 7px;
        font-weight: bold;
        cursor: pointer;
        transition: background 0.2s;
        width: 50px;
    }

    #btnDel:hover {
        background: #e0b2a4;
    }

    .input-with-btn {
        position: relative;
        width: 100%;
        margin-bottom: 16px;
        /* max-width는 상위 .contentArea에서 지정됨 */
    }

    .input-with-btn input[type="text"] {
        padding-right: 100px; /* 버튼 공간 확보 */
    }

    .input-with-btn .input-btn {
        position: absolute;
        right: 6px;
        top: 50%;
        transform: translateY(-50%);
        height: 30px;
        padding: 0 18px;
        margin-left: 0;
    }

    ::placeholder {
        color: #b0b5c1;
        font-size: 0.98rem;
        letter-spacing: 0.5px;
    }
</style>
<body>
    <div class="contentArea">
        <div class="headerArea">
            <span>Sign UP</span>
            <div class="btnPanel">
                <button type="button" id="btnSave">가입</button>
                <button type="button" id="btnDel">취소</button><br>
            </div>
        </div>
        <form id="joinForm" name="joinForm" method="post">
            <p>아이디</p>
            <div class="input-with-btn">
                <input type="text" name="userId" id="userId" placeholder="아이디 입력 (6~20자)">
                <button type="button" class="input-btn" onclick="doubleChk();">중복확인</button>
            </div>
            <input type="hidden" name="idUnCheck" id="idUnCheck"/>  <!--  id 중복체크 여부 확인 -->

            <p>비밀번호</p> <input type="password" name="userPw" id="userPw" placeholder="비밀번호 입력(문자, 숫자, 특수문자 포함 8~20자)"><br>
            <p>비밀번호 확인</p> <input type="password" name="userPwChk" id="userPwChk" placeholder="비밀번호 재입력"><br>

            <p>이름</p> <input type="text" name="userName" id="userName" placeholder="이름을 입력해주세요."><br>
            <p>전화번호</p> <input type="tel" name="telNo" id="telNo" placeholder="유대폰 번호 입력( ‘-’ 제외 11자리 입력)"><br>
            <p>생년월일</p> <input type="date" name="birtyD" id="birtyD" ><br>
        </form>

    </div>
</body>

<script type="text/javascript">
    var idck = 0;

    $(document).ready(function() {

        // 전화번호 자동 포맷팅
        $("#telNo").on("input", function () {
            var num = $(this).val().replace(/[^0-9]/g, '').substring(0, 11);
            var formatted = '';
            if (num.length <= 3) {
                formatted = num;
            } else if (num.length <= 7) {
                formatted = num.substring(0, 3) + '-' + num.substring(3);
            } else {
                formatted = num.substring(0, 3) + '-' + num.substring(3, 7) + '-' + num.substring(7);
            }
            $(this).val(formatted);
        });

        // 저장 버튼 클릭 시
        $("#btnSave").click(function(){
            if (!checkExistData(joinForm.userId.value, "아이디")) return false;
            if (idck !== 1) {
                alert("아이디 중복 확인을 완료해 주세요.");
                return false;
            }
            if (!checkExistData(joinForm.userPw.value, "비밀번호")) return false;
            if (!checkExistData(joinForm.userPwChk.value, "비밀번호 확인")) return false;
            if (joinForm.userPw.value !== joinForm.userPwChk.value) {
                alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                $("#userPwChk").focus();
                return false;
            }
            if (!checkExistData(joinForm.userName.value, "이름")) return false;
            if (!checkExistData(joinForm.telNo.value, "전화번호")) return false;
            if (!checkExistData(joinForm.birtyD.value, "생년월일")) return false;

            if (confirm("회원가입 하시겠습니까?")) {
                var params = $("#joinForm").serialize();
                console.log(params);
                $.ajax({
                    url: '/saveJoinForm',
                    data: params,
                    type: 'POST',
                    success: function(data) {
                        alert("회원가입에 성공하였습니다.");
                        location.href = "/loginForm";
                    },
                    error: function(request, status, error) {
                        console.log("code: " + request.status);
                        console.log("message: " + request.responseText);
                        console.log("error: " + error);
                        alert("서버 오류 발생");
                    }
                });
            } else {
                alert("다시 확인해주세요.");
            }
        });

        // 취소 버튼
        $("#btnDel").click(function() {
            if (confirm("로그인 화면으로 돌아가겠습니까?")) {
                location.href = '/loginForm';
            }
        });
    });

    // 공백 확인 함수
    function checkExistData(value, dataName) {
        if (value === "") {
            alert(dataName + "을(를) 입력해주세요!");
            return false;
        }
        return true;
    }

    // 아이디 중복 확인
    function doubleChk() {
        var userId = joinForm.userId.value.trim();
        if (userId === "") {
            alert("아이디를 먼저 입력해주세요.");
            return;
        }

        $.ajax({
            url: "/idCheck",
            type: "post",
            data: {"userId": userId},
            dataType: 'text',
            success: function(cnt) {
                console.log(cnt);
                if (cnt === "0") {
                    alert("사용 가능한 아이디입니다.");
                    idck = 1;
                } else {
                    alert("아이디가 존재합니다. 다른 아이디를 입력해주세요.");
                    idck = 2;
                    $("#userId").val('').focus();
                }
            },
            error: function(request, status, error) {
                console.log("code: " + request.status);
                console.log("message: " + request.responseText);
                console.log("error: " + error);
                alert("서버 오류 발생");
            }
        });
    }
</script>
