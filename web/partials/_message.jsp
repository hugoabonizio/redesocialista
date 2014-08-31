<div class="panel panel-info" style="display: block;">            
    <div class="panel-body">
        <div class="col-md-1">
            <a href="${pageContext.servletContext.contextPath}/user?id=${m.message.original_user_id}">
                <img src="${pageContext.servletContext.contextPath}/uploads/${m.message.original_user_id}" class="micro-profile-picture" />
            </a>
        </div>
        <div class="col-md-11">
            <span class="comment-itself">${m.message.body}</span>
            <div class="comments">
                <div class="comments-ajax">
                    <a href="${pageContext.servletContext.contextPath}/message/comments" class="load-comments" data-id="${m.message.original_message_id}">Carregar comentários...</a>
                </div>
                <form action="${pageContext.servletContext.contextPath}/user" class="comment-form comment-${m.message.id}" method="post">
                    <input name="comment" class="form-control input-sm" style="width: 500px;" size="40" type="text" placeholder="Escreva um comentário...">
                    <input type="hidden" name="mid" value="${m.message.original_message_id}">
                </form>
            </div>
        </div>
            

        <span class="pull-right">

            <c:if test="${sessionScope.user_id != m.message.user_id}">
                <div class="dropdown">
                    <button class="btn btn-default dropdown-toggle opinion" type="button" id="dropdownMenu1" data-toggle="dropdown" data-id="${m.message.id}">
                        <i class="glyphicon glyphicon-cog"></i>
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                        <li role="presentation">
                            <a role="menuitem" tabindex="-1" href="${pageContext.servletContext.contextPath}/message/repost?mid=${m.message.id}">
                                <i class="glyphicon glyphicon-retweet"></i> Repostar
                            </a>
                        </li>
                        <li role="presentation" class="like-buttons-${m.message.id}">
                            <a role="menuitem" data-action="like" tabindex="-1" href="${pageContext.servletContext.contextPath}/like" class="like" data-id="${m.message.id}">
                                <i class="glyphicon glyphicon-thumbs-up"></i> Curtir
                            </a>
                        </li>
                        <li role="presentation" class="like-buttons-${m.message.id}">
                            <a role="menuitem" data-action="unlike" tabindex="-1" href="${pageContext.servletContext.contextPath}/unlike" class="like" data-id="${m.message.id}">
                                <i class="glyphicon glyphicon-thumbs-down"></i> Descurtir
                            </a>
                        </li>
                    </ul>
                </div>
            </c:if>
        </span>
    </div>
    <div class="panel-footer">
        ${m.message.message_date}
        <c:if test="${me}">
            <c:if test="${m.message.user_id == m.message.original_user_id}">
            <a href="${pageContext.servletContext.contextPath}/message/edit?id=${m.message.id}">Editar</a>
            |
            </c:if>
            <a class="remove-message" data-id="${m.message.id}">Remover</a>
        </c:if>

        <c:if test="${not me}">

            <div class="pull-right">
                <span class="col-md-4">
                    <c:if test="${m.likes >= 0}">
                        <span style="color: green;" class="likes-${m.message.id}">${m.likes}</span>
                    </c:if>
                    <c:if test="${m.likes < 0}">
                        <span style="color: red;" class="likes-${m.message.id}">${m.likes}</span>
                    </c:if>
                </span>
            </div>
        </c:if>
    </div>
</div>