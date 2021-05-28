<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="room" value="${requestScope.Room}" />

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
    <div>
        
        <input type="text" id="roomname"onkeypress="if( event.keyCode == 13 ){makeroom();}"/>
        <button type="button" onclick="makeroom();"class="btn btn-primary">대화방 만들기</button>
        
        <!-- 
        <button type="button" onclick="openSocket();"class="btn btn-primary">대화방 참여</button>
        <button type="button" onclick="closeSocket();"class="btn btn-secondary">대회방 나가기</button>
        <button type="button" onclick="clearText();" class="btn btn-danger">대화내용 지우기</button>
        <button type="button" onclick="modal();" class="btn btn-primary">대화내용 내보내기</button>
        <button type="button" onclick="chatlist();" class="btn btn-primary">대화내용 불러오기</button>
    	<br/><br/><br/>
  		메세지 입력 : 
        <input type="text" id="sender" value="${sessionScope.id}" style="display: none;">
        <input type="text" id="messageinput" onkeypress="if( event.keyCode == 13 ){send();}">
        <button type="button" onclick="send();" class="btn btn-primary">메세지 전송</button>
         -->
         <div id="rooms">
         
         
         
         </div>
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


<!-- wrap end -->
</div>
    
    <script type="text/javascript">
    
    
    $(document).ready(function(){
    	
    	getrooms();
    	
    });
    
    //대화방 리스트 불러오기(비동기)
    function getrooms(){
    	console.log("대화방 목록 불러오기");
    	
    	$.ajax({
    		
    		url:"room",
    		type:"get",
    		dataType:"json",
    		traditional:true,
    		success:function(responsedata){
    			
    			console.log(responsedata);
    			
    			let rooms = responsedata;
    			
    			$.each(rooms, function(index, item){
    				
    				
    				$("#rooms").append(
    						   						
    						"<div id='"+item.roomname+"' class='chatroom'><h1 onclick='enterRoom(this)'>"+item.roomname+"</h1>"
    						+"<button type='button' onclick='deleteRoom(this)'>삭제하기</button></div>"
    						
    				);
    				
    			});
    			
    			
    		},
    		error:function(xhr){
    			console.log(xhr);
    		}
    		
    	});
    	
    }
    
    //대화방 만들기(비동기)
    function makeroom(){
    	console.log("대화방 생성");
    	console.log($("#roomname").val());
    	let roomname = $("#roomname").val();
    	
	$.ajax({
    		
    		url:"room",
    		type:"post",
    		data:JSON.stringify({
    			roomname:$("#roomname").val()
    			}),
    		dataType:"text",
    		contentType:'application/json; charset=utf-8',
    		//traditional:true,
    		success:function(responsedata){
    			
    			console.log(responsedata);
    			
    			let result = responsedata;
    			alert("대화방이 생성됐습니다.");
    			$("#roomname").val("");
				
    			if(result === "success"){
    				$("#rooms").append(
	   						
    						"<div id='"+roomname+"' class='chatroom'><h1 onclick='enterRoom(this)'>"+roomname+"</h1>"
    						+"<button type='button' onclick='deleteRoom(this)'>삭제하기</button></div>"					
    				);
    			} else{
    				
    				alert("방 생성에 실패했습니다");
    				
    			}
    			
    		},
    		error:function(xhr){
    			console.log(xhr);
    		}
    		
    	});
    	
    }
    
    function deleteRoom(room){
    	console.log("대화방 삭제");
    	
    	let roomname = room.previousSibling.innerText;
    	
    	console.log("현재 파라미터 ",roomname);
    	
		$.ajax({
    		
    		url:"room",
    		type:"delete",
    		data:JSON.stringify({
    			roomname:roomname
    			}),
    		dataType:"text",
    		contentType:'application/json; charset=utf-8',
    		//traditional:true,
    		success:function(responsedata){
    			
    			console.log(responsedata);
    			
    			let result = responsedata;
    			alert("대화방이 삭제됐습니다.")
				$("#rooms").empty();
    			getrooms();
    			
    			if(result === "success"){
						
    			} else{
    				
    				alert("방 삭제에 실패했습니다");
    				
    			}
    			
    		},
    		error:function(xhr){
    			console.log(xhr);
    		}
    		
    	});
    	

    }
    
    function enterRoom(room){
    	let roomname = room.innerText;
    	console.log(roomname);
    	console.log("대화방 입장");
    	location.href="/enter.do?roomname="+roomname;
    	//location.href="/enter.do";
    	
    }
    
    //대화방 입장(동기)
  </script>
</body>
</html>