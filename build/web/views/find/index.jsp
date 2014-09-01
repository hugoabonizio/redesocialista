<%@include file="/partials/header.jsp" %>
<div class="col-center col-md-6">
    <form class="input-group" method="post" action="">
      <input type="text" class="form-control" name="search">
      <span class="input-group-btn">
        <button class="btn btn-default" type="button">Procurar</button>
      </span>
    </form>
    <a href="${pageContext.servletContext.contextPath}/search_advanced" class="pull-right">Buscar avançada...</a>
        
</div>

<%@include file="/partials/footer.jsp" %>