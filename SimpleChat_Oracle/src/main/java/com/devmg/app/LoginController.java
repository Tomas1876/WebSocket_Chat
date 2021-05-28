package com.devmg.app;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import dto.Room;

/**
 * Handles requests for the application home page.
 */
@Controller
public class LoginController {
	
	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/login.do", method = RequestMethod.GET)
	public String login() {
		return "login";
	}
	
	
	@RequestMapping(value = "/chatrooms.do", method = RequestMethod.GET)
	public String chatrooms() {
		return "chatrooms";
	}
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/loginProcess.do", method = RequestMethod.POST)
	public String loginProcess(@RequestParam String id, HttpServletRequest request) {
		
		logger.info("Welcome "+id);
		
    	HttpSession session = request.getSession();
    	session.setAttribute("id", id);
		//return "chat";
    	return "chatrooms";
	}
	
	//채팅방 입장
	@RequestMapping(value="/enter.do")
	public ModelAndView enterRoom(String roomname) {
	//public String enterRoom() {	
		
		System.out.println("This is enter ROOM");
		System.out.println("현재 방 이름 : " + roomname);
		//model.addAttribute("roomname", room.getRoomname());
		
		ModelMap mmp = new ModelMap();
		mmp.addAttribute("roomname", roomname);
		
		//ModelAndView mav = new ModelAndView();
		//ModelMap mmp = new ModelMap();
		//mmp.addAttribute("roomname", roomname);
		//mmp.put("roomname", roomname);
		
		return new ModelAndView("chat", mmp);
	}
	
}
