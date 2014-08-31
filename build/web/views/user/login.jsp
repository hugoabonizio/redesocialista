<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@include file="/partials/header.jsp" %>
    <c:if test="${not empty registerResult}">
        <c:if test="${registerResult}">
            <div class="alert alert-success" role="alert">Usuário cadastrado com sucesso!</div>
        </c:if>
        <c:if test="${not registerResult}">
            <div class="alert alert-danger" role="alert">Falha na criação do usuário (tente outro nome de usuário)!</div>
        </c:if>
    </c:if>
            
    <c:if test="${not empty loginResult}">
        <c:if test="${loginResult}">
            <div class="alert alert-success" role="alert">Logado!</div>
        </c:if>
        <c:if test="${not loginResult}">
            <div class="alert alert-danger" role="alert">Usuário ou senha incorretos</div>
        </c:if>
    </c:if>
    <!---->
    <form class="col-md-4 col-center" method="post" action="${pageContext.servletContext.contextPath}/auth">
        <div class="form-group">
            <input type="text" class="form-control input-lg" placeholder="Usuário" name="login" value="hugo">
        </div>
        <div class="form-group">
            <input type="password" class="form-control input-lg" placeholder="Senha" name="password" value="senha">
        </div>
        <div class="form-group">
            <button class="btn btn-primary btn-lg btn-block">Entrar</button>
            <span class="pull-right"><a href="${pageContext.servletContext.contextPath}/user/new">Registrar</a></span>
        </div>
    </form>
    <!---->
<%@include file="/partials/footer.jsp" %>