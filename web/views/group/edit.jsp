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
            <input type="text" class="form-control input-lg" name="name" value="${group_info.name}">
        </div>
        
        <input type="hidden" name="group_id" value="${group_info.id}" />

        <div class="form-group">
            <button class="btn btn-primary btn-lg btn-block">Atualizar</button>
            <span class="pull-right"><a href="${pageContext.servletContext.contextPath}/groups">Voltar</a></span>
        </div>
    </form>
        
    <div class="col-md-6 col-center" style="margin-top: 50px;">
        <table class="table">
            <c:forEach items="${userList}" var="u">
                <tr>
                    <td>
                        <a href="${pageContext.servletContext.contextPath}/user?id=${u.id}">${u.name}</a>
                    </td>
                    <td>
                        <a href="${pageContext.servletContext.contextPath}/group/add?id=${group_info.id}&user_id=${u.id}" class="add-member">
                            <i class="glyphicon glyphicon-plus"></i>
                        </a>
                    </td>
                </tr>
                
            </c:forEach>
        </table>
    </div>
            
<%@include file="/partials/footer.jsp" %>