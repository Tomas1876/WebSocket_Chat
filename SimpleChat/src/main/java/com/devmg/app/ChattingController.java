package com.devmg.app;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.format.datetime.DateFormatter;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ChattingController {
	
	//private String filepath = "c:/web/Spring/SpringLabs/SimpleChat_Oracle/src/files/";
	private String filepath = "c:/Temp/files/";
	
	@RequestMapping(value="export.ajax", method=RequestMethod.POST)
	public String export(String id, String[] marray) {
		
		System.out.println("This is Chatting Controller");
		String bo  = "false";
		System.out.println("id : " + id);
		BufferedOutputStream bs = null;
		
		
		if(marray != null) {
			bo = "true";			
			System.out.println("if문 진입");

			try {
				bs = new BufferedOutputStream(new FileOutputStream(filepath+id+".txt"));
			 
				for(int i = 0; i < marray.length; i++){
					
					System.out.println("전송된 메시지 : " + marray[i]);
					
					bs.write(marray[i].getBytes());
				}			
				bs.flush();
			} catch (Exception e) {
		            System.out.println("오류 : " +e.getMessage());
		            bo  = "false";
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
		

		@RequestMapping(value="import.ajax", method=RequestMethod.POST)
		private List<String> importText(String id){
			
		System.out.println("This is Chatting Controller");
		
		System.out.println("id : " + id);
		
		  List<String> list = null;
		  BufferedReader br = null;

		  if ( !(filepath==null)) {
			  list = new ArrayList<String>();
		   try {
		    br = new BufferedReader(new FileReader(filepath+id+".txt"));
		    String s;

		    while ((s = br.readLine()) != null) {
		    	list.add(s);
		    }
		    br.close();
		   } catch (IOException e) {
		    System.err.println(e);
		   }finally{
		    try { if( br != null ) { br.close(); } } catch(Exception ex) { }
		   }
		  }

		  return list;
		 }
	
	
}
