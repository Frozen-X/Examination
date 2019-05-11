package com.system.controller;

import com.system.exception.CustomException;
import com.system.po.*;
import com.system.service.CourseService;
import com.system.service.SelectedCourseService;
import com.system.service.StudentService;
import com.system.service.TeacherService;
import com.system.service.impl.StudentServiceImpl;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by Housheng_Xiao on 2018/11/27
 */

@Controller
@RequestMapping(value = "/teacher")
public class TeacherController {

    @Resource(name = "teacherServiceImpl")
    private TeacherService teacherService;

    @Resource(name = "courseServiceImpl")
    private CourseService courseService;

    @Resource(name = "selectedCourseServiceImpl")
    private SelectedCourseService selectedCourseService;

    // 显示我的课程
    @RequestMapping(value = "/showCourse")
    public String stuCourseShow(Model model) throws Exception {

        Subject subject = SecurityUtils.getSubject();
        String username = (String) subject.getPrincipal();

        List<CourseCustom> list = courseService.findByTeacherID(Integer.parseInt(username));
        model.addAttribute("courseList", list);

        return "teacher/showCourse";
    }

    // 显示成绩
    @RequestMapping(value = "/gradeCourse")
    public String gradeCourse(Integer id, Model model) throws Exception {
        if (id == null) {
            return "";
        }
        model.addAttribute("id",id);
        List<SelectedCourseCustom> list = selectedCourseService.findByCourseID(id);
        model.addAttribute("selectedCourseList", list);
        return "teacher/showGrade";
    }

    // 打分
    @RequestMapping(value = "/mark", method = {RequestMethod.GET})
    public String markUI(SelectedCourseCustom scc, Model model) throws Exception {

        SelectedCourseCustom selectedCourseCustom = selectedCourseService.findOne(scc);

        model.addAttribute("selectedCourse", selectedCourseCustom);

        return "teacher/mark";
    }

    // 打分
    @RequestMapping(value = "/mark", method = {RequestMethod.POST})
    public String mark(SelectedCourseCustom scc) throws Exception {

        selectedCourseService.updataOne(scc);

        return "redirect:/teacher/gradeCourse?id="+scc.getCourseid();
    }

    //修改密码
    @RequestMapping(value = "/passwordRest")
    public String passwordRest() throws Exception {
        return "teacher/passwordRest";
    }

    //统计学生成绩
    @RequestMapping( value = "/statistic" )
    public String statistic(Integer id, Model model, Integer type) throws Exception {

        if (id == null) {
            return "";
        }
        model.addAttribute("id",id);
        List<Integer> list = selectedCourseService.findAll(id);

        //model.addAttribute("selectedCourseList", list);
        int[] count = {0, 0, 0, 0, 0};
        for(Integer score : list) {
            if(score >= 90) {
                count[4]++;
            } else if(score >= 80) {
                count[3]++;
            } else if(score >= 70) {
                count[2]++;
            } else if(score >= 60) {
                count[1]++;
            } else {
                count[0]++;
            }
        }
        model.addAttribute("count",count);
        if(type == 1) {
            return "teacher/chart";
        } else {
            return "teacher/chart2";
        }


    }

}
