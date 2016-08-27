<%@page import="utils.DataBaseUtils"%>
<%@page import="java.sql.ResultSet"%>
<%
String id = request.getParameter("id");
String idUser = request.getParameter("idUser");

ResultSet rs = DataBaseUtils.executeQuery("SELECT p.idpostagem AS idpostagem, p.idpostagem_comentario AS postagemComentario, p.postagem AS postagem, p.data AS data, u.idusuario AS idUsuarioPostagem, CONCAT(u.nome,' ', u.sobrenome ) AS usuarioPostagem, u.foto AS fotoUsuario,getCurtidas(p.idpostagem) AS curtidas, getCurtidores(p.idpostagem) AS curtidores,IF((SELECT c.idcurtida FROM curtida c WHERE c.idpostagem = p.idpostagem AND c.idusuario = '"+idUser+"') IS NULL, 0, 1)  AS curti FROM postagem p LEFT JOIN usuario u ON u.idusuario = p.idusuario WHERE p.idpostagem_comentario IS NULL AND p.idpostagem = '"+id+"';");
if(rs.next()){
	out.println("<div id='divPost-"+rs.getInt("idpostagem")+"'>");
	out.println("<div class='card col l12 s12'>");
	out.println("<img src='"+rs.getString("fotoUsuario")+"' style='height: 100px; width: 100px;' class='circle col l2 s2 image-centralizar'>");


	out.println("<div class='col l10 s10 right'>");
	out.println("<a class='nome-post' target='_blank' href='Perfil.jsp?idUser="+rs.getString("idUsuarioPostagem")+"'>"+rs.getString("usuarioPostagem")+"</a><span class='texto-detalhes'> Em: "+rs.getString("data")+"</span><br>");
		out.println("<span class='conteudo-post'>"+rs.getString("postagem")+"</span>");
		out.println("<hr class='hrMW'>");
		out.println("<div id='"+rs.getInt("idpostagem")+"' name='like' class='col s4 l4'>");
			if(rs.getInt("curti") == 0){
				out.println("<button class='like-button' onclick='curtir("+rs.getInt("idpostagem")+")'>Curtir</button>");
			}else{
				out.println("<button class='liked-button' onclick='curtir("+rs.getInt("idpostagem")+")'>Descurtir</button>");
			}
		out.println("</div>");
		out.println("<div class='col s8 l8 left'>");
			out.println("<span id='curtidas'>"+rs.getInt("curtidas")+"</span> pessoas curtiram isso");
		out.println("</div>");
		if(rs.getString("curtidores") != null){
			out.println("<div class='col l12 s12'>");
			out.println("<p class='truncate curtidores' onmouseover='$(this).toggleClass(\"truncate\")' onmouseout='$(this).toggleClass(\"truncate\")'>Curtidores: "+rs.getString("curtidores")+"</p>");
			out.println("</div>");
		}
	out.println("</div>");


	out.println("<div class='collection borda white divComentario col l12 s12'>");
		out.println("<input placeholder='Comente aqui...' id='coment-"+rs.getInt("idpostagem")+"' type='text' class='validate col s10 l10'>");
		out.println("<button class='col s2 l2 btn waves-effect waves-light blue pub-button' onclick='publicar(\"coment-"+rs.getInt("idpostagem")+"\")'>Comentar</button>");
	out.println("</div>");

	ResultSet rs2 = DataBaseUtils.executeQuery("SELECT p.idpostagem AS idpostagem, p.idpostagem_comentario AS postagemComentario, p.postagem AS postagem, p.data AS data, u.idusuario AS idUsuarioPostagem, CONCAT(u.nome,' ', u.sobrenome ) AS usuarioPostagem, u.foto AS fotoUsuario, getCurtidas(p.idpostagem) AS curtidas, getCurtidores(p.idpostagem) AS curtidores, IF((SELECT c.idcurtida FROM curtida c WHERE c.idpostagem = p.idpostagem AND c.idusuario = "+idUser+") IS NULL, 0, 1)  AS curti FROM postagem p  LEFT  JOIN usuario u ON u.idusuario = p.idusuario WHERE p.idpostagem_comentario = "+rs.getInt("idpostagem")+" ORDER BY idpostagem desc LIMIT 50;");
	while(rs2.next()){
		out.println("<div id='divPost-"+rs2.getString("idpostagem")+"'>");
		out.println("<div class='card col l12 s12 comentario right'>");
			out.println("<div class='col l2 s2'>");
				out.println("<img src='"+rs2.getString("fotoUsuario")+"' style='height: 100px; width: 100px;' class='circle col l2 s2 image-centralizar'>");
			out.println("</div>");
			out.println("<div class='col l10 s10'>");
			out.println("<a class='nome-post' target='_blank' href='Perfil.jsp?idUser="+rs2.getString("idUsuarioPostagem")+"'>"+rs2.getString("usuarioPostagem")+"</a><span class='texto-detalhes'> Em: "+rs.getString("data")+"</span><br>");
			out.println("<p class='conteudo-post'>"+rs2.getString("postagem")+"</p>");
			out.println("<hr class='hrMW'>");
			
			out.println("<div id='"+rs2.getInt("idpostagem")+"' name='like' class='col s4 l4'>");
				if(rs2.getInt("curti") == 0){
					out.println("<button class='like-button' onclick='curtir("+rs2.getInt("idpostagem")+")'>Curtir</button>");
				}else{
					out.println("<button class='liked-button' onclick='curtir("+rs2.getInt("idpostagem")+")'>Descurtir</button>");
				}
			out.println("</div>");
			
			out.println("<div class='col s8 l8 left'>");
				out.println("<span id='curtidas'>"+rs2.getInt("curtidas")+"</span> pessoas curtiram isso");
				if(rs2.getString("curtidores") != null){
					out.println("<p class='truncate curtidores' onmouseover='$(this).toggleClass(\"truncate\")' onmouseout='$(this).toggleClass(\"truncate\")'>Curtidores: "+rs2.getString("curtidores")+"</p>");
				}
			out.println("</div>");
			out.println("</div>");
			
		out.println("</div>");
		out.println("</div>");
	}
	out.println("</div>");
	out.println("</div>");
}
%>