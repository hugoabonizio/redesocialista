<%@include file="/partials/header.jsp" %>

    <div class="page-header">
        <h1>
            <small>Seus grupos</small>
            <a href="${pageContext.servletContext.contextPath}/group/new" class="pull-right btn btn-primary">
                <i class="glyphicon glyphicon-plus"></i> Criar novo
            </a>
        </h1>
        
    </div>

    <c:if test="${not empty createResult}">
        <c:if test="${createResult}">
            <div class="alert alert-success col-md-12" role="alert">Grupo criado com sucesso</div>
        </c:if>
        <c:if test="${not createResult}">
            <div class="alert alert-danger col-md-12" role="alert">Este nome já está em uso, profavor escolha outro</div>
        </c:if>
    </c:if>
    
    <div class="col-md-6 col-center">
        <c:if test="${empty groupList}">
            <h3><small>Você não tem grupos no momento...</small></h3>
        </c:if>

        <c:if test="${not empty groupList}">
            <table class="table">
                <thead>
                    <tr>
                        <th colspan="2">Nome</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${groupList}" var="g">
                        <tr>
                            <td><a href="${pageContext.servletContext.contextPath}/group?id=${g.id}">${g.name}</a></td>
                            <td>
                                <a href="${pageContext.servletContext.contextPath}/group/edit?id=${g.id}">
                                    <i class="glyphicon glyphicon-edit"></i>
                                </a>
                                <a href="${pageContext.servletContext.contextPath}/group/destroy?id=${g.id}" class="remove-group">
                                    <i class="glyphicon glyphicon-remove"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

<%@include file="/partials/footer.jsp" %>