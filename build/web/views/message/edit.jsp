<%@include file="/partials/header.jsp" %>

    <c:if test="${not empty updateResult}">
        <c:if test="${updateResult}">
            <div class="alert alert-success" role="alert">Atualizado com sucesso!</div>
        </c:if>
        <c:if test="${not updateResult}">
            <div class="alert alert-danger" role="alert">Houve algum problema...</div>
        </c:if>
    </c:if>

    <form class="col-md-4 col-center" method="post" action="update">
        <div class="form-group">
            <textarea type="text" class="form-control input-lg" name="message">${message_info.body}</textarea>
        </div>
        
        <input type="hidden" name="message_id" value="${message_info.id}" />
        
        <div class="form-group">
            <button class="btn btn-primary btn-lg btn-block">Atualizar</button>
            <span class="pull-right"><a href="${pageContext.servletContext.contextPath}/groups">Voltar</a></span>
        </div>
    </form>
            
<%@include file="/partials/footer.jsp" %>