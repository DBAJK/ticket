package com.pj.ticket.controller;

import com.pj.ticket.service.TicketService;
import com.pj.ticket.vo.TicketVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Controller
public class ticketController {


    @Autowired(required = false)
    TicketService ticketService;


    @GetMapping("/")
    public String index(@RequestParam(value = "formType", required = false) String formType, Model model) {
        if (formType == null) {
            formType = "main"; // 기본값
        }
        model.addAttribute("formType", formType);
        return "indexForm"; // => indexForm.jsp 출력
    }

    @GetMapping("/mainForm")
    public String mainRedirect() {
        return "redirect:/?formType=main";
    }
    // 별도 URL을 통한 접근도 허용하려면 redirect 사용 가능
    @GetMapping("/loginForm")
    public String loginRedirect() {
        return "redirect:/?formType=login";
    }

    @GetMapping("/joinForm")
    public String joinRedirect() {
        return "redirect:/?formType=join";
    }

    @GetMapping("/sports")
    public String sportsRedirect() {
        return "redirect:/?formType=sports";
    }

    @GetMapping("/train")
    public String trainRedirect() {
        return "redirect:/?formType=train";
    }

    @GetMapping("/reservationForm")
    public String reservationRedirect() {
        return "redirect:/?formType=reservation";
    }


/*
    @RequestMapping("/saveJoinForm.do")
    @ResponseBody
    public void saveJoinForm(TicketVo vo){
        try {
            ticketService.saveJoinForm(vo);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
*/

    @RequestMapping("/idCheck")
    @ResponseBody
    public String idCheck(@RequestParam("userId") String userId){
        int cntChk=0;
        String cnt="0";
        try {
            cntChk = ticketService.idCheck(userId);
            if(cntChk == 1){
                cnt = "1";
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return cnt;
    }

    @RequestMapping(value = "/service/loginForm")
    @ResponseBody
    public String loginCheck(HttpServletRequest request, TicketVo vo) {
        String userIdChk = request.getParameter("userId");
        String loginId="";
        vo.setUserId(userIdChk);
        vo.setUserPw(request.getParameter("userPw"));
        int userChk = ticketService.userChk(vo);
        HttpSession session = request.getSession();

        if(userChk == 1){
            loginId = "loginOk";
            session.setAttribute("userId", userIdChk);
        }
        return loginId;
    }
}