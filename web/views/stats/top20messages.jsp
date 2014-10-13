<%@include file="/partials/header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
    <div class="col-md-12" style="margin-bottom: 50px;">
        <h2><small>Top 20 publicações</small></h2>
    </div>
    
    <div class="col-md-4 col-center">
        <canvas id="canvas" height="400" width="700"></canvas>
    </div>
    
    
    <script>
        var randomScalingFactor = function(){ return Math.round(Math.random()*100)};

	var barChartData = {
            
		labels : [
                    <c:forEach items="${messages}" var="m">
                        "${fn:escapeXml(m.body)}",
                    </c:forEach>
                ],
		datasets : [
			{
				fillColor : "rgba(220,220,220,0.5)",
				strokeColor : "rgba(220,220,220,0.8)",
				highlightFill: "rgba(220,220,220,0.75)",
				highlightStroke: "rgba(220,220,220,1)",
				data : [
                                    <c:forEach items="${messages}" var="m">
                                        "${m.id}",
                                    </c:forEach>
                                ]
			}
		]

	}
	window.onload = function(){
		var ctx = document.getElementById("canvas").getContext("2d");
		window.myBar = new Chart(ctx).Bar(barChartData, {
			responsive : true
		});
	}
    </script>
    
    
<%@include file="/partials/footer.jsp" %>