<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Rede social</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="${pageContext.servletContext.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="${pageContext.servletContext.contextPath}/assets/css/style.css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <div class="page-header">
                <h1><span style="color: red;">&#x262d;</span> Rede social ista</h1>
            </div>
            
            <c:if test="${not empty sessionScope.user}">
                <ul class="nav nav-pills nav-justified">
                    <li class="nav-1"><a href="${pageContext.servletContext.contextPath}/welcome">Início</a></li>
                    <li class="nav-2"><a href="${pageContext.servletContext.contextPath}/me">Perfil</a></li>
                    <li class="nav-3"><a href="${pageContext.servletContext.contextPath}/groups">Grupos</a></li>
                    <li class="nav-4"><a href="${pageContext.servletContext.contextPath}/logout">Sair</a></li>
                </ul>
                <hr style="margin-bottom: 70px;">
            </c:if>