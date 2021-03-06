<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<!--  <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>-->

<!-- 모달 때문에 부트스트랩 필요 -->
<!-- JavaScript Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-gtEjrD/SeCtmISkJkNUaaKMoLD0//ElJ19smozuHV6z3Iehds+3Ulb9Bn9Plx0x4" crossorigin="anonymous"></script>
<!-- CSS only -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous">

<!-- 제이쿼리 -->
<script  src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<title>Simple Chat</title>
</head>
<body>
<div id="wrap" style="margin:20px auto; width:80%;">

	<div id="namespace">
	<p>${roomname}에 오신 것을 환영합니다.</p>
	</div>

    <div>
        <!-- <button type="button" onclick="openSocket();"class="btn btn-primary">대화방 참여</button> -->
        <button type="button" onclick="closeSocket();"class="btn btn-secondary">대회방 나가기</button>
        <button type="button" onclick="clearText();" class="btn btn-danger">대화내용 지우기</button>
        <button type="button" onclick="modal();" class="btn btn-primary">대화내용 내보내기</button>
        <button type="button" onclick="chatlist();" class="btn btn-primary">대화내용 불러오기</button>
    	<br/><br/><br/>
  		메세지 입력 : 
        <input type="text" id="sender" value="${sessionScope.id}" style="display: none;">
        <input type="text" id="messageinput" onkeypress="if( event.keyCode == 13 ){send();}">
        <button type="button" onclick="send();" class="btn btn-primary">메세지 전송</button>
        
    </div>
    <!-- Server responses get written here -->
    <div id="importarea">
    </div>
    <div id="messages">
    </div>
    
    <!--  Modal -->
<div class="modal fade" id="exportModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" >대화내용 내보내기</h5>
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        현재까지의 대화 내용을 내보내시겠습니까?
      </div>
      <div class="modal-footer">
      	<button type="button" class="btn btn-primary" onclick="exportText();">내보내기</button>
       	<button type="button" class="btn btn-secondary" onclick="exmodal();">취소하기</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="successModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" >대화내용 내보내기</h5>
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        대화내용을 저장했습니다.
      </div>
      <div class="modal-footer">
      	<button type="button" class="btn btn-primary" onclick="exmodal();">닫기</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="failModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" >대화내용 내보내기</h5>
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        대화내용을 저장하지 못했습니다.
      </div>
      <div class="modal-footer">
      	<button type="button" class="btn btn-primary" onclick="exmodal();">닫기</button>
      </div>
    </div>
  </div>
</div>


<div class="modal fade" id="importModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" >대화내용 내보내기</h5>
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        대화내용을 불러오면 기존의 대화내용은 모두 삭제됩니다.
        이전 대화내용을 불러오시겠습니까?
      </div>
      <div class="modal-footer">
      	<button type="button" class="btn btn-primary" onclick="importText();">불러오기</button>
      	<button type="button" class="btn btn-primary" onclick="exmodal();">닫기</button>
      </div>
    </div>
  </div>
</div>



<!-- wrap end -->
</div>
    
    <!-- websocket javascript -->
    <script type="text/javascript">
    
    $(document).ready(function() {
    	openSocket();
    });
        var ws;
        var messages = document.getElementById("messages");
        let marray = [];
        let space = "\r\n";
        
        function openSocket(){
        	
        	
        
            if(ws !== undefined && ws.readyState !== WebSocket.CLOSED ){
                writeResponse("이미 입장하셨습니다.");
                return;
            } else{
            	writeResponse("${sessionScope.id}님이 입장하셨습니다.");
            }
            
            
            //웹소켓 객체 만드는 코드
            //localhost 앞의 ws는 웹소켓을 호출할 때 쓰는 특수 프로토콜
            //서버로 요청 보내는 프로토콜
           	ws = new WebSocket("ws://localhost:8070/enter.do/${roomname}");            
           	//echo.do 주소로 요청이 들어가면
           	//echo.do를 @ServerEndpoint(value="/echo.do")
           	//어노테이션이 붙은 WebSocketChat이 이 요청을 잡고
           	//클라이언트와 서버가 연결된다.
    
            /*
            	웹소켓이은 크게 이벤트를 사용할 수 있다
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
            
            //서버에서 클라이언트로 메시지가 왔을 때 호출
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

            //var data = document.getElementById("messageinput").value+","+document.getElementById("sender").value;
            var data = '{ \"message\" : ' + document.getElementById("messageinput").value+ ', \"sender\" : ' + document.getElementById("sender").value + '}'
            //send는 웹소켓 객체가 제공하는 메서드로 서버로 데이터를 전송할 수 있다
            ws.send(data);
            $("#messageinput").val("");
        }
        
        function closeSocket(){
            ws.close();
            //location.href="/chatrooms.do";
        }
        
        
        function writeResponse(text){
            messages.innerHTML += "<br/>"+text;
            marray.push(text + space);
        }

        
        
        
        function clearText(){

            $("#messages").empty();
            $("#importarea").empty();

            
      	}
        
        function modal(){
        	$('#exportModal').modal('show');
        }
        
        function exmodal(){
        	$('#importModal').modal('hide');
        	$('#exportModal').modal('hide');
        	$('#successModal').modal('hide');
        	$('#failModal').modal('hide');
        }
        
        function chatlist(){
        	
        	$("#importModal").modal('show');
        	
        	console.log("대화 리스트 뽑기");
        	
			$.ajax({
        		
        		url:"chatlist.ajax",
        		type:"post",
        		data:{ id:$("#sender").val() },
        		dataType:"json",
        		traditional:true,
        		success:function(responsedata){
        			
        			console.log("리스트 불러옴");
        			console.log(responsedata);

		
        		},
        		error:function(xhr){
        			console.log(xhr);
        		}
        		
        		
        	})
        	
        	
        }
        
        
        function exportText(){

        	
        	let messages = $("#messages").text();
        	let div = $("#messages").children();
        	
        	console.log(messages);
        	console.log("대화내용 내보내기");
        	
        	$.ajax({
        		url:"export.ajax",
        		type:"post",
        		data:{
        			id:"${sessionScope.id}",
        			marray : marray
        			},
        		dataType:"text",
        		traditional:true,
        		success:function(result){
        			let msg = result.trim();
        			console.log("msg : ",msg)
        			if(msg == "true"){
        				$('#exportModal').modal('hide');
        				$('#successModal').modal('show');

        			} else{
       
        				$('#exportModal').modal('hide');
        				$('#failModal').modal('show');
        			}
        		},
        		error:function(xhr){
        			console.log(xhr);
        		}
        	})
        	
        }
        
        function importText(){
        	console.log("대화내용 불러오기");
        	
        	$.ajax({
        		
        		url:"import.ajax",
        		type:"post",
        		data:{ id:$("#sender").val() },
        		dataType:"json",
        		traditional:true,
        		success:function(responsedata){
        			
        			console.log(responsedata);
        			
        			$('#importModal').modal('hide');
        			$("#messages").empty();
        			$("#importarea").empty();
        			let chat = responsedata

        			$.each(chat, function(index,item){
        				
        				console.log("each문이 도나요?");
        				marray.push(chat[index] + space);
        				
        				$("#importarea").append(    					
        						"<br/>" + chat[index]
        						
        				);
        				
        			});
		
        		},
        		error:function(xhr){
        			console.log(xhr);
        		}
        		
        		
        	})
        }
        
  </script>
</body>
</html>