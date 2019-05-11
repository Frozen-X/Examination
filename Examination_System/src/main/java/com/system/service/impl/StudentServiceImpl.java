package com.system.service.impl;

import com.system.mapper.CollegeMapper;
import com.system.mapper.StudentMapper;
import com.system.mapper.StudentMapperCustom;
import com.system.mapper.UserloginMapper;
import com.system.po.*;
import com.system.service.StudentService;
import com.system.service.UserloginService;
import com.system.utils.ExcelUtil;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.shiro.web.servlet.ShiroHttpServletRequest;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.beans.IntrospectionException;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Student
 */
@Service
public class StudentServiceImpl implements StudentService {

    //使用spring 自动注入
    @Autowired
    private StudentMapperCustom studentMapperCustom;

    @Autowired
    private StudentMapper studentMapper;

    @Autowired
    private CollegeMapper collegeMapper;

    @Autowired
    private UserloginMapper userloginMapper;

    public XSSFWorkbook exportExcelInfo() throws Exception {
        //根据条件查询数据，把数据装载到一个list中
        List<Student> list = studentMapperCustom.findAll();

        List<ExcelBean> excel=new ArrayList<ExcelBean>();
        Map<Integer,List<ExcelBean>> map=new LinkedHashMap<Integer,List<ExcelBean>>();
        XSSFWorkbook xssfWorkbook=null;
        //设置标题栏
        excel.add(new ExcelBean("学号","userid",0));
        excel.add(new ExcelBean("姓名","username",0));
        excel.add(new ExcelBean("性别","sex",0));
        excel.add(new ExcelBean("出生年月","birthyear",0));
        excel.add(new ExcelBean("入学时间","grade",0));
        excel.add(new ExcelBean("所属院系","collegeid",0));

        map.put(0, excel);
        String sheetName = "学生信息";
        //调用ExcelUtil的方法
        xssfWorkbook = ExcelUtil.createExcelFile(Student.class, list, map, sheetName);
        return xssfWorkbook;
        
    }


    public String importExcelInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ShiroHttpServletRequest shiroRequest = (ShiroHttpServletRequest) request;
//        CommonsMultipartResolver commonsMultipartResolver = new CommonsMultipartResolver();
//        MultipartHttpServletRequest multipartRequest = commonsMultipartResolver.resolveMultipart((HttpServletRequest) shiroRequest.getRequest());

        MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;

        MultipartFile file = multipartRequest.getFile("upfile");
        if(file.isEmpty()){
            try {
                throw new Exception("文件不存在！");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        InputStream in =null;
        try {
            in = file.getInputStream();
        } catch (IOException e) {
            e.printStackTrace();
        }

        List<List<Object>> listob = null;
        try {
            listob = new ExcelUtil().getBankListByExcel(in,file.getOriginalFilename());
        } catch (Exception e) {
            e.printStackTrace();
        }

        //遍历listob中的数据，把数据放到List中
        for (int i = 0; i < listob.size(); i++) {
            List<Object> lo = listob.get(i);
            StudentCustom vo = new StudentCustom();

            vo.setUserid(Integer.valueOf(String.valueOf(lo.get(0))));
            vo.setUsername(String.valueOf(lo.get(1)));
            vo.setSex(String.valueOf(lo.get(2)));
            //vo.setRegTime(Date.valueOf(String.valueOf(lo.get(2))));
            //由于数据库中此字段是datetime，所以要将字符串时间格式：yyyy-MM-dd HH:mm:ss，转为Date类型
            if (lo.get(3) != null && lo.get(3) != "") {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    vo.setBirthyear(sdf.parse(String.valueOf(lo.get(3))));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }else {
                vo.setBirthyear(new Date());
            }
            if (lo.get(4) != null && lo.get(4) != "") {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    vo.setGrade(sdf.parse(String.valueOf(lo.get(4))));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }else {
                vo.setBirthyear(new Date());
            }

            vo.setCollegeid(Integer.valueOf(String.valueOf(lo.get(5))));
            studentMapper.insertSelective(vo);

            Userlogin u = new Userlogin();
            u.setUsername(vo.getUserid().toString());
            u.setPassword("123");
            u.setRole(2);
            userloginMapper.insert(u);

        }
        return "文件导入成功！";

    }


    public void updataById(Integer id, StudentCustom studentCustom) throws Exception {
        studentMapper.updateByPrimaryKey(studentCustom);
    }

    public void removeById(Integer id) throws Exception {

        studentMapper.deleteByPrimaryKey(id);
    }

    public List<StudentCustom> findByPaging(Integer toPageNo) throws Exception {
        PagingVO pagingVO = new PagingVO();
        pagingVO.setToPageNo(toPageNo);

        List<StudentCustom> list = studentMapperCustom.findByPaging(pagingVO);

        return list;
    }

    public Boolean save(StudentCustom studentCustoms) throws Exception {
        Student stu = studentMapper.selectByPrimaryKey(studentCustoms.getUserid());
        if (stu == null) {
            studentMapper.insert(studentCustoms);
            return true;
        }

        return false;
    }

    //返回学生总数
    public int getCountStudent() throws Exception {
        //自定义查询对象
        StudentExample studentExample = new StudentExample();
        //通过criteria构造查询条件
        StudentExample.Criteria criteria = studentExample.createCriteria();
        criteria.andUseridIsNotNull();

        return studentMapper.countByExample(studentExample);
    }

    public StudentCustom findById(Integer id) throws Exception {

        Student student  = studentMapper.selectByPrimaryKey(id);
        StudentCustom studentCustom = null;
        if (student != null) {
            studentCustom = new StudentCustom();
            //类拷贝
            BeanUtils.copyProperties(student, studentCustom);
        }

        return studentCustom;
    }

    //模糊查询
    public List<StudentCustom> findByName(String name) throws Exception {

        StudentExample studentExample = new StudentExample();
        //自定义查询条件
        StudentExample.Criteria criteria = studentExample.createCriteria();

        criteria.andUsernameLike("%" + name + "%");

        List<Student> list = studentMapper.selectByExample(studentExample);

        List<StudentCustom> studentCustomList = null;

        if (list != null) {
            studentCustomList = new ArrayList<StudentCustom>();
            for (Student s : list) {
                StudentCustom studentCustom = new StudentCustom();
                //类拷贝
                BeanUtils.copyProperties(s, studentCustom);
                //获取课程名
                College college = collegeMapper.selectByPrimaryKey(s.getCollegeid());
                studentCustom.setcollegeName(college.getCollegename());

                studentCustomList.add(studentCustom);
            }
        }

        return studentCustomList;
    }


    public StudentCustom findStudentAndSelectCourseListByName(String name) throws Exception {

        StudentCustom studentCustom = studentMapperCustom.findStudentAndSelectCourseListById(Integer.parseInt(name));

        List<SelectedCourseCustom> list = studentCustom.getSelectedCourseList();

        // 判断该课程是否修完
        for (SelectedCourseCustom s : list) {
            if (s.getMark() != null) {
                s.setOver(true);
            }
        }
        return studentCustom;
    }

}
