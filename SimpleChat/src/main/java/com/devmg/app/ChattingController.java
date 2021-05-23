package com.devmg.app;

import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.format.datetime.DateFormatter;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ChattingController {
	
	@RequestMapping(value="export.ajax", method=RequestMethod.POST)
	public String export(HttpServletRequest request, String[] marray) {
		
		System.out.println("This is Chatting Controller");
		String bo  = "false";
		
		BufferedOutputStream bs = null;
		
		SimpleDateFormat sdf = new SimpleDateFormat ("yyyyMMdd_HHmm");
		Date time = new Date();				
		String date = sdf.format(time);
		
		if(marray != null) {
			bo = "true";			
			System.out.println("if문 진입");

			try {
				bs = new BufferedOutputStream(new FileOutputStream("c:/web/Spring/SpringLabs/SimpleChat/src/files/"+date+".txt"));
			 
				for(int i = 0; i < marray.length; i++){
					
					System.out.println("전송된 메시지 : " + marray[i]);
					
					bs.write(marray[i].getBytes());
				}			
				bs.flush();
			} catch (Exception e) {
		            System.out.println("오류 : " +e.getMessage());
			}finally {
				
				try {
					
					if( bs != null){
						bs.close();
					}

				} catch (IOException e) {

					e.printStackTrace();
				}


			}
		}
		return bo;
		
	}
	
	
}
