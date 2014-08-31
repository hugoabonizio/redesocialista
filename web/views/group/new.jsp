<%@include file="/partials/header.jsp" %>

    <form class="col-md-4 col-center" method="post" action="create">
        <div class="form-group">
            <input type="text" class="form-control input-lg" placeholder="Nome do grupo" name="name" required>
        </div>
        
        <div class="form-group">
            <button class="btn btn-primary btn-lg btn-block">Criar</button>
            <span class="pull-right"><a href="${pageContext.servletContext.contextPath}/groups">Voltar</a></span>
        </div>
    </form>

<%@include file="/partials/footer.jsp" %>