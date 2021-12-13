package com.devmg.app;


import java.util.ArrayList;
import java.util.List;


import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.RemoteEndpoint.Async;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;



@Controller

//이 어노테이션을 설정하면 이 클래스가 웹소켓 요청을 받는 endpoint가 된다
//이제 /echo.do 라는 URI로 웹소켓에 접근할 수 있다
@ServerEndpoint(value="/enter.do/{roomname}")
public class WebSocketChat {
    
    private static final List<Session> sessionList = new ArrayList<Session>();
    private static final Logger logger = LoggerFactory.getLogger(WebSocketChat.class);
    
    //Controller 어노테이션 때문에 자동으로 객체 생성
    public WebSocketChat() {
    	System.out.println("WebSocketChat 객체 생성");
    }
    
    //웹소켓이 연결되었을 때 호출
	// 웹소켓의 Session 객체는 웹의 Session객체와 다르다
	// 브라우저에서 소켓 접속하면 생성되는 객체로 브라우저가 웹소켓에 접속했을 때의 커넥션 정보가 있다
    @OnOpen
    public void onOpen(Session session, @PathParam("roomname")String roomname) {
    	
    	System.out.println("roomname : " + roomname);
    	
    	//현재 세션이 접속한 방의 이름을 property로 지정해준다
    	session.getUserProperties().put("roomname", roomname);

        try {
        	
        	final Async async = session.getAsyncRemote();
        	
        }catch (Exception e) {
            // TODO: handle exception
            System.out.println(e.getMessage());
        }
		sessionList.add(session);

		
    }
    

    // 다른 사용자들에게 메시지 전송
    private void sendAllSessionToMessage(Session self, String sender, String message,String roomname ) {
    	
        try {
        	
        	String senderRoom = (String) self.getUserProperties().get("roomname");
        	System.out.println("senderRoom : " + senderRoom);
        	
        	//세션 리스트에 담긴 세션 정보를 비교해 자신을 제외한 다른 모든 사용자에게 메시지 전송
            for(Session session : WebSocketChat.sessionList) {
                if(!self.getId().equals(session.getId()) && session.getUserProperties().get("roomname").equals(senderRoom)) {
                    session.getAsyncRemote().sendText(sender+" : "+message);
                    
                    System.out.println("다른 사용자의 방 : " + session.getUserProperties().get("roomname"));
                }
            }
        }catch (Exception e) {
            // TODO: handle exception
            System.out.println(e.getMessage());
        }
    }
    
    
    // 웹소켓으로 메시지가 오면 호출되는 함수
    @OnMessage
    public void onMessage(Session session, String message, @PathParam("roomname")String roomname) throws ParseException {
    	
    	// 클라이언트가 ws.send(data)로 보낸 데이터를 수신한다
    	//String message = document.getElementById("messageinput").value+","+document.getElementById("sender").value;
    	JSONParser jsonParser = new JSONParser();
    	System.out.println("ㄹㄹㄹㄹ" + message);
        JSONObject data = (JSONObject) jsonParser.parse(message);
    	String sender = (String) data.get("sender");
    	message = (String) data.get("message");
    	
        logger.info("Message From "+sender + ": "+message);
        
        
        try {
      	
        	//javax.websocket.RemoteEndpoint 인스턴스의 하위 인터페이스 RemoteEndpoint.Async
        	//웹소켓 메시지를 비동기적으로 보낼 수 있게 해준다
        	//getAsyncRemote는 해당 세션의 RemoteEndpoint, 연결의 반대편 끝(클라이언트)를 리턴한다
        	//final Async async = session.getAsyncRemote();
        	//async.sendText(sender + " : "+message);
        	
        	session.getAsyncRemote().sendText(sender + " : "+message);
            // 서버에서 클라이언트로 메시지를 보내는 부분
            
        }catch (Exception e) {
            // TODO: handle exception
            System.out.println(e.getMessage());
        }
       
        sendAllSessionToMessage(session, sender, message, roomname);
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
