<%@include file="/partials/header.jsp" %>

    <c:if test="${not empty updateResult}">
        <c:if test="${updateResult}">
            <div class="alert alert-success" role="alert">Atualizado com sucesso!</div>
        </c:if>
        <c:if test="${not updateResult}">
            <div class="alert alert-danger" role="alert">Erro! Verifique sua senha atual...</div>
        </c:if>
    </c:if>

    <form class="col-md-4 col-center" method="post" action="">
        <div class="form-group">
            <input type="text" class="form-control input-lg" name="old_password" placeholder="Senha atual">
        </div>
        
        <div class="form-group">
            <input type="text" class="form-control input-lg" name="new_password" placeholder="Nova senha">
        </div>
        <div class="form-group">
            <button class="btn btn-primary btn-lg btn-block">Atualizar</button>
            <span class="pull-right"><a href="${pageContext.servletContext.contextPath}/me/edit">Voltar</a></span>
        </div>
    </form>
            
<%@include file="/partials/footer.jsp" %>