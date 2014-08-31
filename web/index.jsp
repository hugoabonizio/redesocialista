<%@include file="/partials/header.jsp" %>
    <!---->
    <c:if test="${empty sessionScope.user}">
        <c:redirect context="${pageContext.servletContext.contextPath}" url="/login" />
    </c:if>
    <c:if test="${not empty sessionScope.user}">
        <c:redirect context="${pageContext.servletContext.contextPath}" url="/welcome" />
    </c:if>
    <!---->
<%@include file="/partials/footer.jsp" %>