package com.devmg.app;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.RemoteEndpoint.Basic;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller

//이 어노테이션을 설정하면 이 클래스가 웹소켓 요청을 받는 endpoint가 된다
//이제 ws://localhost:8090/echo.do 같은 주소로 접근할 수 있다
//클라이언트는 요청을 받지 않기 때문에 이런 endpoint 결로는 서버만 필요
@ServerEndpoint(value="/echo.do")
public class WebSocketChat {
    
    private static final List<Session> sessionList = new ArrayList<Session>();
    private static final Logger logger = LoggerFactory.getLogger(WebSocketChat.class);
    
    //Controller 어노테이션 때문에 자동으로 객체 생성
    public WebSocketChat() {

    }
    
    //웹소켓이 연결되었을 때 호출
    @OnOpen
    public void onOpen(Session session) {
  	
        logger.info("Open session id:"+session.getId());

        try {
            final Basic basic=session.getBasicRemote();

        }catch (Exception e) {
            // TODO: handle exception
            System.out.println(e.getMessage());
        }
        sessionList.add(session);
    }
    
    /* 모든 사용자에게 메시지 전송
     * @param self
     * @param sender
     * @param message
     */
    private void sendAllSessionToMessage(Session self, String sender, String message) {
    	
        try {
            for(Session session : WebSocketChat.sessionList) {
                if(!self.getId().equals(session.getId())) {
                    session.getBasicRemote().sendText(sender+" : "+message);
                }
            }
        }catch (Exception e) {
            // TODO: handle exception
            System.out.println(e.getMessage());
        }
    }
    
    
    // endpoint가 메시지를 수신하면 호출되는 메서드
    // 메시지를 수산만 한다
    @OnMessage
    public void onMessage(String message,Session session) {
    	
    	String sender = message.split(",")[1];
    	message = message.split(",")[0];
    	
        logger.info("Message From "+sender + ": "+message);
        try {
        					// session.getBasicRemote는 메시지를 보내는데 사용한다
            final Basic basic=session.getBasicRemote();
            basic.sendText(sender + " : "+message);
            
        }catch (Exception e) {
            // TODO: handle exception
            System.out.println(e.getMessage());
        }
        sendAllSessionToMessage(session, sender, message);
    }
    
    // 연결 에러 발생시 호출되는 메서드
    @OnError
    public void onError(Throwable e,Session session) {
        e.printStackTrace();
    }
    
    //연결 종료시 호출되는 메서드
    @OnClose
    public void onClose(Session session) {

        sessionList.remove(session);
    }
}
