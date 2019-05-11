<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
	<title>教师信息显示</title>

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

	<!-- 中间主体 --><jsp:include page="top.jsp"></jsp:include>
	<div class="container" id="content">
		<div class="row">
			<jsp:include page="menu.jsp"></jsp:include>
			<div class="col-md-10">
				<div class="panel panel-default">
				    <div class="panel-heading">
						<div class="row">
					    	<h1 class="col-md-4">教师名单管理</h1>
							<form class="bs-example bs-example-form col-md-4 col-md-offset-1" role="form" style="margin: 20px 0 10px 0;" action="${pageContext.request.contextPath}/admin/selectTeacher" id="form1" method="post">
								<div class="input-group">
									<input type="text" class="form-control" placeholder="请输入姓名" name="findByName">
									<span class="input-group-addon btn" onclick="document.getElementById('form1').submit" id="sub">搜索</span>
								</div>
							</form>
							<button class="btn btn-default col-md-1 btn-info" style="margin-top: 20px" data-toggle="modal" data-target="#insertExcelDialog">导入</button>

							<button class="btn btn-default col-md-1 btn-info" style="margin-top: 20px" onClick="location.href='${pageContext.request.contextPath}/admin/exportTeacher'">导出</button>


							<button class="btn btn-default col-md-2" style="margin-top: 20px" onClick="location.href='${pageContext.request.contextPath}/admin/addTeacher'">
								添加教师信息
								<sapn class="glyphicon glyphicon-plus"/>
							</button>

						</div>
				    </div>
				    <table class="table table-bordered">
					        <thead>
					            <tr>
									<th>教师编号</th>
									<th>姓名</th>
									<th>性别</th>
									<th>出生年份</th>
									<th>学历</th>
									<th>职称</th>
									<th>入职年份</th>
									<th>学院</th>
									<th>操作</th>
					            </tr>
					        </thead>
					        <tbody>
							<c:forEach  items="${teacherList}" var="item">
								<tr>
									<td>${item.userid}</td>
									<td>${item.username}</td>
									<td>${item.sex}</td>
									<td><fmt:formatDate value="${item.birthyear}" dateStyle="medium" /></td>
									<td>${item.degree}</td>
									<td>${item.title}</td>
									<td><fmt:formatDate value="${item.grade}" dateStyle="medium" /></td>
									<td>${item.collegeName}</td>
									<td>
										<%--<button class="btn btn-default btn-xs btn-info" onClick="location.href='${pageContext.request.contextPath}/admin/editTeacher?id=${item.userid}'">修改</button>--%>

										<button class="btn btn-default btn-xs btn-info" data-toggle="modal" data-target="#editDialog"
												onClick="editCustomer(${item.userid})">修改</button>
										<button class="btn btn-default btn-xs btn-danger btn-primary" onClick="location.href='${pageContext.request.contextPath}/admin/removeTeacher?id=${item.userid}'">删除</button>
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
									<li><a href="${pageContext.request.contextPath}/admin/showTeacher?page=${pagingVO.upPageNo}">&laquo;上一页</a></li>
									<li class="active"><a href="">${pagingVO.curentPageNo}</a></li>
									<c:if test="${pagingVO.curentPageNo+1 <= pagingVO.totalCount}">
										<li><a href="${pageContext.request.contextPath}/admin/showTeacher?page=${pagingVO.curentPageNo+1}">${pagingVO.curentPageNo+1}</a></li>
									</c:if>
									<c:if test="${pagingVO.curentPageNo+2 <= pagingVO.totalCount}">
										<li><a href="${pageContext.request.contextPath}/admin/showTeacher?page=${pagingVO.curentPageNo+2}">${pagingVO.curentPageNo+2}</a></li>
									</c:if>
									<c:if test="${pagingVO.curentPageNo+3 <= pagingVO.totalCount}">
										<li><a href="${pageContext.request.contextPath}/admin/showTeacher?page=${pagingVO.curentPageNo+3}">${pagingVO.curentPageNo+3}</a></li>
									</c:if>
									<c:if test="${pagingVO.curentPageNo+4 <= pagingVO.totalCount}">
										<li><a href="${pageContext.request.contextPath}/admin/showTeacher?page=${pagingVO.curentPageNo+4}">${pagingVO.curentPageNo+4}</a></li>
									</c:if>
									<li><a href="${pageContext.request.contextPath}/admin/showTeacher?page=${pagingVO.totalCount}">最后一页&raquo;</a></li>
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

    <!-- 教师编辑对话框 -->
    <div class="modal fade" id="editDialog" tabindex="-1" role="dialog"
         aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改教师信息</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" id="edit_teacher_form">
                        <div class="form-group ">
                            <label for="userID" class="col-sm-2 control-label" >工号</label>
                            <div class="col-sm-10">
                                <input readonly="readonly" type="number" class="form-control" id="userID" name="userid" placeholder="请输入学号">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="userName" class="col-sm-2 control-label">姓名</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" id="userName" name="username" placeholder="请输入姓名" >
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="sex" class="col-sm-2 control-label">性别</label>
                            <div class="col-sm-10">
                                <label class="checkbox-inline">
                                    <input type="radio" name="sex" value="男" id="sex" checked/>男
                                </label>
                                <label class="checkbox-inline">
                                    <input type="radio" name="sex" value="女" />女
                                </label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="birthYear" class="col-sm-2 control-label">出生年份</label>
                            <div class="col-sm-10">
                                <input type="date" id="birthYear" name="birthyear" value="123"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="degree" class="col-sm-2 control-label" name="degree">学历：</label>
                            <div class="col-sm-10">
                                <select class="form-control" name="degree" id="degree">
                                    <option value="本科">本科</option>
                                    <option value="硕士">硕士</option>
                                    <option value="博士">博士</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="title" class="col-sm-2 control-label" name="title" >职称：</label>
                            <div class="col-sm-10">
                                <select class="form-control" name="title" id="title">
                                    <option value="普通教师">普通教师</option>
                                    <option value="助教">助教</option>
                                    <option value="讲师">讲师</option>
                                    <option value="副教授">副教授</option>
                                    <option value="教授">教授</option>
                                </select>
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="gradeYear" class="col-sm-2 control-label" name="grade">入职时间</label>
                            <div class="col-sm-10">
                                <input type="date" id="gradeYear" value="<fmt:formatDate value="${teacher.grade}" dateStyle="medium" pattern="yyyy-MM-dd" />" name="grade"/>
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

                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" onclick="updateTeacher()">保存修改</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 文件上传对话框 -->
	<div class="modal fade" id="insertExcelDialog" tabindex="-1" role="dialog"
		 aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">从Excel导入教师信息</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="insert_teacher_form" enctype="multipart/form-data" method="post"
						  action="${pageContext.request.contextPath}/admin/importTeacher">
						<div class="form-group ">
							<label class="col-sm-2 control-label" >选择文件</label>
							<div class="col-sm-10">
								<input type="file" class="form-control" name="upfile"  />
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">

					<button type="submit" class="btn btn-primary" onclick="insertExcelStudent()">导入</button>
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
		$("#nav li:nth-child(3)").addClass("active")

        <c:if test="${pagingVO != null}">
        if (${pagingVO.curentPageNo} == ${pagingVO.totalCount}) {
            $(".pagination li:last-child").addClass("disabled")
        };

        if (${pagingVO.curentPageNo} == ${1}) {
            $(".pagination li:nth-child(1)").addClass("disabled")
        };
        </c:if>

        function editCustomer(id) {
            $.ajax({
                type:"get",
                url:"${pageContext.request.contextPath}/admin/editTeacher?",
                data:{"id":id},
                success:function(data) {
                    $("#userID").val(data.userid);
                    $("#userName").val(data.username);
                    $("#sex").val(data.sex);
                    $("#birthYear").val(data.birthyear);
                    $("#degree").val(data.degree);
                    $("#title").val(data.title);
                    $("#gradeYear").val(data.grade);
                    $("#college").val(data.collegeid);
                }
            });
        }

        function updateTeacher() {
            $.post("${pageContext.request.contextPath}/admin/editTeacher",$("#edit_teacher_form").serialize(),function(data){
                alert("教师信息更新成功！");
                window.location.reload();
            });
        }

        function insertExcelStudent() {
            $("#insert_teacher_form").submit();
            alert("导入成功！");
        }

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