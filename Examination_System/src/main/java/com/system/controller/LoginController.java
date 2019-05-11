package com.system.controller;

import com.system.po.QueryVo;
import com.system.po.Userlogin;
import com.system.service.UserloginService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.List;

/**
 * Created by Housheng_Xiao on 2018/11/27
 */
@Controller
public class LoginController {

    @Resource(name = "userloginServiceImpl")
    private UserloginService userloginService;

    @RequestMapping(value = "/check", method = {RequestMethod.POST})
    @ResponseBody
    public void checkCode(String username,HttpServletResponse response) throws Exception{
        //System.out.println("校验");
        //System.out.println(username);
        //调用业务层，查询
        Userlogin u = userloginService.checkCode(username);

        //获取输出流
        PrintWriter out = response.getWriter();
        //进行判断
        if(u == null) {
            //说明：登录名不存在，不能登录
            out.print("no");
        } else {
            out.print("yes");
        }
        //return "/login";
    }

    @RequestMapping(value = "/checkPwd", method = {RequestMethod.POST})
    @ResponseBody
    public void checkPwd(String username, String password, HttpServletResponse response) throws Exception{
        QueryVo queryVo = new QueryVo();
        Userlogin u = new Userlogin();
        u.setUsername(username);
        u.setPassword(password);
        queryVo.setUserlogin(u);
        //调用业务层，查询
        List<Userlogin> list = (List)userloginService.findUserByQueryVo(queryVo);
        //Userlogin u = userloginService.checkPwd(username,password);
        //u = userloginService.checkPwd();
        //System.out.println(list);
        //获取输出流
        PrintWriter out = response.getWriter();
        //进行判断
        if(list != null) {
            //说明：登录名和密码匹配，可以登录
            out.print("yes");
        } else {
            out.print("no");
        }
    }

    //登录跳转
    @RequestMapping(value = "/login", method = {RequestMethod.GET})
    public String loginUI() throws Exception {
        return "../../login";
    }

    //登录表单处理
    @RequestMapping(value = "/login", method = {RequestMethod.POST})
    public String login(Userlogin userlogin) throws Exception {
        //System.out.print("登陆了");
        //Shiro实现登录
        UsernamePasswordToken token = new UsernamePasswordToken(userlogin.getUsername(),
                userlogin.getPassword());
        Subject subject = SecurityUtils.getSubject();

        //如果获取不到用户名就是登录失败，但登录失败的话，会直接抛出异常
        subject.login(token);

        if (subject.hasRole("admin")) {
            return "redirect:/admin/showStudent";
        } else if (subject.hasRole("teacher")) {
            return "redirect:/teacher/showCourse";
        } else if (subject.hasRole("student")) {
            return "redirect:/student/showCourse";
        }else{

        }
        return "/login";
    }

}
