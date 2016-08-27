<%@page import="utils.UserUtils"%>
<%@page import="utils.MD5Utils"%>
<%@page import="utils.DataBaseUtils"%>
<%@page import="java.sql.ResultSet"%>
<%
UserUtils user = (UserUtils) session.getAttribute("user");
if(user == null){
	response.sendRedirect("login.jsp?erro=expireSession");
	return;
}
String nome = request.getParameter("nome");
String sobrenome = request.getParameter("sobrenome");
String senha = request.getParameter("senha");
String login = request.getParameter("login");
String email = request.getParameter("email");
String telefone = request.getParameter("telefone");
String cargo = request.getParameter("cargo");
String setor = request.getParameter("setor");
String genero = request.getParameter("genero");
String foto = request.getParameter("foto");
out.println("<script>alert('"+senha+"')</script>");

if("".equals(nome) ||"".equals(sobrenome) ||"".equals(login) ||"".equals(email) ||"".equals(telefone) ||"".equals(cargo) ||"".equals(setor) ||"".equals(genero)){
	response.sendRedirect("Perfil.jsp?erro=emptyField");
}else{
	if(senha != null && !senha.equals("")){
		out.println("<script>alert('"+senha+" e passou')</script>");
		senha = MD5Utils.getMD5(senha);
		try{
			DataBaseUtils.executeUpdate("UPDATE usuario SET nome='"+nome+"', sobrenome='"+sobrenome+"', senha='"+senha+"', login='"+login+"', email='"+email+"', foto='"+foto+"', telefone='"+telefone+"', cargo='"+cargo+"', setor='"+setor+"', genero="+genero+" WHERE idusuario="+user.getIdusuario()+";");
			response.sendRedirect("login.jsp?sucess=trueEdit");
		}catch(Exception e){
			e.printStackTrace();
			if(e.getMessage().startsWith("duplicate")){
				response.sendRedirect("Perfil.jsp?erro=doubleLogin");
			}else {
				response.sendRedirect("Perfil.jsp?erro=connection"); 
				out.println(e.getMessage());
			}
		}
	}else{
		out.println("<script>alert('"+senha+" e nao passou')</script>");
		try{
			DataBaseUtils.executeUpdate("UPDATE usuario SET nome='"+nome+"', sobrenome='"+sobrenome+"', login='"+login+"', email='"+email+"', foto='"+foto+"', telefone='"+telefone+"', cargo='"+cargo+"', setor='"+setor+"', genero="+genero+" WHERE idusuario="+user.getIdusuario()+";");
			response.sendRedirect("login.jsp?sucess=trueE");
		}catch(Exception e){
			//e.printStackTrace();
			if(e.getMessage().startsWith("duplicate")){
				response.sendRedirect("Perfil.jsp?erro=doubleLogin");
			}else {
				response.sendRedirect("Perfil.jsp?erro=connection"); 
			//out.println(e.getMessage());
			}
		}
	}
}
%>