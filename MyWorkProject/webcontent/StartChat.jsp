<%@page import="utils.DataBaseUtils"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="utils.AmigosUtils"%>
<%@page import="java.util.ArrayList"%>
<%
String idUser = request.getParameter("idUser");
String idAmigo = request.getParameter("idAmigo");

ResultSet rs = DataBaseUtils.executeQuery("SELECT * FROM mensagem m  WHERE idusuarioOrigem = "+idUser+" AND idusuarioDestino=  "+idAmigo+" OR idusuarioOrigem = "+idAmigo+" AND idusuarioDestino = "+idUser+" ORDER BY data;");

	while(rs.next()){
		if(rs.getString("idusuarioOrigem").equals(idUser)){
			out.println("<div class='col l12 s12'>");
				out.println("<p class='mensagemBox-Me right'><span class='quebra-de-linha'>"+rs.getString("mensagem")+"</span><br><span class='data-Msg'>"+rs.getString("data")+"</span></p>");
			out.println("</div>");
		}else{
			out.println("<div class='col l12 s12'>");
				out.println("<p class='mensagemBox-You left'><span class='quebra-de-linha'>"+rs.getString("mensagem")+"</span><br><span class='data-Msg'>"+rs.getString("data")+"</span></p>");
			out.println("</div>");
		}
	}
	DataBaseUtils.executeUpdate("UPDATE mensagem SET lida = 1 WHERE idusuarioDestino = "+idUser+" AND idusuarioOrigem = "+idAmigo+";");
%>