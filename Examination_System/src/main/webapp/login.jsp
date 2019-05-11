<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<head>
	<title></title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- 引入bootstrap -->
	<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/font-awesome.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/zzsc.css">
	<!-- 引入JQuery  bootstrap.js-->
	<script src="js/jquery-3.2.1.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<!-- 引入Jquery -->
	<script src="${pageContext.request.contextPath}/js/jquery-1.11.3.min.js"></script>
	<style type="text/css">
		.form-bg{
			padding: 2em 0;
		}
		.form-horizontal{
			background: #fff;
			padding-bottom: 40px;
			border-radius: 15px;
			text-align: center;
		}
		.form-horizontal .heading{
			display: block;
			font-size: 35px;
			font-weight: 700;
			padding: 35px 0;
			border-bottom: 1px solid #f0f0f0;
			margin-bottom: 30px;
		}
		.form-horizontal .form-group{
			padding: 0 40px;
			margin: 0 0 25px 0;
			position: relative;
		}
		.form-horizontal .form-control{
			background: #f0f0f0;
			border: none;
			border-radius: 20px;
			box-shadow: none;
			padding: 0 20px 0 45px;
			height: 40px;
			transition: all 0.3s ease 0s;
		}
		.form-horizontal .form-control:focus{
			background: #e0e0e0;
			box-shadow: none;
			outline: 0 none;
		}
		.form-horizontal .form-group i{
			position: absolute;
			top: 12px;
			left: 60px;
			font-size: 17px;
			color: #c8c8c8;
			transition : all 0.5s ease 0s;
		}
		.form-horizontal .form-control:focus + i{
			color: #00b4ef;
		}
		.form-horizontal .fa-question-circle{
			display: inline-block;
			position: absolute;
			top: 12px;
			right: 60px;
			font-size: 20px;
			color: #808080;
			transition: all 0.5s ease 0s;
		}
		.form-horizontal .fa-question-circle:hover{
			color: #000;
		}
		.form-horizontal .main-checkbox{
			float: left;
			width: 20px;
			height: 20px;
			background: #11a3fc;
			border-radius: 50%;
			position: relative;
			margin: 5px 0 0 5px;
			border: 1px solid #11a3fc;
		}
		.form-horizontal .main-checkbox label{
			width: 20px;
			height: 20px;
			position: absolute;
			top: 0;
			left: 0;
			cursor: pointer;
		}
		.form-horizontal .main-checkbox label:after{
			content: "";
			width: 10px;
			height: 5px;
			position: absolute;
			top: 5px;
			left: 4px;
			border: 3px solid #fff;
			border-top: none;
			border-right: none;
			background: transparent;
			opacity: 0;
			-webkit-transform: rotate(-45deg);
			transform: rotate(-45deg);
		}
		.form-horizontal .main-checkbox input[type=checkbox]{
			visibility: hidden;
		}
		.form-horizontal .main-checkbox input[type=checkbox]:checked + label:after{
			opacity: 1;
		}
		.form-horizontal .text{
			float: left;
			margin-left: 7px;
			line-height: 20px;
			padding-top: 5px;
			text-transform: capitalize;
		}
		.form-horizontal .btn{
			float: right;
			font-size: 14px;
			color: #fff;
			background: #00b4ef;
			border-radius: 30px;
			padding: 10px 25px;
			border: none;
			text-transform: capitalize;
			transition: all 0.5s ease 0s;
		}
		@media only screen and (max-width: 479px){
			.form-horizontal .form-group{
				padding: 0 25px;
			}
			.form-horizontal .form-group i{
				left: 45px;
			}
			.form-horizontal .btn{
				padding: 10px 20px;
			}
		}
	.error {
		color: red;
		font-size: 13px;
	}
	#codeId{
		position: relative;
		margin-left: 100px;
	}
	#pwdId{
		position: relative;
		margin-left: 100px;
	}


	</style>
    <script type="text/javascript">


        function checkCode(){
            //获取用户输入的登录名
            var username = $("#userID").val();
            //进行判断，说明没有输入用户名
            if(username.trim() == ""){
                //给提示
                $("#codeId").addClass("error");
                $("#codeId").html("用户ID不能为空");
            } else {
                // 登录名不为空，ajax请求，验证
                var url = "${pageContext.request.contextPath}/check";
                var param = {"username": username};

                $.post(url, param, function(data){

                    //操作data,进行判断
                    //alert(data);
                    if( data == "no") {
                        //提示
                        $("#codeId").addClass("error");
                        $("#codeId").html("用户不存在");
                    } else {
                        $("#codeId").removeClass("error");
                        $("#codeId").empty();
                        // $("#codeId").html("可以登录");
                    }
                });
            }
        }
        function checkPwd(){
            //获取用户输入的登录名
            var username = $("#userID").val();
            var password = $("#password").val();

			// 登录名不为空，ajax请求，验证
			var url = "${pageContext.request.contextPath}/checkPwd";
			var param = {"username": username,"password":password};

			$.post(url, param, function(data){

				//操作data,进行判断
				//alert(data);
				if( data == "no") {
					//提示
					$("#pwdId").addClass("error");
					$("#pwdId").html("密码错误");
				} else {
					$("#pwdId").removeClass("error");
					$("#pwdId").empty();
					// $("#pwdId").html("密码正确");
				}
			});



        }
        // 可以阻止表单的提交
        function checkForm(){
            checkCode();
            // 先让校验名称的方法先执行以下
            checkPwd();
            // 获取error的数量，如果数量 > 0，说明存在错误，不能提交表单
            if($(".error").size() > 0){
                return false;
            }
        }
    </script>
