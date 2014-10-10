<%@include file="/partials/header.jsp" %>
    <div class="col-md-12" style="margin-bottom: 50px;">
        <h2><small>Relatórios</small></h2>
    </div>
    
    <form class="col-md-4 col-center" action="${pageContext.servletContext.contextPath}/stats/top20" method="post">
        <button class="btn btn-primary">Top 3 usuários</button>
    </form>
    
    
    
<%@include file="/partials/footer.jsp" %>