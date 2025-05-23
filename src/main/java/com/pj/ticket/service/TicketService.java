package com.pj.ticket.service;

import com.pj.ticket.dao.TicketDAO;
import com.pj.ticket.vo.TicketVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;

@Service
public class TicketService {

    @Autowired(required = false)
    private TicketDAO ticketDAO;


/*
    public void saveJoinForm(TicketVo vo) throws Exception{
        ticketDAO.saveJoinForm(vo);
    }

*/

    public int idCheck(String userId) throws Exception{
        return ticketDAO.idCheck(userId);
    }


    public int userChk(TicketVo vo){
        return ticketDAO.userChk(vo);
    }

/*
    public void logout(HttpSession session) {
        session.invalidate(); // 세션 초기화
    }
*/


}
