<%@page import="utils.DataBaseUtils"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="utils.UserUtils"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
UserUtils user = (UserUtils) session.getAttribute("user");

if (user == null) {
	response.sendRedirect("login.jsp?erro=loginError");
	return;
}
String iduser = request.getParameter("idUser");
String pesq = request.getParameter("pesq");

ResultSet rs = DataBaseUtils.executeQuery("SELECT * FROM usuario WHERE login LIKE '%"+pesq+"%' OR nome LIKE '%"+pesq+"%' OR sobrenome LIKE '%"+pesq+"%' OR email LIKE '%"+pesq+"%' OR telefone LIKE '%"+pesq+"%' OR cargo LIKE '%"+pesq+"%' OR setor LIKE '%"+pesq+"%';");
%>
<html>
<head>
<link href="css/materialize.min.css" rel="stylesheet"></link>
<link href="css/MW.css" rel="stylesheet"></link>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
<script src="js/jquery-2.2.0.min.js"></script>
<script src="js/materialize.min.js"></script>
<title>MyWork-Pesquisa</title>
</head>
<script type="text/javascript">
function fecharAba(){
	if (confirm("Deseja sair?")) {
		close();
	}
}
function voltar(){
	if (confirm("Deseja sair?")) {
		window.location.replace("index.jsp");
	}
}
function pesquisar(){
	window.location.replace("Pesquisa.jsp?idUser="+<%=iduser%>+"&&pesq="+document.getElementById("pesquisa").value);
}
function novosPost(){
	setInterval(function novos(){
		$.post("newPosts.jsp", {
			idUser :<%=iduser%>,
			nPost : "true"
		}, function(data,status) {
			doc("novosPost").innerHTML = data;
		});
	}, 5000);
}
</script>
<body class="row fundo">
<script type="text/javascript">novosPost()</script>
	<div class="navbar-fixed" id="profile">
		<nav>
		<div class="nav-wrapper blue" style="cursor: pointer">
			<a href="#!" class="brand-logo center">MyWork</a>
			<ul class="right hide-on-med-and-down">
				<li><a href="index.jsp">Início<span class="badge white-text" id="novosPost"></span></a></li>
				<li><a href="Perfil.jsp?idUserLogado=<%=iduser%>">Perfil</a></li>
				<li><a href="login.jsp?logoff=true">Logoff</a></li>
			</ul>
		</div>
		</nav>
	</div>
		<div class="container">
		<div class="col l12 s12" id="divPerfil">
			<div class='collection borda white'>
			<p class='titulo'>Usuários Encontrados para: <%=pesq%></p>
			<span class="blue-text col l1 s12 left">Pesquise por: </span>
			<input onKeyDown='if(event.keyCode==13) pesquisar()' type='text' class='validate col l11 s12' id='pesquisa' value="<%=pesq%>">
			<br><br>
			<div class="collection col l12 s12">
			<%
			if(rs.first()){
					while(rs.next()){
						try{
							out.println("<a class='collection-item col l12 s12' target='_blank' href='Perfil.jsp?idUser="+rs.getString("idusuario")+"'>");
							out.println("<div class='col l12 s12'><img src='"+rs.getString("foto")+"' class='circle col l6 s6'' style='height: 100px; width: 100px;'>"
							+"<span class='nome-msg blue-text col l6 s6''>"+rs.getString("nome")+" "+rs.getString("sobrenome")+"</span></div>");
							out.println("<p class='blue-text col l4 s6'>Login: "+rs.getString("login")+"</p>");
							out.println("<p class='blue-text col l4 s6'>E-mail: "+rs.getString("email")+"</p>");
							out.println("<p class='blue-text col l4 s6'>Telefone: "+rs.getString("telefone")+"</p>");
							out.println("<p class='blue-text col l4 s6'>Cargo: "+rs.getString("cargo")+"</p>");
							out.println("<p class='blue-text col l4 s6'>Setor: "+rs.getString("setor")+"</p>");
							if(rs.getString("genero").equals("0")){
								out.println("<p class='blue-text col l4 s6'>Gênero: Masculino</p>");
							}else out.println("<p class='blue-text col l4 s6'>Gênero: Feminino</p>");
							out.println("</a>");
						}catch(Exception e){
							out.println("<p class='blue-text col l4 s6'>Nenhum resultado encontrado!</p>");
						}
					}
			}else{
				out.println("<p class='blue-text col l4 s6'>Nenhum resultado encontrado!</p>");
			}
			%>
			</div>
			</div>
		</div>
	</div>
</body>
</html>