<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script  src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<title>Simple Chat</title>
</head>
<body>
    <div>
        <button type="button" onclick="openSocket();">대화방 참여</button>
        <button type="button" onclick="closeSocket();">대회방 나가기</button>
    	<br/><br/><br/>
  		메세지 입력 : 
        <input type="text" id="sender" value="${sessionScope.id}" style="display: none;">
        <input type="text" id="messageinput">
        <button type="button" onclick="send();">메세지 전송</button>
        <button type="button" onclick="javascript:clearText();">대화내용 지우기</button>
        <button type="button" onclick="exportText();">대화내용 내보내기</button>
    </div>
    <!-- Server responses get written here -->
    <div id="messages">
    </div>
    <!-- websocket javascript -->
    <script type="text/javascript">
        var ws;
        var messages = document.getElementById("messages");
        let marray = [];
        
        function openSocket(){
            if(ws !== undefined && ws.readyState !== WebSocket.CLOSED ){
                writeResponse("이미 입장하셨습니다.");
                return;
            }
            
            
            //웹소켓 객체 만드는 코드
            //localhost 앞의 ws는 웹소켓을 호출할 때 쓰는 특수 프로토콜
            //ws = new WebSocket("ws://localhost:8090/echo.do");
            ws = new WebSocket("ws://172.30.1.15:8090/echo.do");
            /*
            	웹소켓이 정상적으로 생성됐을 때 네 가지 이벤트를 사용할 수 있다
            	open : 커넥션을 만듦
            	message : 데이터를 받음
            	error : 웹소켓 에러
            	close : 커넥션 종료
            	
            	커넥션이 생성된 상태에서 무언가를 보내고 싶다면 ws.send(보낼 내용)을 사용
            */
            
            //서버와 연결할 때 호출됨
            ws.onopen = function(event){
                if(event.data === undefined){
              		return;
                }
                writeResponse(event.data);

            };
            
            //서버에서 메시지 수신할 때 호출
            ws.onmessage = function(event){
                console.log('writeResponse');
                console.log(event.data)
                writeResponse(event.data);
            };
            
            //서버와 연결 끊어질 때 호출
            ws.onclose = function(event){
                writeResponse("${sessionScope.id}님이 나가셨습니다.");
            }
            
        }
        
        function send(){
           // var text=document.getElementById("messageinput").value+","+document.getElementById("sender").value;
            var text = document.getElementById("messageinput").value+","+document.getElementById("sender").value;
            ws.send(text);
            let id = "${sessionScope.id} : ";
            let space = "\r\n";
            marray.push(id + document.getElementById("messageinput").value + space);
            text = "";
        }
        
        function closeSocket(){
            ws.close();
        }
        
        function writeResponse(text){
            messages.innerHTML += "<br/>"+text;
        }

        function clearText(){
            console.log(messages.parentNode);
            messages.parentNode.removeChild(messages)
      	}
        
        function exportText(){
        	
        	let messages = $("#messages").text();
        	let div = $("#messages").children();
        	
        	console.log(marray);
        	console.log("대화내용 내보내기");
        	
        	$.ajax({
        		url:"export.ajax",
        		type:"post",
        		data:{marray : marray},
        		dataType:"text",
        		traditional:true,
        		success:function(result){
        			let msg = result.trim();
        			if(msg == "true"){
        				alert("대화를 저장했습니다.");
        			} else{
        				alert("대화를 저장하지 못했습니다.");
        			}
        		},
        		error:function(xhr){
        			console.log(xhr);
        		}
        	})
        	
        }
        
  </script>
</body>
</html>