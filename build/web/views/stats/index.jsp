<%@include file="/partials/header.jsp" %>
    <div class="col-md-12" style="margin-bottom: 50px;">
        <h2><small>Relatórios</small></h2>
    </div>
    
    <form class="col-md-4 col-center" action="${pageContext.servletContext.contextPath}/stats/top20users" method="post">
        <input class="form-control" name="from" placeholder="YYYY-MM-DD HH24:MI:SS">
        <input class="form-control" name="to" placeholder="YYYY-MM-DD HH24:MI:SS">
        <button class="btn btn-primary">Top 20 usuários</button>
    </form>
        
    <hr>
        
    <form class="col-md-4 col-center" action="${pageContext.servletContext.contextPath}/stats/top20messages" method="post">
        <input class="form-control" name="from" placeholder="YYYY-MM-DD HH24:MI:SS">
        <input class="form-control" name="to" placeholder="YYYY-MM-DD HH24:MI:SS">
        <button class="btn btn-primary">Top 20 publicações</button>
    </form>
    
    
    
<%@include file="/partials/footer.jsp" %>