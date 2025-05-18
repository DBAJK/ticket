package com.pj.ticket.dao;

import com.pj.ticket.vo.TicketVo;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TicketDAO {
    void saveJoinForm(TicketVo vo) throws Exception;

    int idCheck(String userId) throws Exception;

    String userIdCheck(TicketVo vo);
    String pwdCheck(TicketVo vo);
    String mngrCheck(TicketVo vo);
}
