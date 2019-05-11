package com.system.service.impl;

import com.system.exception.CustomException;
import com.system.mapper.*;
import com.system.po.*;
import com.system.service.TeacherService;
import com.system.utils.ExcelUtil;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by Jacey Housheng_Xiao on 2018/11/27
 */
@Service
public class TeacherServiceImpl implements TeacherService {

    @Autowired
    private TeacherMapper teacherMapper;

    @Autowired
    private TeacherMapperCustom teacherMapperCustom;

    @Autowired
    private CollegeMapper collegeMapper;

    @Autowired
    private CourseMapper courseMapper;

    @Autowired
    private UserloginMapper userloginMapper;

    public void updateById(Integer id, TeacherCustom teacherCustom) throws Exception {
        teacherMapper.updateByPrimaryKey(teacherCustom);
    }

    public void removeById(Integer id) throws Exception {
        CourseExample courseExample = new CourseExample();

        CourseExample.Criteria criteria = courseExample.createCriteria();
        criteria.andTeacheridEqualTo(id);
        List<Course> list = courseMapper.selectByExample(courseExample);

        if (list.size() != 0) {
            throw new CustomException("请先删除该名老师所教授的课程");
        }

        teacherMapper.deleteByPrimaryKey(id);
    }

    public List<TeacherCustom> findByPaging(Integer toPageNo) throws Exception {
        PagingVO pagingVO = new PagingVO();
        pagingVO.setToPageNo(toPageNo);

        List<TeacherCustom> list = teacherMapperCustom.findByPaging(pagingVO);

        return list;
    }

    public Boolean save(TeacherCustom teacherCustom) throws Exception {

        Teacher tea = teacherMapper.selectByPrimaryKey(teacherCustom.getUserid());
        if (tea == null) {
            teacherMapper.insert(teacherCustom);
            return true;
        }
        return false;
    }

    public int getCountTeacher() throws Exception {
        //自定义查询对象
        TeacherExample teacherExample = new TeacherExample();
        //通过criteria构造查询条件
        TeacherExample.Criteria criteria = teacherExample.createCriteria();
        criteria.andUseridIsNotNull();

        return teacherMapper.countByExample(teacherExample);
    }

    public TeacherCustom findById(Integer id) throws Exception {
        Teacher teacher = teacherMapper.selectByPrimaryKey(id);
        TeacherCustom teacherCustom = null;
        if (teacher != null) {
            teacherCustom = new TeacherCustom();
            BeanUtils.copyProperties(teacher, teacherCustom);
        }

        return teacherCustom;
    }

    public List<TeacherCustom> findByName(String name) throws Exception {
        TeacherExample teacherExample = new TeacherExample();
        //自定义查询条件
        TeacherExample.Criteria criteria = teacherExample.createCriteria();

        criteria.andUsernameLike("%" + name + "%");

        List<Teacher> list = teacherMapper.selectByExample(teacherExample);

        List<TeacherCustom> teacherCustomList = null;

        if (list != null) {
            teacherCustomList = new ArrayList<TeacherCustom>();
            for (Teacher t : list) {
                TeacherCustom teacherCustom = new TeacherCustom();
                //类拷贝
                BeanUtils.copyProperties(t, teacherCustom);
                //获取课程名
                College college = collegeMapper.selectByPrimaryKey(t.getCollegeid());
                teacherCustom.setcollegeName(college.getCollegename());

                teacherCustomList.add(teacherCustom);
            }
        }

        return teacherCustomList;
    }

    public List<TeacherCustom> findAll() throws Exception {

        TeacherExample teacherExample = new TeacherExample();
        TeacherExample.Criteria criteria = teacherExample.createCriteria();

        criteria.andUsernameIsNotNull();

        List<Teacher> list = teacherMapper.selectByExample(teacherExample);
        List<TeacherCustom> teacherCustomsList = null;
        if (list != null) {
            teacherCustomsList = new ArrayList<TeacherCustom>();
            for (Teacher t: list) {
                TeacherCustom teacherCustom = new TeacherCustom();
                BeanUtils.copyProperties(t, teacherCustom);
                teacherCustomsList.add(teacherCustom);
            }
        }
        return teacherCustomsList;
    }

    public String importExcelInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {

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
            TeacherCustom vo = new TeacherCustom();

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
            vo.setDegree(String.valueOf(lo.get(4)));
            vo.setTitle(String.valueOf(lo.get(5)));

            if (lo.get(6) != null && lo.get(6) != "") {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    vo.setGrade(sdf.parse(String.valueOf(lo.get(6))));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }else {
                vo.setGrade(new Date());
            }

            vo.setCollegeid(Integer.valueOf(String.valueOf(lo.get(7))));
            teacherMapper.insertSelective(vo);

            Userlogin u = new Userlogin();
            u.setUsername(vo.getUserid().toString());
            u.setPassword("123");
            u.setRole(1);
            userloginMapper.insert(u);
        }
        return "文件导入成功！";
    }

    public XSSFWorkbook exportExcelInfo() throws Exception {
        //根据条件查询数据，把数据装载到一个list中
        List<Teacher> list = teacherMapperCustom.findAll();

        List<ExcelBean> excel=new ArrayList<ExcelBean>();
        Map<Integer,List<ExcelBean>> map=new LinkedHashMap<Integer,List<ExcelBean>>();
        XSSFWorkbook xssfWorkbook=null;
        //设置标题栏
        excel.add(new ExcelBean("编号","userid",0));
        excel.add(new ExcelBean("教师名","username",0));
        excel.add(new ExcelBean("性别","sex",0));
        excel.add(new ExcelBean("出生年月","birthyear",0));
        excel.add(new ExcelBean("学历","degree",0));
        excel.add(new ExcelBean("讲师","title",0));
        excel.add(new ExcelBean("入职年份","grade",0));
        excel.add(new ExcelBean("所属院系","collegeid",0));

        map.put(0, excel);
        String sheetName = "教师信息";
        //调用ExcelUtil的方法
        xssfWorkbook = ExcelUtil.createExcelFile(Teacher.class, list, map, sheetName);
        return xssfWorkbook;

    }
}
