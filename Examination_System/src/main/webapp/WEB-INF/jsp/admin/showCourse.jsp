<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
	<title>课程信息显示</title>

	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- 引入bootstrap -->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
	<!-- 引入JQuery  bootstrap.js-->
	<script src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/canvas-nest.umd.js"></script>
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
					    	<h1 class="col-md-5">课程名单管理</h1>
							<form class="bs-example bs-example-form col-md-5 col-md-offset-1" role="form" style="margin: 20px 0 10px 0;" action="${pageContext.request.contextPath}/admin/selectCourse" id="form1" method="post">
								<div class="input-group">
									<input type="text" class="form-control" placeholder="请输入姓名" name="findByName">
									<span class="input-group-addon btn" onclick="document.getElementById('form1').submit" id="sub">搜索</span>
								</div>
							</form>
							<button class="btn btn-default col-md-2 " style="margin-top: 20px" onClick="location.href='${pageContext.request.contextPath}/admin/addCourse'">
								添加课程信息
								<sapn class="glyphicon glyphicon-plus"/>
							</button>
						</div>
				    </div>
				    <table class="table table-bordered">
					        <thead>
					            <tr>
									<th>课程号</th>
									<th>课程名称</th>
									<th>授课老师编号</th>
									<th>上课时间</th>
									<th>上课地点</th>
									<th>周数</th>
									<th>课程类型</th>
									<th>学分</th>
									<th>操作</th>
					            </tr>
					        </thead>
					        <tbody>
							<c:forEach  items="${courseList}" var="item">
								<tr>
									<td>${item.courseid}</td>
									<td>${item.coursename}</td>
									<td>${item.teacherid}</td>
									<td>${item.coursetime}</td>
									<td>${item.classroom}</td>
									<td>${item.courseweek}</td>
									<td>${item.coursetype}</td>
									<td>${item.score}</td>
									<td>
                                        <button class="btn btn-default btn-xs btn-info" data-toggle="modal" data-target="#editDialog"
                                                onClick="editCustomer(${item.courseid})">修改</button>
										<button class="btn btn-default btn-xs btn-danger btn-primary" onClick="location.href='${pageContext.request.contextPath}/admin/removeCourse?id=${item.courseid}'">删除</button>
										<!--弹出框-->
									</td>
								</tr>
							</c:forEach>
					        </tbody>
				    </table>
				    <div class="panel-footer">
						<c:if test="${pagingVO != null}">
							<nav style="text-align: center">
								<ul class="pagination">
									<li><a href="${pageContext.request.contextPath}/admin/showCourse?page=${pagingVO.upPageNo}">&laquo;上一页</a></li>
									<li class="active"><a href="">${pagingVO.curentPageNo}</a></li>
									<c:if test="${pagingVO.curentPageNo+1 <= pagingVO.totalCount}">
										<li><a href="${pageContext.request.contextPath}/admin/showCourse?page=${pagingVO.curentPageNo+1}">${pagingVO.curentPageNo+1}</a></li>
									</c:if>
									<c:if test="${pagingVO.curentPageNo+2 <= pagingVO.totalCount}">
										<li><a href="${pageContext.request.contextPath}/admin/showCourse?page=${pagingVO.curentPageNo+2}">${pagingVO.curentPageNo+2}</a></li>
									</c:if>
									<c:if test="${pagingVO.curentPageNo+3 <= pagingVO.totalCount}">
										<li><a href="${pageContext.request.contextPath}/admin/showCourse?page=${pagingVO.curentPageNo+3}">${pagingVO.curentPageNo+3}</a></li>
									</c:if>
									<c:if test="${pagingVO.curentPageNo+4 <= pagingVO.totalCount}">
										<li><a href="${pageContext.request.contextPath}/admin/showCourse?page=${pagingVO.curentPageNo+4}">${pagingVO.curentPageNo+4}</a></li>
									</c:if>
									<li><a href="${pageContext.request.contextPath}/admin/showCourse?page=${pagingVO.totalCount}">最后一页&raquo;</a></li>
								</ul>
							</nav>
						</c:if>
				    </div>
				</div>

			</div>
		</div>
	</div>
	<div class="container" id="footer">
		<div class="row">
			<div class="col-md-12"></div>
		</div>
	</div>


	<!-- 课程编辑对话框 -->
	<div class="modal fade" id="editDialog" tabindex="-1" role="dialog"
		 aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改课程信息</h4>
				</div>
				<div class="modal-body">
                    <form class="form-horizontal" id="edit_course_form">
                        <div class="form-group">
                            <label for="courseID" class="col-sm-2 control-label">课程号</label>
                            <div class="col-sm-10">
                                <input readonly="readonly"  type="number" class="form-control" id="courseID" value="${course.courseid}" name="courseid" placeholder="请输入课程号">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="coursename" class="col-sm-2 control-label">课程名称</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" id="courseName" name="coursename" value="${course.coursename}" placeholder="请输入课程名称">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="teacherId" class="col-sm-2 control-label">授课老师编号</label>
                            <div class="col-sm-10">
                                <select class="form-control" name="teacherid" id="teacherId">
                                    <c:forEach items="${teacherList}" var="item">
                                        <option value="${item.userid}">${item.username}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="courseTime" class="col-sm-2 control-label">上课时间</label>
                            <div class="col-sm-10">
                                <input type="text" id="courseTime" class="form-control" name="coursetime" value="${course.coursetime}" placeholder="请输入上课时间">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="courseAdd" class="col-sm-2 control-label">上课地点</label>
                            <div class="col-sm-10">
                                <input type="text" id="courseAdd" class="form-control" name="classroom" value="${course.classroom}" placeholder="上课地点">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="courseWeek" class="col-sm-2 control-label">周数</label>
                            <div class="col-sm-10">
                                <input type="number" id="courseWeek" class="form-control" name="courseweek" value="${course.courseweek}" placeholder="请输入周数">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="courseType" class="col-sm-2 control-label" name="coursetype">课程的类型：</label>
                            <div class="col-sm-10">
                                <select class="form-control" name="coursetype" id="courseType">
                                    <option value="必修课">必修课</option>
                                    <option value="选修课">选修课</option>
                                    <option value="公共课">公共课</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="college" class="col-sm-2 control-label" name="grade">所属院系</label>
                            <div class="col-sm-10">
                                <select class="form-control" name="collegeid" id="college">
                                    <c:forEach items="${collegeList}" var="item">
                                        <option value="${item.collegeid}">${item.collegename}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="score" class="col-sm-2 control-label">学分：</label>
                            <div class="col-sm-10">
                                <input type="number" id="score" class="form-control" name="score" value="${course.score}" placeholder="请输入学分">
                            </div>
                        </div>

                    </form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="updateCourse()">保存修改</button>
				</div>
			</div>
		</div>
	</div>

