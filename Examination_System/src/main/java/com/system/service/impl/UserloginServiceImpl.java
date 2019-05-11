package com.system.service.impl;

import com.system.mapper.UserloginMapper;
import com.system.po.QueryVo;
import com.system.po.Userlogin;
import com.system.po.UserloginExample;
import com.system.service.UserloginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by Jacey Housheng_Xiao on 2018/11/27
 */
@Service
public class UserloginServiceImpl implements UserloginService {

    @Autowired
    private UserloginMapper userloginMapper;

    public Userlogin checkCode(String name) throws Exception {
        return userloginMapper.userLogin(name);
    }

    public Userlogin findUserByQueryVo(QueryVo queryVo) throws Exception {
        return userloginMapper.findUserByQueryVo(queryVo);
    }


    public Userlogin findByName(String name) throws Exception {
        UserloginExample userloginExample = new UserloginExample();

        UserloginExample.Criteria criteria = userloginExample.createCriteria();
        criteria.andUsernameEqualTo(name);

        List<Userlogin> list = userloginMapper.selectByExample(userloginExample);

        return list.get(0);
    }

    public void save(Userlogin userlogin) throws Exception {
        userloginMapper.insert(userlogin);
    }

    public void removeByName(String name) throws Exception {
        UserloginExample userloginExample = new UserloginExample();

        UserloginExample.Criteria criteria = userloginExample.createCriteria();
        criteria.andUsernameEqualTo(name);

        userloginMapper.deleteByExample(userloginExample);
    }

    public void updateByName(String name, Userlogin userlogin) {
        UserloginExample userloginExample = new UserloginExample();

        UserloginExample.Criteria criteria = userloginExample.createCriteria();
        criteria.andUsernameEqualTo(name);

        userloginMapper.updateByExample(userlogin, userloginExample);
    }

}
