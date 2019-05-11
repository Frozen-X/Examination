package com.system.mapper;

import com.system.po.PagingVO;
import com.system.po.Student;
import com.system.po.StudentCustom;

import java.util.List;

/**
 * Created by Housheng_Xiao on 2018/12/08.
 */
public interface StudentMapperCustom {

    //分页查询学生信息
    List<StudentCustom> findByPaging(PagingVO pagingVO) throws Exception;

    //查询学生信息，和其选课信息
    StudentCustom findStudentAndSelectCourseListById(Integer id) throws Exception;

    //通过excel批量导入学生信息
    //void insertByExcel(List<Student> studentList) throws Exception;

    // 查询所有学生
    List<Student> findAll() throws Exception;
}