</body>
	<script type="text/javascript">

        var cn = new CanvasNest(document.getElementById('content'), {
            color: '255,0,255',
            count: 100,
        });

        function editCustomer(id) {
            $.ajax({
                type:"get",
                url:"${pageContext.request.contextPath}/admin/editCourse?",
                data:{"id":id},
                success:function(data) {
                    $("#courseID").val(data.courseid);
                    $("#teacherId").val(data.teacherid);
                    $("#courseName").val(data.coursename);
                    $("#courseAdd").val(data.classroom);
                    $("#courseTime").val(data.coursetime);
                    $("#courseWeek").val(data.courseweek);
                    $("#courseType").val(data.coursetype);
                    $("#college").val(data.collegeid);
                    $("#score").val(data.score);

                }
            });
        }
        function updateCourse() {
            $.post("${pageContext.request.contextPath}/admin/editCourse",$("#edit_course_form").serialize(),function(data){
                alert("课程信息更新成功！");
                window.location.reload();
            });
        }

		<%--设置菜单中--%>
		$("#nav li:nth-child(1)").addClass("active")
        <c:if test="${pagingVO != null}">
        if (${pagingVO.curentPageNo} == ${pagingVO.totalCount}) {
            $(".pagination li:last-child").addClass("disabled")
        };

        if (${pagingVO.curentPageNo} == ${1}) {
            $(".pagination li:nth-child(1)").addClass("disabled")
        };
        </c:if>

        function confirmd() {
            var msg = "您真的确定要删除吗？！";
            if (confirm(msg)==true){
                return true;
            }else{
                return false;
            }
        }

        $("#sub").click(function () {
            $("#form1").submit();
        });
	</script>
</html>