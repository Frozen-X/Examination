<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
	<title>学生信息显示</title>

	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- 引入bootstrap -->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
	<!-- 引入JQuery  bootstrap.js-->

	<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    <!-- jQuery -->
    <script src="${pageContext.request.contextPath}/js/jquery-1.11.3.min.js"></script>
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
					    	<h1 class="col-md-4">学生名单管理</h1>
							<form class="bs-example bs-example-form col-md-4 col-md-offset-1" role="form" style="margin: 20px 0 10px 0;" action="${pageContext.request.contextPath}/admin/selectStudent" id="form1" method="post">
								<div class="input-group">
									<input type="text" class="form-control" placeholder="请输入姓名" name="findByName">
									<span class="input-group-addon btn" id="sub">搜索</span>
								</div>
							</form>

                            <%--<button class="btn btn-default col-md-2 btn-info " style="margin-top: 20px" onclick="exportExcel()">导入学生信息</button>--%>
                            <button class="btn btn-default col-md-1 btn-info" style="margin-top: 20px" data-toggle="modal" data-target="#insertExcelDialog">导入</button>

                            <button class="btn btn-default col-md-1 btn-info" style="margin-top: 20px" onClick="location.href='${pageContext.request.contextPath}/admin/export'">导出</button>


                            <button class="btn btn-default col-md-2 " style="margin-top: 20px" onClick="location.href='${pageContext.request.contextPath}/admin/addStudent'">
								添加用户信息
								<sapn class="glyphicon glyphicon-plus"/>
							</button>

						</div>
				    </div>
				    <table class="table table-bordered">
					        <thead>
					            <tr>
					                <th>学号</th>
				  					<th>姓名</th>
				  					<th>性别</th>
				  					<th>出生年份</th>
				  					<th>入学时间</th>
				  					<th>学院</th>
				  					<th>操作</th>
					            </tr>
					        </thead>
					        <tbody>
							<c:forEach  items="${studentList}" var="item">
								<tr>
									<td>${item.userid}</td>
									<td>${item.username}</td>
									<td>${item.sex}</td>
									<td><fmt:formatDate value="${item.birthyear}" dateStyle="medium" /></td>
									<td><fmt:formatDate value="${item.grade}" dateStyle="medium" /></td>
									<td>${item.collegeName}</td>
									<td>
										<button class="btn btn-default btn-xs btn-info" data-toggle="modal" data-target="#editDialog"
                                                onClick="editCustomer(${item.userid})">修改</button>
										<button class="btn btn-default btn-xs btn-danger btn-primary" onClick="location.href='${pageContext.request.contextPath}/admin/removeStudent?id=${item.userid}'">删除</button>
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
									<li><a href="${pageContext.request.contextPath}/admin/showStudent?page=${pagingVO.upPageNo}">&laquo;上一页</a></li>
									<li class="active"><a href="">${pagingVO.curentPageNo}</a></li>
									<c:if test="${pagingVO.curentPageNo+1 <= pagingVO.totalCount}">
										<li><a href="${pageContext.request.contextPath}/admin/showStudent?page=${pagingVO.curentPageNo+1}">${pagingVO.curentPageNo+1}</a></li>
									</c:if>
									<c:if test="${pagingVO.curentPageNo+2 <= pagingVO.totalCount}">
										<li><a href="${pageContext.request.contextPath}/admin/showStudent?page=${pagingVO.curentPageNo+2}">${pagingVO.curentPageNo+2}</a></li>
									</c:if>
									<c:if test="${pagingVO.curentPageNo+3 <= pagingVO.totalCount}">
										<li><a href="${pageContext.request.contextPath}/admin/showStudent?page=${pagingVO.curentPageNo+3}">${pagingVO.curentPageNo+3}</a></li>
									</c:if>
									<c:if test="${pagingVO.curentPageNo+4 <= pagingVO.totalCount}">
										<li><a href="${pageContext.request.contextPath}/admin/showStudent?page=${pagingVO.curentPageNo+4}">${pagingVO.curentPageNo+4}</a></li>
									</c:if>
									<li><a href="${pageContext.request.contextPath}/admin/showStudent?page=${pagingVO.totalCount}">最后一页&raquo;</a></li>
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

    <!-- 学生编辑对话框 -->
    <div class="modal fade" id="editDialog" tabindex="-1" role="dialog"
         aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改学生信息</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" id="edit_student_form">
                        <div class="form-group ">
                            <label for="userID" class="col-sm-2 control-label" >学号</label>
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
                            <label for="gradeYear" class="col-sm-2 control-label" name="grade">入学时间</label>
                            <div class="col-sm-10">
                                <input type="date" id="gradeYear" value="<fmt:formatDate value="${student.grade}" dateStyle="medium" pattern="yyyy-MM-dd" />" name="grade"/>
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
                    <button type="button" class="btn btn-primary" onclick="updateStudent()">保存修改</button>
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
                    <h4 class="modal-title" id="myModalLabel2">从Excel导入学生信息</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" id="insert_student_form" enctype="multipart/form-data" method="post"
                          action="${pageContext.request.contextPath}/admin/import">
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

        function editCustomer(id) {
            $.ajax({
                type:"get",
                url:"${pageContext.request.contextPath}/admin/editStudent?",
                data:{"id":id},
                success:function(data) {
                    $("#userID").val(data.userid);
                    $("#userName").val(data.username);
                    $("#sex").val(data.sex);
                    $("#birthYear").val(data.birthyear);
                    $("#gradeYear").val(data.grade);
                    $("#college").val(data.collegeid);
                }
            });
        }
        function updateStudent() {
            $.post("${pageContext.request.contextPath}/admin/editStudent",$("#edit_student_form").serialize(),function(data){
                alert("学生信息更新成功！");
                window.location.reload();
            });
        }

        <%--function insertExcelStudent() {--%>
            <%--$.post("${pageContext.request.contextPath}/admin/import",$("#insert_student_form").serialize(),function(data){--%>
                <%--alert("学生信息导入成功！");--%>
                <%--window.location.reload();--%>
            <%--});--%>
        <%--}--%>
        function insertExcelStudent() {
            $("#insert_student_form").submit();
            alert("导入成功！");
        }

		$("#nav li:nth-child(2)").addClass("active");

        function confirmd() {
            var msg = "您真的确定要删除吗？！";
            if (confirm(msg)==true){
                return true;
            }else{
                return false;
            }
        };

        $("#sub").click(function () {
            $("#form1").submit();
        });

        <c:if test="${pagingVO != null}">
			if (${pagingVO.curentPageNo} == ${pagingVO.totalCount}) {
				$(".pagination li:last-child").addClass("disabled")
			};

			if (${pagingVO.curentPageNo} == ${1}) {
				$(".pagination li:nth-child(1)").addClass("disabled")
			};
        </c:if>
	</script>
</html>