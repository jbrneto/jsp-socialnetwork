<%@page import="java.lang.reflect.Array"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utils.DataBaseUtils"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="utils.AmigosUtils"%>
<%
String idUsuario = request.getParameter("idusuario");
ArrayList<AmigosUtils> amg = (ArrayList<AmigosUtils>) session.getAttribute("amigos");

ResultSet rs = DataBaseUtils.executeQuery("SELECT u.idusuario AS idUsuario, concat(u.nome,' ',u.sobrenome) AS nome, u.foto AS fotoUsuario, m.idmensagem AS idMensagem, m.data AS data, m.idusuarioDestino AS idDestino FROM usuario u LEFT JOIN mensagem m "
		+"ON m.idusuarioOrigem = u.idusuario OR m.idusuarioDestino = u.idusuario WHERE m.idusuarioDestino = "+idUsuario+" OR m.idusuarioOrigem = "+idUsuario+" ORDER BY m.data DESC LIMIT 1000;");

if(amg == null){
	amg = new ArrayList<AmigosUtils>();
		
	while(rs.next()/*  && amg.size() <= 7  */){
		
		AmigosUtils amigo = new AmigosUtils();
		boolean ex = true;
		
		if(rs.getString("idUsuario").equals(idUsuario)){
			for (AmigosUtils a : amg) {
				if (a.getIdUsuario() == rs.getInt("idDestino")) {
					ex = false;
					break; 
				}
			}
			if(ex){
				ResultSet rs1 = DataBaseUtils.executeQuery("SELECT * FROM usuario WHERE idusuario = "+rs.getString("idDestino")+";");
				if(rs1.next()){
					amigo.setIdUsuario(rs1.getInt("idusuario"));
					amigo.setFoto(rs1.getString("foto"));
					amigo.setNome(rs1.getString("nome"));
				}
			}
		}
		else{
			amigo.setIdUsuario(rs.getInt("idUsuario"));
			amigo.setFoto(rs.getString("fotoUsuario"));
			amigo.setNome(rs.getString("nome"));
		}
		
		if(ex){
			for (AmigosUtils a : amg) {
				if (a.getIdUsuario() == amigo.getIdUsuario()) {
					ex = false;
					break;
				}
			}
		}	
		if(ex){
			amg.add(amigo);
			out.println("<a class='collection-item' onclick='showChat(\"amg-"+amigo.getIdUsuario()+"\")'><img src='"+amigo.getFoto()+"' class='circle' style='height: 50px; width: 50px;'><span class='nome-msg blue-text'>"+amigo.getNome()+"</span> <span class='novaMsg' id='novaMsg-"+amigo.getIdUsuario()+"'></span></a>");
			out.println("<div status='0' class='msg-panel col l12 s12' id='amg-"+amigo.getIdUsuario()+"' style='display: none;'>");
				out.println("<div class='container-msg col l12 s12' id='chat-"+amigo.getIdUsuario()+"'>");
				out.println("</div>");
				out.println("<input onKeyDown='if(event.keyCode==13) sendMsg(\""+amigo.getIdUsuario()+"\")' placeholder='Mensagem ...' type='text' class='validate col l12 s12 white' id='campoMsg-"+amigo.getIdUsuario()+"'>");
			out.println("</div>");
		}
	}
}
else{
	if(rs.next()){
		while(rs.next()){
			boolean ex = true;
			for (AmigosUtils a : amg) {
				if (a.getIdUsuario() == rs.getInt("idUsuario")) {
					ex = false;
					break;
				}
			}
			if(ex){
				AmigosUtils amigo = new AmigosUtils();
				amigo.setIdUsuario(rs.getInt("idUsuario"));
				amigo.setFoto(rs.getString("fotoUsuario"));
				amigo.setNome(rs.getString("nome"));
				amg.add(amigo);
				out.println("<a class='collection-item' onclick='showChat(\"amg-"+amigo.getIdUsuario()+"\")'><img src='"+amigo.getFoto()+"' class='circle' style='height: 50px; width: 50px;'><span class='nome-msg blue-text'>"+amigo.getNome()+"</span></a>");
				out.println("<div status='0' class='msg-panel col l12 s12' id='amg-"+amigo.getIdUsuario()+"' style='display: none;'>");
				out.println("<div class='container-msg col l12 s12' id='chat-"+amigo.getIdUsuario()+"'>");
				out.println("</div>");
				out.println("<input onKeyDown='if(event.keyCode==13) sendMsg(\""+amigo.getIdUsuario()+"\")' placeholder='Mensagem ...' type='text' class='validate col l12 s12 white' id='campoMsg-"+amigo.getIdUsuario()+"'>");
				out.println("</div>");
			}
		}
	}
}
session.setAttribute("amigos", amg);
//out.println("<input onKeyDown='if(event.keyCode==13) sendMsg()' placeholder='Mensagem ...' type='text' class='validate col l12 s12 white' id='msg'>");
//out.println("<p class='chip blue lighten-3'>AEOO</p>");
%>