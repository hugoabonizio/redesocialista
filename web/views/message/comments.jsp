<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:forEach items="${comments}" var="c">
    <div class="comment">
        <a href="${pageContext.servletContext.contextPath}/user?id=${c.user_id}">
            <img src="${pageContext.servletContext.contextPath}/uploads/${c.user_id}" class="micro-profile-picture" />
        </a>
        ${c.body}
    </div>
</c:forEach>

<c:if test="${empty comments}">
    Não há comentários... escreva o primeiro!
</c:if>