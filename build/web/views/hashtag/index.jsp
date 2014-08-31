<%@include file="/partials/header.jsp" %>

    <div class="page-header">
        <h1>
            <small>
                ${term}
            </small>
        </h1>
    </div>
    
    <c:forEach items="${messageList}" var="m">
        <%@include file="/partials/_message.jsp" %>
    </c:forEach>
                
<%@include file="/partials/footer.jsp" %>