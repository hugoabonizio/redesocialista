<%@include file="/partials/header.jsp" %>
    <div class="col-md-12" style="margin-bottom: 50px;">
        <h2><small>Área de influência</small></h2>
    </div>
    
    <table class=table">
        <c:forEach items="${users}" var="u">
            <tr>
                <td><a href="${pageContext.servletContext.contextPath}/user?id=${u.id}">${u.name}</a></td>
            </tr>
        </c:forEach>
        <tr></tr>
    </table>
    
    
<%@include file="/partials/footer.jsp" %>