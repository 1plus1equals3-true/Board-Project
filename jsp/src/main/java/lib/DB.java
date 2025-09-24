package lib;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.*;

public class DB {
   
   public static Connection getConnection() throws Exception{
      
      String jdbcUrl = "jdbc:mysql://localhost:3306/jsp_db";
      String dbId = "user"; // 설정된 id
      String dbPass = "1234"; // 설정된 password
 
      Class.forName("com.mysql.cj.jdbc.Driver"); 
      Connection con = DriverManager.getConnection(jdbcUrl,dbId ,dbPass);
      
      return con;
   }
   
   public static String  Encoder(String text) {
	   if (text != null){
			try{
				return URLEncoder.encode(text, StandardCharsets.UTF_8);
			}catch(Exception e){
				e.printStackTrace();
				return "";
			}
		}else {
			return "";
		}
   }
   
   public static String  Decoder(String text) {
	   if (text != null){
			try{
				return URLDecoder.decode(text, StandardCharsets.UTF_8);
			}catch(Exception e){
				e.printStackTrace();
				return "";
			}
		}else {
			return "";
		}
   }
   
   public static String errMsg(String alert, String loc) {
	   if(loc.equals("back")) {
		   return "<script> alert(\""+alert+"\"); history.back(); </script>";
	   }
	   return "<script> alert(\""+alert+"\"); location.replace(\""+loc+"\"); </script>";
   }
   
   public static String subStr(String str, int byteLength, String dot) {
       
	      if (str == null) {
	         return null;
	      }
	        
	        java.nio.charset.Charset charset = java.nio.charset.Charset.forName("UTF-8");
	        
	        byte[] bytes = str.getBytes(charset);

	        if (bytes.length <= byteLength) {
	            return str;
	        }

	        int cutLength = byteLength;
	        while (cutLength > 0 && (bytes[cutLength] & 0xC0) == 0x80) {
	            cutLength--;
	        }
	        
	        if(dot == null || dot.equals(""))
	        {
	           dot = "...";
	        }
	        
	        String curStr = new String(bytes, 0, cutLength, charset) + dot;

	        return curStr;
	    }
}