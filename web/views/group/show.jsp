<%@include file="/partials/header.jsp" %>

    <div class="page-header">
        <h1>
            <small>
                ${group_info.name}
                <a href="${pageContext.servletContext.contextPath}/user?id=${group_info.user_id}">
                    <img src="${pageContext.servletContext.contextPath}/uploads/${group_info.user_id}" class="micro-profile-picture" />
                </a>
            </small>
        </h1>
    </div>
    
    <c:forEach items="${messageList}" var="m">
        <div class="panel panel-info" style="display: block;">            
            <div class="panel-body">
                <a href="${pageContext.servletContext.contextPath}/user?id=${m.user_id}">
                    <img src="${pageContext.servletContext.contextPath}/uploads/${m.user_id}" class="micro-profile-picture" />
                </a>
                ${m.body}
            </div>
            <div class="panel-footer">
                ${m.message_date}
                
                <c:if test="${group_info.user_id == sessionScope.user_id}">
                    <a href="${pageContext.servletContext.contextPath}/group/remove?id=${group_info.id}&user_id=${m.user_id}" class="remove-member">
                        Remover do grupo
                    </a>
                </c:if>
            </div>
        </div>
    </c:forEach>
                
<%@include file="/partials/footer.jsp" %>