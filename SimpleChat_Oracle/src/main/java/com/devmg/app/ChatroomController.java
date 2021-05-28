
package com.devmg.app;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import dao.RoomDao;
import dto.Room;



@RestController
@RequestMapping("/room")
public class ChatroomController {
	
	private SqlSession sqlsession;

	@Autowired
	public void setSqlsession(SqlSession sqlsession) {
		this.sqlsession = sqlsession;
	}	
	
	/*
	  
	 예시) Http  method 종류
	GET        ( /board/100 )       >> 100번 게시물 조회
	POST     ( /board  + 데이터)      >> 게시물 등록
	DELETE ( /board/100)            >> 100게시물 삭제
	PUT       ( /board/100 + 데이터   >> 100번 게시물 수정
	PATCH   ( /board/100 + 데이터     >> 100번 게시물 수정
		-->> uri 값이 같아도 메서드 종류에 따라 의미가 달라짐 
	 
	 */
	
	
	//대화방 목록 불러오기
	@RequestMapping(value="", method = RequestMethod.GET)
	public List<Room> getRooms(){
		
		RoomDao roomdao = sqlsession.getMapper(RoomDao.class);	
		
		List<Room> list = roomdao.getRooms();
		
		return list;
		
	}
	
	//대화방 추가하기
	@RequestMapping(value="", method = RequestMethod.POST)
	public String createRoom(@RequestBody Room room) {
		
		System.out.println("This is CREATE ROOM");
		
		//System.out.println(room.getUsername());
		System.out.println(room.getRoomname());
		
		RoomDao roomdao = sqlsession.getMapper(RoomDao.class);			
		int row = roomdao.createRoom(room.getRoomname());
		String result = "";
		System.out.println("result : " + row);
		
		if(row > 0 ) {
			result = "success";
		} else {
			result = "fail";
		}
		
		//등록
		System.out.println("등록 성공");	

		return result;
		
	}
	
	//대화방 삭제하기
	@RequestMapping(value="", method = RequestMethod.DELETE)
	public String deleteRoom(@RequestBody Room room) {
		
		System.out.println("This is Delete ROOM");

		System.out.println(room.getRoomname());
		
		RoomDao roomdao = sqlsession.getMapper(RoomDao.class);			
		int row = roomdao.deleteRoom(room.getRoomname());
		String result = "";
		System.out.println("result : " + row);
		
		if(row > 0 ) {
			result = "success";
		} else {
			result = "fail";
		}
		
		//등록
		System.out.println("삭제 성공");	

		return result;
	}
	
}
