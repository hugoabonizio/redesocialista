<%@include file="/partials/header.jsp" %>
    <!---->
    <form class="col-md-4 col-center" method="post" action="create">
        <div class="form-group">
            <input type="text" class="form-control input-lg" placeholder="Nome completo" name="name" required>
        </div>
        <div class="form-group">
            <input type="text" class="form-control input-lg" placeholder="Usuário" name="login" required>
        </div>
        <div class="form-group">
            <input type="password" class="form-control input-lg" placeholder="Senha" name="password" required>
        </div>
        
        <div class="form-group">
            <input type="date" class="form-control input-lg" placeholder="Nascimento" name="birth" required>
        </div>
        <div class="form-group">
            <button class="btn btn-primary btn-lg btn-block">Registrar</button>
            <span class="pull-right"><a href="${pageContext.servletContext.contextPath}/">Voltar</a></span>
        </div>
    </form>
    <!---->
<%@include file="/partials/footer.jsp" %>