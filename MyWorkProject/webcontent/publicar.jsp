<%@page import="java.util.Date"%>
<%@page import="utils.DataBaseUtils"%>
<%@page import="java.sql.ResultSet"%>
<%
String idComentario = request.getParameter("idComentario");
String idUsuario = request.getParameter("idUsuario");
String post = request.getParameter("post");

if(idComentario != null){
	DataBaseUtils.executeUpdate("INSERT INTO postagem (idpostagem_comentario,idusuario,postagem,data) VALUES ("+idComentario+","+idUsuario+",'"+post+"',NOW())");
}else{
	DataBaseUtils.executeUpdate("INSERT INTO postagem (idusuario,postagem,data) VALUES ("+idUsuario+",'"+post+"',NOW())");
}
%>