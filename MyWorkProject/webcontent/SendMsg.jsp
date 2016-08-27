<%@page import="utils.DataBaseUtils"%>
<%@page import="java.sql.ResultSet"%>
<%
String idUser = request.getParameter("idUser");
String idAmigo = request.getParameter("idAmigo");
String msg = request.getParameter("msg");

	DataBaseUtils.executeUpdate("INSERT INTO mensagem (idusuarioDestino,idusuarioOrigem,data,mensagem,lida) VALUES ("+idAmigo+","+idUser+",now(),'"+msg+"',0);");
%>