<%@include file="/partials/header.jsp" %>
   
    <c:forEach items="${userList}" var="u">
        <div class="panel panel-info" style="display: block;">            
            <div class="panel-body">
                <div class="col-md-1">
                    <a href="${pageContext.servletContext.contextPath}/user?id=${u.id}">
                        <img src="${pageContext.servletContext.contextPath}/uploads/${u.id}" class="micro-profile-picture" />
                    </a>
                </div>
                <div class="col-md-11">
                    <a href="${pageContext.servletContext.contextPath}/user?id=${u.id}">
                        <h3>${u.name} <small>(${u.login})</small></h3>
                    </a>
                    <h5>${u.description}</h5>
                    <h5>${u.birth}</h5>
                </div>
            </div>
        </div>
    </c:forEach>
                
<%@include file="/partials/footer.jsp" %>