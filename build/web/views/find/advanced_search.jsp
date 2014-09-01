<%@include file="/partials/header.jsp" %>
   
    <c:forEach items="${messageList}" var="m">
        <%@include file="/partials/_message.jsp" %>
    </c:forEach>
                
<%@include file="/partials/footer.jsp" %>