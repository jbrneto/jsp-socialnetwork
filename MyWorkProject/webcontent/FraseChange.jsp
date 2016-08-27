<%@page import="utils.DataBaseUtils"%>
<%@page import="java.sql.ResultSet"%>
<%
	String idUser = request.getParameter("idUser");
	String frase = request.getParameter("frase");
	DataBaseUtils.executeUpdate("UPDATE usuario SET frase = '"+frase+"' WHERE idusuario="+idUser+";");
%>