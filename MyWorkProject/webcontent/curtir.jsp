<%@page import="java.sql.ResultSet"%>
<%@page import="utils.DataBaseUtils"%>
<%
String idPost =  request.getParameter("idPost");
String idUser = request.getParameter("idUser");
DataBaseUtils.executeQuery("SELECT curtir("+idPost+","+idUser+")");
ResultSet rs = DataBaseUtils.executeQuery("SELECT getCurtidas("+idPost+") AS curtidas, getCurtidores("+idPost+") AS curtidores FROM postagem WHERE idpostagem = "+idPost+";");
if(rs.next()){
	out.println("<div class='col s8 l8 left'>");
	out.println("<span id=\"curtidas-"+idPost+"\">"+rs.getInt("curtidas")+"</span> pessoas curtiram isso");
out.println("</div>");

	out.println("<div class='col l12 s12'>");
	
	String curtidores = "";
	if(rs.getString("curtidores") != null){
		curtidores = rs.getString("curtidores");
	}
	out.println("<p id=\"curtidores-"+idPost+"\" class='truncate curtidores' onmouseover='$(this).toggleClass(\"truncate\")' onmouseout='$(this).toggleClass(\"truncate\")'>Curtidores: "+curtidores+"</p>");
	
	out.println("</div>");
}
%>