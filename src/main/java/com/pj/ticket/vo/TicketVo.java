package com.pj.ticket.vo;

import lombok.*;

@NoArgsConstructor @AllArgsConstructor
@Builder(toBuilder = true)
@Getter
@Setter
@ToString
public class TicketVo {

    private String userId;
    private String userPw;
    private String password;

    private String userName;
    private String birtyD;
    private String telNo;
    private int point;


    private String ticketName;
    private String category;
    private String status;
    private String usedDt;
    private String ticketType;
    private String description;

    private String startDate;
    private String endDate;

    private String ticketId;
    private String placeId;
    private String placeName;
    private String homeTeam;
    private String homeTeamLogo;
    private String awayTeam;
    private String awayTeamLogo;
    private String openDate;

    private String address;
    private String seatZone;
    private String seatRow;
    private String seatCol;
}
