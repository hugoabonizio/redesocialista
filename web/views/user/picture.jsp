<%@include file="/partials/header.jsp" %>

    <c:if test="${not empty updateResult}">
        <c:if test="${updateResult}">
            <div class="alert alert-success" role="alert">Atualizado com sucesso!</div>
        </c:if>
        <c:if test="${not updateResult}">
            <div class="alert alert-danger" role="alert">Erro no upload...</div>
        </c:if>
    </c:if>
            
    <form class="col-md-4 col-center" method="post" action="" enctype="multipart/form-data">
        <div class="form-group">
            <input type="file" class="form-control input-lg" name="picture">
        </div>
        <div class="form-group">
            <button class="btn btn-primary btn-lg btn-block">Atualizar</button>
            <span class="pull-right"><a href="${pageContext.servletContext.contextPath}/me/edit">Voltar</a></span>
        </div>
    </form>
            
<%@include file="/partials/footer.jsp" %>