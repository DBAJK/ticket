package com.pj.ticket.dao;

import com.pj.ticket.vo.TicketVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface TicketDAO {
    void saveJoinForm(TicketVo vo) throws Exception;

    int idCheck(String userId) throws Exception;

    TicketVo userChk(TicketVo vo);

    TicketVo findUserById(String userId);

    void updateUser(TicketVo vo) throws Exception;

    List<TicketVo> searchTickets(TicketVo vo);
    List<TicketVo> searchTicketInfo(TicketVo vo);
    void cancelReservation(TicketVo vo);

    List<TicketVo> searchMatchCard(TicketVo vo);

    List<TicketVo> ticketPopupSeat(TicketVo vo);

    void reserveInsert(TicketVo vo) throws Exception;

    void pointUpdate(TicketVo vo) throws Exception;

    List<TicketVo> searchTrainCard(TicketVo vo);

    List<TicketVo> trainTicketPopupSeat(TicketVo vo);
}
