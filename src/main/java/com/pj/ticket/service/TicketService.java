package com.pj.ticket.service;

import com.pj.ticket.dao.TicketDAO;
import com.pj.ticket.vo.TicketVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.util.List;

@Service
public class TicketService {

    @Autowired(required = false)
    private TicketDAO ticketDAO;


    public void saveJoinForm(TicketVo vo) throws Exception{
        ticketDAO.saveJoinForm(vo);
    }

    public int idCheck(String userId) throws Exception{
        return ticketDAO.idCheck(userId);
    }


    public TicketVo userChk(TicketVo vo){
        return ticketDAO.userChk(vo);
    }

    public TicketVo findUserById(String userId){
        return ticketDAO.findUserById(userId);
    }

    public void updateUser(TicketVo vo) throws Exception{
        ticketDAO.updateUser(vo);
    }

    public List<TicketVo> searchTickets(TicketVo vo){
        return ticketDAO.searchTickets(vo);
    }

    public List<TicketVo> searchTicketInfo(TicketVo vo){
        return ticketDAO.searchTicketInfo(vo);
    }

    public void cancelReservation(TicketVo vo) {
        ticketDAO.cancelReservation(vo);
    }


    public List<TicketVo> getAllTickets(TicketVo vo){
        return ticketDAO.searchMatchCard(vo);
    }

    public List<TicketVo> ticketPopupSeat(String placeId){
        return ticketDAO.ticketPopupSeat(placeId);
    }
    public void reserveInsert(TicketVo vo) throws Exception{
        List<String> seats = vo.getSeats();

        for (String seat : seats) {
            String[] parts = seat.split("-");
            String zone = parts[0];
            String row = parts[1];
            String col = parts[2];

            vo.setSeatZone(zone);
            vo.setSeatRow(row);
            vo.setSeatCol(col);

            ticketDAO.reserveInsert(vo);
            ticketDAO.reserveUpdate(vo);
        }

    }

}
