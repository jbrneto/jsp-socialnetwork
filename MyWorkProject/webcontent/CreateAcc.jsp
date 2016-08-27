<%@page import="utils.UserUtils"%>
<%@page import="utils.MD5Utils"%>
<%@page import="utils.DataBaseUtils"%>
<%@page import="java.sql.ResultSet"%>
<%
String nomeC = request.getParameter("nomeC");
String sobrenomeC = request.getParameter("sobrenomeC");
String senhaC = request.getParameter("senhaC");
String loginC = request.getParameter("loginC");
String emailC = request.getParameter("emailC");
String telefoneC = request.getParameter("telefoneC");
String cargoC = request.getParameter("cargoC");
String setorC = request.getParameter("setorC");
String generoC = request.getParameter("generoC");
String fotoC = request.getParameter("fotoC");
if("".equals(nomeC) ||"".equals(sobrenomeC) ||"".equals(senhaC) ||"".equals(loginC) ||"".equals(emailC) ||"".equals(telefoneC) ||"".equals(cargoC) ||"".equals(setorC) ||"".equals(generoC)){
	response.sendRedirect("login.jsp?erro=emptyField");
}else{
		senhaC = MD5Utils.getMD5(senhaC);
		try{
			DataBaseUtils.executeUpdate("INSERT INTO usuario (nome,sobrenome,senha,login,email,foto,telefone,cargo,setor,genero) VALUES "
					+"('"+nomeC+"','"+sobrenomeC+"','"+senhaC+"','"+loginC+"','"+emailC+"','"+fotoC+"','"+telefoneC+"','"+cargoC+"','"+setorC+"',"+generoC+");");
			response.sendRedirect("login.jsp?sucess=true");
		}catch(Exception e){
			//e.printStackTrace();
			if(e.getMessage().startsWith("duplicate")){
				response.sendRedirect("login.jsp?erro=doubleLogin");
			}else {
				response.sendRedirect("login.jsp?erro=connection"); 
				//out.println(e.getMessage());
			}
		}
	
}
%>