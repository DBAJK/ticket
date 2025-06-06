package com.pj.ticket.controller;

import com.pj.ticket.service.TicketService;
import com.pj.ticket.vo.TicketVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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

    @GetMapping("popup/sportsPopup")
    public String sportsPopupRedirect() {
        return "popup/sportsPopup";
    }

    @GetMapping("/trainForm")
    public String trainRedirect() {
        return "redirect:/?formType=trainForm";
    }

    @GetMapping("/reservationForm")
    public String reservationRedirect() {
        return "redirect:/?formType=reservation";
    }

    @GetMapping("popup/reservationChk")
    public String reservationChkPopupRedirect() {
        return "popup/reservationChk";
    }

    @GetMapping("/myPage")
    public String myPageRedirect() {
        return "redirect:/?formType=myPage";
    }

    // 회원가입
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

    // 회원가입 아이디 체크
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

    // 내 정보 조회
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

    // 정보 수정
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

    //예약 정보 조회
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
    //예약 정보 상세 조회
    @RequestMapping(value = "/reservation/ticketInfo", method = RequestMethod.GET)
    @ResponseBody
    public List<TicketVo> searchTicketInfo(HttpServletRequest request, TicketVo vo) {

        HttpSession session = request.getSession(false);
        String userId = (String) session.getAttribute("userId");
        vo.setUserId(userId);

        // DB에서 티켓 목록 조회
        List<TicketVo> resultList = ticketService.searchTicketInfo(vo);

        return resultList;
    }

    @PostMapping("/api/ticketCancel")
    @ResponseBody
    public ResponseEntity<String> cancelReservation(HttpServletRequest request, TicketVo vo) {

        HttpSession session = request.getSession(false);
        String userId = (String) session.getAttribute("userId");
        vo.setUserId(userId);
        ticketService.cancelReservation(vo);
        return ResponseEntity.ok("success");
    }

    // sportsForm 티켓 정보 가져오기 
    @GetMapping("/getTicketList")
    @ResponseBody
    public List<Map<String, Object>> getTicketList(TicketVo vo) {
        List<Map<String, Object>> ticketList = new ArrayList<>();

        List<TicketVo> dbTickets = ticketService.getAllTickets(vo); // 서비스 계층에서 DB 조회

        for (TicketVo ticket : dbTickets) {
            Map<String, Object> ticketMap = new HashMap<>();
            ticketMap.put("matchDate", ticket.getStartDate());      // 예: "2025-06-06T18:30"
            ticketMap.put("openDate", ticket.getOpenDate());        // 예: "2025-05-30T10:00"
            ticketMap.put("stadium", ticket.getPlaceName());
            ticketMap.put("placeId", ticket.getPlaceId());

            ticketMap.put("homeTeamName", ticket.getHomeTeam());
            ticketMap.put("homeTeamLogo", ticket.getHomeTeamLogo());

            ticketMap.put("awayTeamName", ticket.getAwayTeam());
            ticketMap.put("awayTeamLogo", ticket.getAwayTeamLogo());

            ticketList.add(ticketMap);
        }


        return ticketList;
    }

    // 경기장, 기차 열차 예매 좌석 가져오기
    @RequestMapping(value = "/api/matchSeat")
    @ResponseBody
    public List<TicketVo> ticketPopupSeat(@RequestParam("placeId") String placeId, TicketVo vo) {

        List<TicketVo> dbTicketSeats = ticketService.ticketPopupSeat(placeId);
        return dbTicketSeats;
    }

    // sportsForm 예약하기
    @PostMapping("/api/reserveInsert")
    public ResponseEntity<?> reserveInsert(HttpServletRequest request, @RequestBody TicketVo vo) {
        try {
            HttpSession session = request.getSession();
            String userId = (String) session.getAttribute("userId");
            if(userId != "" && userId != null){
                vo.setUserId(userId);
                ticketService.reserveInsert(vo);
                return ResponseEntity.ok("예매 성공");
            }else{
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 후 예매해주세요.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("예매 실패");
        }
    }

}