package com.system.mapper;

import com.system.po.PagingVO;
import com.system.po.Student;
import com.system.po.Teacher;
import com.system.po.TeacherCustom;

import java.util.List;

/**
 * Created by Housheng_xiao on 2018/12/18.
 */
public interface TeacherMapperCustom {

    //分页查询老师信息
    List<TeacherCustom> findByPaging(PagingVO pagingVO) throws Exception;

    // 查询所有教师
    List<Teacher> findAll() throws Exception;
}