</head>
<body>

<div class="demo form-bg">
    <div class="container">
        <div class="row">
            <div class="col-md-offset-3 col-md-6">
                <form class="form-horizontal" action="${pageContext.request.contextPath}/login" onsubmit="return checkForm()" method="post">
                    <span class="heading">教务管理系统</span>
                    <div class="form-group">
                        <input type="text" class="form-control" id="userID" name="username" onblur="checkCode()" placeholder="用户名" >
                        <i class="fa fa-user"></i>
                        <span id="codeId" ></span>
                    </div>
                    <div class="form-group help">
                        <input type="password" class="form-control" id="password" placeholder="请输入密码" name="password" onblur="checkPwd()">
                        <i class="fa fa-lock"></i>
                        <span id="pwdId" ></span>
                    </div>
                    <div class="form-group">
                        <div class="main-checkbox">
                            <input type="checkbox" value="None" id="checkbox1" name="check"/>
                            <label for="checkbox1"></label>
                        </div>
                        <span class="text">记住我</span>
                        <button type="submit" class="btn btn-default">立刻登录</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
	<%--<div class="container" id="top">
		<div class="row" style="margin-top: 280px; ">
			<div class="col-md-4"></div>
			<div class="col-md-4" id="login-box">
				<form class="form-horizontal" role="form" action="${pageContext.request.contextPath}/login" id="from1" method="post" onsubmit="return checkForm()">
				  <div class="form-group">
				    <label for="userID" class="col-sm-3 control-label">用户id</label>
				    <div class="col-sm-9">
				      <input type="text" class="form-control" id="userID" placeholder="请输入名字" name="username" onblur="checkCode()">
				    </div>

					  <span id="codeId" ></span>

				  </div>
				  <div class="form-group">
				    <label for="password" class="col-sm-3 control-label">密码</label>
				    <div class="col-sm-9">
				      <input type="password" class="form-control" id="password" placeholder="请输入密码" name="password" onblur="checkPwd()">
				    </div>
					  <span id="pwdId" ></span>
				  </div>
				  &lt;%&ndash;<div class="form-group">
				    <div class="col-sm-offset-2 col-sm-10">
				      <div class="checkbox">
				        <label class="checkbox-inline">
							<input type="radio" name="role" value="1" checked>管理员
						</label>
						<label class="checkbox-inline">
							<input type="radio" name="role" value="2">老师
						</label>
						<label class="checkbox-inline">
							<input type="radio" name="role" value="3">学生
						</label>
				      </div>
				    </div>
				  </div>&ndash;%&gt;
				  <div class="form-group pull-right" style="margin-right: 15px;">
				    <div class="col-sm-offset-2 col-sm-10">
				      <button type="submit" class="btn btn-default btn-info" >登录</button>
				    </div>
				  </div>
				</form>
			</div>
			<div class="col-md-4"></div>
		</div>		
	</div>--%>
</body>

</html>

