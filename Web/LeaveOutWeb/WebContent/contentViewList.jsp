<!-- mapbounds -->

<%@ page language="java" contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>

<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

	<script>
	var slideIndex = 1; // �ʱ������� 
	
	function plusDivs(n , contentseq) {
	  showDivs(slideIndex += n, contentseq);
	}
	
	function showDivs(n, contentseq) {
	  var i;
	  var x = document.getElementsByClassName("mySlides"+contentseq);
	  if (n > x.length) {slideIndex = 1}    
	  if (n < 1) {slideIndex = x.length}
	  for (i = 0; i < x.length; i++) {
	     x[i].style.display = "none";  
	  }
	  $("#mypage"+contentseq).text(slideIndex); // ���������� ����
	  $("#totalpage"+contentseq).text(x.length); // total ������ ����
	  x[slideIndex-1].style.display = "block";
	}
	</script>

	<script>
	function content_default_Img(contentseq) {
		document.getElementById("contentImg" + contentseq).src = "profile_default.jpg";
	}
	
	function comment_default_Img(commentseq) {
		document.getElementById("commentImgName" + commentseq).src = "profile_default.jpg";
	}
	</script>

	<ul class="list-group">
		<li class="list-group-item">
			<div class="media">
				<%
				PreparedStatement pstmt7=null;
				ResultSet rs7=null;
				String contentNum = null;
				String contentTarget = null;
				String contentPicTarget = null;
				String profilePicTarget = null;
				int imgseq=1;
				int contentseq=0;
				int commentseq=0;
				
				try {
					pstmt7=conn.prepareStatement("SELECT * from content where loc_x=? && loc_y=? ORDER BY reg_time desc;");
					pstmt7.setString(1,Locx);
					pstmt7.setString(2,Locy);
					rs7=pstmt7.executeQuery();  	

					while(rs7.next()){
						contentseq++;
						String regtime = rs7.getString("reg_time");
						contentPicTarget = ".\\leaveout\\files\\"+rs7.getInt("user_num")+"\\profile\\1.jpg";
						String contentImgName = "contentImg" + contentseq;
						
						// content�� ������ ����
						out.println("<a class='pull-left' href='profileDetails.jsp?user_num="+userNumString+"&target_user="+rs7.getInt("user_num")+"&locx=36&locy=128'>");
						out.println("<img class='media-object' id="+contentImgName+" src="+contentPicTarget+" onerror='content_default_Img("+contentseq+");' width='50' height='50'></a>");
						
						// ���� �ð�
						out.println("<h4 class='media-heading'>"+rs7.getString("address")+"<br></h4>");
						out.println("<i class='glyphicon glyphicon-flag'></i>"+regtime.substring(0, regtime.length()-2)+"<br>");
						
						// ���� ���� ��� ����
						File path = new File("C:\\Users\\bu456\\eclipse-workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps"
								           + "\\LeaveOutWeb\\leaveout\\files\\"+rs7.getInt("user_num")+"\\content\\"+rs7.getString("content_num"));
						String files[] = path.list();
						int number = files.length - 1;
						for(int i = 0; i < files.length; i++) {
							if(files[i].equals("comment")) {
								number -= 1;
							}
						}
						
						// class, id name ����
						String slidename = "mySlides"+imgseq;
						String mypage = "mypage"+imgseq;
						String totalpage = "totalpage"+imgseq;
						
						// �̹��� ���� (slide)
						out.println("<div class='w3-content w3-display-container'>");
						for(int i = 1; i <= number; i++){
							contentPicTarget = ".\\leaveout\\files\\"+rs7.getInt("user_num")+"\\content\\"+rs7.getString("content_num")+"\\"+i+".jpg";
							out.println("<img class="+slidename+" src="+contentPicTarget+" style='width:100%; height:70%'/>");
						}
						
						if(number > 1) {
							// �����ȿ� ������ ��
							out.println("<div class='carousel-caption'>");
							out.println("<b id="+mypage+" style='color:#2A241A'></b>"); // ���������� -> javascript�� �ݿ�
							out.println("<b id='temp' style='color:#2A241A'>/</b>");
							out.println("<b id="+totalpage+" style='color:#2A241A'></b>"); // total������ -> javascript�� �ݿ�
							out.println("</div>");
							// End - �����ȿ� ������ ��
							
							// �̹��� ���� button ( "<" ">" )
							out.println("<button class='w3-button w3-black w3-display-left' onclick='plusDivs(-1, "+imgseq+")'>&#10090;</button>");
							out.println("<button class='w3-button w3-black w3-display-right' onclick='plusDivs(1, "+imgseq+")'>&#10091;</button>");
							out.println("</div>");
							// End �̹��� ����
						}
						
						//�ؽ�Ʈ ���� ��ġ ��ǻ�� ���� ��� ����
						contentTarget = "C:\\Users\\bu456\\eclipse-workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps"
						+ "\\LeaveOutWeb\\leaveout\\files\\"+rs7.getInt("user_num")+"\\content\\"+rs7.getString("content_num")+"\\text.txt";
						
						// �۳��� ����
						FileReader fr = new FileReader(contentTarget); //�����бⰴü����
						BufferedReader br = new BufferedReader(fr); //���۸�����ü����
						String line = null; 
						while((line=br.readLine())!=null){ //���δ��� �б�
						    out.println(line); 
						}
						out.println("<hr>");
						br.close();
						fr.close();
						
						// �ʱ� �̹��� ����
						out.println("<script>");
						if(number > 1) {
							for(int i = 1; i <= imgseq; i++){
								out.println("showDivs(1, "+i+");");
							}
							imgseq++;
						}
						out.println("</script>");
						
						File commentpath = new File(path + "\\comment");
						try {
							// ���� �� �ð�
							PreparedStatement commentinfops=null;
							ResultSet commentinfors=null;
									
							commentinfops=conn.prepareStatement("select user.name, comment.user_num, comment.reg_time, comment.content_num, comment.comm_num from comment " +
									                            "INNER JOIN user on user.user_num = comment.user_num " +
									                            "where content_num = ? " +
									                            "ORDER BY reg_time desc");
							commentinfops.setString(1,rs7.getString("content_num"));
							commentinfors=commentinfops.executeQuery();
							
							while(commentinfors.next()){
								commentseq++;
								String commentImgName = "commentImgName" + commentseq;
								String commentImagePath = ".\\leaveout\\files\\"+commentinfors.getInt("user_num")+"\\profile\\1.jpg";
								String commentTarget = "C:\\Users\\bu456\\eclipse-workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps"
										+ "\\LeaveOutWeb\\leaveout\\files\\"+rs7.getString("user_num")+"\\content\\"+commentinfors.getInt("content_num")+
										  "\\comment\\"+commentinfors.getInt("user_num");
								
								File commentseqpath = new File(commentTarget);
								String commetReaderpath = commentTarget + "\\" + commentinfors.getInt("comm_num") + "\\text.txt";
								String commetseq = "/leaveout/files/"+rs7.getString("user_num")+"/content/"+commentinfors.getInt("content_num")+
										           "/comment/"+commentinfors.getInt("user_num")+"/"+commentinfors.getInt("comm_num");
								
								FileReader fr2 = new FileReader(commetReaderpath); //�����бⰴü����
								BufferedReader br2 = new BufferedReader(fr2); //���۸�����ü����
								
								out.println("<div class='media'>");
								out.println("<a class='pull-left' href='profileDetails.jsp?user_num="+userNumString+"&target_user="+commentinfors.getInt("user_num")+"&locx=36&locy=128'>");
								out.println("<img src="+commentImagePath+" id="+commentImgName+" onerror='comment_default_Img("+commentseq+");' width='50' height='50'></a>");
								out.println("<div class='media-body'>");
									
								out.println("<h5 class='media-heading'>");
								String line2 = null; 
								while((line2=br2.readLine())!=null){ //���δ��� �б�
								    out.println(line2); 
								}
								out.println("</h5>");
								
								String time = commentinfors.getString("reg_time");
								out.println(commentinfors.getString("name")+"���� ���<br>");
								out.println(time.substring(0, time.length()-2)+"<br>");
								out.println("</div>");
								out.println("</div>");
							}
						} catch(Exception ex) {
						}
						out.println("<br>");
						
						String areaid = "textarea" + contentseq;
						String makefilepath = "/leaveout/files/"+rs7.getInt("user_num")+"/content/"+rs7.getString("content_num")+
                                			  "/comment";
						
						out.println("<div");
						out.println("<label>");
						out.println("<i class='glyphicon glyphicon-font'></i> ����� �Է����ּ���.<br>");
						out.println("</label><div>");
						
						out.println("<form method='post' action='CommentProccess.jsp'");
						out.println("<input type='hidden' name='hiddenarea'></input>");
						out.println("<input type='hidden' name='makefilepath' value="+makefilepath+"></input>");
						out.println("<input type='hidden' name='targetUserNumString' value="+rs7.getInt("user_num")+"></input>");
						out.println("<input type='hidden' name='content_num' value="+rs7.getString("content_num")+"></input>");
						out.println("<input type='hidden' name='locx' value="+Locx+"></input>");
						out.println("<input type='hidden' name='locy' value="+Locy+"></input>");
						out.println("<input type='hidden' name='userNumString' value="+userNumString+"></input>");
						out.println("<input type='hidden' name='jspName' value='contentView.jsp'></input>");
						out.println("<div class='row'>");
						out.println("<div class='col-md-10'>");
						out.println("<textarea class='form-control' id="+areaid+" name='textarea' rows='3' placeholder='�� ������ �Է��� �ּ���.'></textarea></div>");
						out.println("<div class='col-md-2'>");
						out.println("<button type='submit' class='btn btn-default' style='height:76px' onclick='commentsubmit("+contentseq+")'>�Ϸ�</button></div></div></form><br>");
					}
				}catch(Exception e){
					e.printStackTrace();
				}
				
				%>
			</div>
	    </li>
	</ul>
	