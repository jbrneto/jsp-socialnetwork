<%@page import="java.util.ArrayList"%>
<%@page import="utils.DataBaseUtils"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="utils.AmigosUtils"%>
<%
ArrayList<AmigosUtils> amg = (ArrayList<AmigosUtils>) session.getAttribute("amigos");
String idUsuario = request.getParameter("idUser");
int max = amg.size();
int i = 0;
for (AmigosUtils a : amg) {
	ResultSet rsNovas = DataBaseUtils.executeQuery("SELECT lida FROM mensagem WHERE idusuarioOrigem = "+a.getIdUsuario()+" AND idusuarioDestino = "+idUsuario+" ORDER BY data DESC;");
	if(rsNovas.first()){
		if(rsNovas.getInt("lida") == 0){
			if(i < max){
				out.print(a.getIdUsuario()+"-");
			}
			i++;
		}
	}
}
%>