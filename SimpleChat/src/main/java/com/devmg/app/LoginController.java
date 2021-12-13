package com.devmg.app;



import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;



@Controller
public class LoginController {
	
	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
	
	
	//로그인 화면 출력
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String login() {
		return "login";
	}
	
	//로그인 한 아이디값을 받아오고, 채팅방 목록 화면으로 리턴
	@RequestMapping(value = "/loginProcess.do", method = RequestMethod.POST)
	public String loginProcess(@RequestParam String id, HttpServletRequest request) {
		
		logger.info("Welcome "+id);
		
    	HttpSession session = request.getSession();
    	session.setAttribute("id", id);
    	return "chatrooms";
	}
	
	//채팅방 입장
	@RequestMapping(value="/enter.do")
	public ModelAndView enterRoom(String roomname) {

		
		System.out.println("This is enter ROOM");
		System.out.println("현재 방 이름 : " + roomname);

		
		ModelMap mmp = new ModelMap();
		mmp.addAttribute("roomname", roomname);
		
		
		return new ModelAndView("chat", mmp);
	}
	
	/*
	//채팅방 목록으로 이동
	@RequestMapping(value = "/chatrooms.do", method = RequestMethod.GET)
	public String chatrooms() {
		return "chatrooms";
	}
	*/
}
