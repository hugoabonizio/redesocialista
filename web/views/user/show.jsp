<%@include file="/partials/header.jsp" %>
    
    <c:set var="me" value="${user_info.id == sessionScope.user_id}" />

    <div class="page-header">
        <h1>
            <small>
                ${user_info.name} <small>(${user_info.login})</small>
                <br>
                <small>Nascimento: ${user_info.birth}</small>
                <img src="${pageContext.servletContext.contextPath}/uploads/${user_info.id}" onerror="this.src='${pageContext.servletContext.contextPath}/uploads/user.png';" class="pull-right profile-picture" />
            </small>
            <h4>
                <c:if test="${me}">
                    <a href="${pageContext.servletContext.contextPath}/me/edit">Editar</a>
                </c:if>
                <c:if test="${not me}">
                    <c:if test="${following}">
                        <a href="${pageContext.servletContext.contextPath}/follow/" class="btn btn-warning unfollow" data-id="${user_info.id}">
                            <i class="glyphicon glyphicon-remove"></i> Deseguir
                        </a>
                    </c:if>
                    <c:if test="${not following}">
                        <a href="${pageContext.servletContext.contextPath}/follow/" class="btn btn-success follow" data-id="${user_info.id}">
                            <i class="glyphicon glyphicon-plus"></i> Seguir
                        </a>
                    </c:if>
                </c:if>
            </h4>
        </h1>
    </div>
        
    <div class="col-md-12">
        ${user_info.description}
    </div>
    
    <div class="col-md-12" style="margin-top: 50px;">
        <c:forEach items="${messages}" var="m">
            <%@include file="/partials/_message.jsp"%>
        </c:forEach>
    </div>
    
<%@include file="/partials/footer.jsp" %>