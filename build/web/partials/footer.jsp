        </div>
        
        <script src="${pageContext.servletContext.contextPath}/assets/js/jquery.min.js"></script>
        <script src="${pageContext.servletContext.contextPath}/assets/js/bootstrap.min.js"></script>
        <script src="${pageContext.servletContext.contextPath}/assets/js/script.js"></script>
        <script src="${pageContext.servletContext.contextPath}/assets/js/message.js"></script>
        <script>
            var current_page = ${current_page};
            $('.nav-' + current_page).addClass('active');
        </script>
    </body>
</html>
