package com.pj.ticket.controller;

import com.pj.ticket.service.TicketService;
import com.pj.ticket.vo.TicketVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

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
    // 별도 URL을 통한 접근도 허용하려면 redirect 사용 가능
    @GetMapping("/loginForm")
    public String loginRedirect() {
        return "redirect:/?formType=login";
    }

    @GetMapping("/joinForm")
    public String joinRedirect() {
        return "redirect:/?formType=join";
    }

    @GetMapping("/sportsForm")
    public String sportsRedirect() {
        return "redirect:/?formType=sportsForm";
    }

    @GetMapping("/trainForm")
    public String trainRedirect() {
        return "redirect:/?formType=trainForm";
    }

    @GetMapping("/reservationForm")
    public String reservationRedirect() {
        return "redirect:/?formType=reservation";
    }

    @GetMapping("/myPage")
    public String myPageRedirect() {
        return "redirect:/?formType=myPage";
    }


    @RequestMapping("/saveJoinForm")
    @ResponseBody
    public void saveJoinForm(TicketVo vo){
        try {
            ticketService.saveJoinForm(vo);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

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

    // 로그인 하기
    @RequestMapping(value = "/service/loginForm")
    @ResponseBody
    public String loginCheck(HttpServletRequest request, TicketVo vo) {
        String loginId="";
        vo.setUserId(request.getParameter("userId"));
        vo.setUserPw(request.getParameter("userPw"));
        TicketVo userChk = ticketService.userChk(vo);
        HttpSession session = request.getSession();

        if(userChk != null){
            loginId = "loginOk";
            session.setAttribute("userId", vo.getUserId());
            session.setAttribute("userName", userChk.getUserName());
        }
        return loginId;
    }

    //로그아웃
    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // 존재하는 세션만 가져옴
        if (session != null) {
            session.invalidate(); // 세션 무효화
        }
        return "redirect:/sportsForm"; // 로그아웃 후 메인으로 이동
    }


    @GetMapping("/myPageInfo")
    @ResponseBody
    public Map<String, Object> myPageInfo(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Map<String, Object> map = new HashMap<>();
        if (session != null && session.getAttribute("userId") != null){
            String userId = (String) session.getAttribute("userId");
            TicketVo user = ticketService.findUserById(userId);  // DAO 통해 정보 조회
            map.put("status", "success");
            map.put("userId", user.getUserId());
            map.put("userName", user.getUserName());
            map.put("phone", user.getTelNo());
            map.put("point", user.getPoint());
            map.put("birthday", user.getBirtyD());
        } else {
            map.put("status", "fail");
            map.put("message", "로그인 정보가 없습니다.");
        }
        return map;
    }

    @RequestMapping("/updateUsersInfo")
    @ResponseBody
    public void updateUsersInfo(HttpServletRequest request, TicketVo vo){
        HttpSession session = request.getSession();
        try {
            vo.setUserId(request.getParameter("userId"));
            vo.setUserPw(request.getParameter("userPw"));
            vo.setUserName(request.getParameter("userName"));
            ticketService.updateUser(vo);
            session.setAttribute("userName", request.getParameter("userName"));
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/reservation/search", method = RequestMethod.GET)
    @ResponseBody
    public List<TicketVo> searchReservations(
            @RequestParam String startDate,
            @RequestParam String endDate,
            HttpServletRequest request,
            TicketVo vo
    ) {

        HttpSession session = request.getSession(false);

        String userId = (String) session.getAttribute("userId");
        vo.setUserId(userId);
        vo.setStartDate(startDate);
        vo.setEndDate(endDate);

        // DB에서 티켓 목록 조회
        List<TicketVo> resultList = ticketService.searchTickets(vo);

        return resultList;
    }


    @GetMapping("/getTicketList")
    @ResponseBody
    public List<Map<String, Object>> getTicketList() {
        List<Map<String, Object>> ticketList = new ArrayList<>();

        // 첫 번째 경기
        Map<String, Object> ticket1 = new HashMap<>();
        ticket1.put("matchDate", "2025-06-06"); // 경기일시 (ISO 형식)
        ticket1.put("stadium", "KIA 챔피언스필드");
        ticket1.put("openDate", "2025-05-30"); // 예매 오픈일시

        // 홈팀 정보
        Map<String, Object> homeTeam = new HashMap<>();
        homeTeam.put("name", "KIA Tigers");
        homeTeam.put("logo", "WEB-INF/resources/images/kiaTigers.jpg"); // 실제 경로로 수정
        ticket1.put("homeTeam", homeTeam);

        // 원정팀 정보
        Map<String, Object> awayTeam = new HashMap<>();
        awayTeam.put("name", "Hanwha Eagles");
        awayTeam.put("logo", "WEB-INF/resources/images/ssgLanders.png"); // 실제 경로로 수정
        ticket1.put("awayTeam", awayTeam);

        ticketList.add(ticket1);

        return ticketList;
    }

}