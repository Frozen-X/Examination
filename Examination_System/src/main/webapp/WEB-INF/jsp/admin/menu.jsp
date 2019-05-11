<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 引入bootstrap -->
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
<!-- 引入JQuery  bootstrap.js-->
<script src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<div class="col-md-2">
    <ul class="nav nav-pills nav-stacked" id="nav">
        <li><a href="${pageContext.request.contextPath}/admin/showCourse">课程管理<span class="badge pull-right"></span></a></li>
        <li><a href="${pageContext.request.contextPath}/admin/showStudent">学生管理<span class="badge pull-right"></span></a></li>
        <li><a href="${pageContext.request.contextPath}/admin/showTeacher">教师管理<span class="badge pull-right"></span></a></li>
        <li><a href="${pageContext.request.contextPath}/admin/userPasswordRest">账号密码重置<sapn class="glyphicon glyphicon-repeat pull-right" /></a></li>
        <li><a href="${pageContext.request.contextPath}/admin/passwordRest">修改密码<sapn class="glyphicon glyphicon-pencil pull-right" /></a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp">退出系统<sapn class="glyphicon glyphicon-log-out pull-right" /></a></li>
    </ul>
</div>