<%@include file="/partials/header.jsp" %>
    <div class="col-md-12" style="margin-bottom: 50px;">
        <h2><small>Bem vindo(a), ${sessionScope.user.name}!</small></h2>
    </div>
    
    <c:if test="${not empty messageResult}">
        <c:if test="${messageResult}">
            <div class="alert alert-success col-md-12" role="alert">Compartilhado!</div>
        </c:if>
        <c:if test="${not messageResult}">
            <div class="alert alert-danger col-md-12" role="alert">Tivemos algum problema...</div>
        </c:if>
    </c:if>
    
    <form class="col-md-6 col-center" method="post" action="${pageContext.servletContext.contextPath}/message/create">
        <div class="form-group">
            <textarea name="message" class="form-control" placeholder="Digite uma mensagem para compartilhar...." rows="3"></textarea>
            <button class="btn btn-group-justified btn-primary">Compartilhar</button>
        </div>
    </form>
        
    <div class="col-md-12" style="margin-top: 50px;">
        <c:forEach items="${messages}" var="m">
            <%@include file="/partials/_message.jsp"%>
        </c:forEach>
    </div>
    
<%@include file="/partials/footer.jsp" %>