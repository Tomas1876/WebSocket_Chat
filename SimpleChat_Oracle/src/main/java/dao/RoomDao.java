package dao;

import java.util.List;

import dto.Room;



public interface RoomDao {
	
	//대화방 목록 불러오기
	public List<Room> getRooms();
	
	//대화방 추가하기
	public int createRoom(String roomname);
	
	//대화방 삭제하기
	public int deleteRoom(String roomname);

}
