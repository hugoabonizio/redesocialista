<%@include file="/partials/header.jsp" %>

    <c:if test="${not empty updateResult}">
        <c:if test="${updateResult}">
            <div class="alert alert-success" role="alert">Atualizado com sucesso!</div>
        </c:if>
        <c:if test="${not updateResult}">
            <div class="alert alert-danger" role="alert">Houve algum problema...</div>
        </c:if>
    </c:if>
    
    <a href="${pageContext.servletContext.contextPath}/me/destroy" class="btn btn-danger pull-right destroy-profile">Excluir perfil</a>
    
    <form class="col-md-4 col-center" method="post" action="update">
        <div class="form-group">
            <input type="text" class="form-control input-lg" name="name" value="${user_info.name}">
        </div>
        
        <div class="form-group">
            <input type="date" class="form-control input-lg" value="${user_info.birth}" name="birth">
        </div>
        
        <div class="form-group">
            <textarea class="form-control input-lg" name="description">${user_info.description}</textarea>
        </div>
        
        <div class="form-group">
            <button class="btn btn-primary btn-lg btn-block">Atualizar</button>
            <span class="pull-right"><a href="${pageContext.servletContext.contextPath}/me/edit/password">Trocar senha</a></span>
            <br>
            <span class="pull-right"><a href="${pageContext.servletContext.contextPath}/me/picture">Imagem de perfil</a></span>
        </div>
        
    </form>
            
<%@include file="/partials/footer.jsp" %>