<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: xiao
  Date: 2019/3/10
  Time: 22:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <!-- 引入bootstrap -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <!-- 引入JQuery  bootstrap.js-->
    <script src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    <!-- 引入 echarts.js -->
    <script src="${pageContext.request.contextPath}/js/echarts.min.js"></script>
    <!-- 引入 dark 主题 -->
    <script src="js/dark.js"></script>
    <title>统计学生成绩</title>
</head>
<body>
<!-- 顶栏 -->
<jsp:include page="top.jsp"></jsp:include>
<!-- 中间主体 -->
<div class="container" id="content">
    <div class="row">
        <jsp:include page="menu.jsp"></jsp:include>
        <div class="col-md-10">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <h1 class="col-md-5">学生成绩统计</h1>
                        <button class="btn btn-default btn-danger col-md-1 btn-info " style="margin-top: 20px" onClick="location.href='${pageContext.request.contextPath}/teacher/statistic?id=${id}&type=1'">柱状图</button>
                        <button class="btn btn-default btn-danger col-md-1 btn-info col-md-offset-1" style="margin-top: 20px" onClick="location.href='${pageContext.request.contextPath}/teacher/statistic?id=${id}&type=2'">饼状图</button>

                    </div>
                </div>

                <!-- 为ECharts准备一个具备大小（宽高）的Dom -->
                <div id="main" style="width: 700px;height:400px;"></div>
            </div>

        </div>
    </div>
</div>
<div class="container" id="footer">
    <div class="row">
        <div class="col-md-12"></div>
    </div>
</div>

<script type="text/javascript">
    // 基于准备好的dom，初始化echarts实例
    var myChart = echarts.init(document.getElementById('main'));

    var option = {
        title : {
            text: '学生成绩统计',
            subtext: '成绩分布',
            x:'center'
        },
        tooltip : {
            trigger: 'item',
            formatter: "{a} <br/>{b} : {c} ({d}%)"
        },
        legend: {
            orient: 'vertical',
            left: 'left',
            data: ['不及格','60~69','70~79','80~89','90分以上']
        },
        series : [
            {
                name: '人数占比',
                type: 'pie',
                radius : '55%',
                center: ['50%', '60%'],
                data:[
                    {value:${count[0]}, name:'不及格'},
                    {value:${count[1]}, name:'60~69'},
                    {value:${count[2]}, name:'70~79'},
                    {value:${count[3]}, name:'80~89'},
                    {value:${count[4]}, name:'90分以上'}

                ],
                itemStyle: {
                    emphasis: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                }
            }
        ]
    };



    // 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);
</script>
</body>
</html>
