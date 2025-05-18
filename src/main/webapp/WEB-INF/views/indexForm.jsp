<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%--
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
--%>
<html>
<head>
    <title>Ticket</title>
    <style>
        body { margin:0; padding:0; }
        #container { display:flex; }
        #content { flex:1; display:flex; justify-content:center; height:100vh; }
    </style>
</head>
<body>
<%@ include file="layout/header.jsp" %>
<div id="container">
    <%@ include file="layout/leftmenu.jsp" %>
    <div id="content">
        <c:choose>
            <c:when test="${formType eq 'login'}">
                <%@ include file="loginForm.jsp" %>
            </c:when>
            <c:when test="${formType eq 'join'}">
                <%@ include file="joinForm.jsp" %>
            </c:when>
            <c:when test="${formType eq 'train'}">
                <%@ include file="train.jsp" %>
            </c:when>
            <c:when test="${formType eq 'sports'}">
                <%@ include file="sports.jsp" %>
            </c:when>
            <c:when test="${formType eq 'reservation'}">
                <%@ include file="reservationForm.jsp" %>
            </c:when>
            <c:when test="${formType eq 'main'}">
                <%@ include file="mainForm.jsp" %>
            </c:when>
            <c:otherwise>
                <%@ include file="mainForm.jsp" %>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>