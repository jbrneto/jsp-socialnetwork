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
String iduserlogado = request.getParameter("idUserLogado");
String iduser = request.getParameter("idUser");

UserUtils userInfo = new UserUtils();

String erro = request.getParameter("error");
if(erro != null){
	if(erro.equals("emptyField")){
		out.println("<script>alert('Você deve preencher todos os campos (exceto Senha e Foto)!')</script>");
	}else if (erro.equals("doubleLogin")) {
		out.println("<script>alert('Ja existe um usuário com este Login!')</script>");
	}else if (erro.equals("connection")) {
		out.println("<script>alert('Erro de conexão!')</script>");
	}
}

ResultSet rs;
if(iduserlogado == null){
	rs = DataBaseUtils.executeQuery("SELECT * FROM usuario WHERE idusuario = "+iduser+";");
}else{
	rs = DataBaseUtils.executeQuery("SELECT * FROM usuario WHERE idusuario = "+iduserlogado+";");
}
if(rs.next()){
	userInfo.setIdusuario(rs.getInt("idusuario"));
	userInfo.setNome(rs.getString("nome"));
	userInfo.setSobrenome(rs.getString("sobrenome"));
	if(iduserlogado != null){
		userInfo.setSenha(rs.getString("senha"));
	}
	userInfo.setLogin(rs.getString("login"));
	userInfo.setEmail(rs.getString("email"));
	userInfo.setFoto(rs.getString("foto"));
	userInfo.setTelefone(rs.getString("telefone"));
	userInfo.setCargo(rs.getString("cargo"));
	userInfo.setSetor(rs.getString("setor"));
	userInfo.setGenero(rs.getInt("genero"));
	userInfo.setFrase(rs.getString("frase"));
	if(userInfo.getFrase() == null){
		userInfo.setFrase("");
	}
}
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
<title>MyWork-Perfil</title>
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
function limparCampos(){
	if (confirm("Se você limpar os campos perderá tudo o que editou até agora, deseja continuar?")) {
		document.getElementById("nome").value = "";
		document.getElementById("sobrenome").value = "";
		document.getElementById("login").value = "";
		document.getElementById("email").value = "";
		document.getElementById("telefone").value = "";
		document.getElementById("cargo").value = "";
		document.getElementById("setor").value = "";
		document.getElementById("senha").value = "";
	}
}
function doc(x){return document.getElementById(x);} 
function curtir(id) {
var div = doc(id);
$.post("curtir.jsp", {idPost :id, idUser :<%=user.getIdusuario()%>}, function(data, status){});
if (div.getAttribute("name") == "like") {
	div.innerHTML = "";
	var newBotao = document.createElement("button");
	var t = document.createTextNode("Descurtir");
	newBotao.setAttribute("class", "liked-button");
	newBotao.setAttribute("onclick", "curtir(" + id + ")");
	newBotao.appendChild(t);
	div.appendChild(newBotao);
	div.setAttribute("name", "liked");
} else {
	div.innerHTML = "";
	var newBotao = document.createElement("button");
	var t = document.createTextNode("Curtir");
	newBotao.setAttribute("class", "like-button");
	newBotao.setAttribute("onclick", "curtir(" + id + ")");
	newBotao.appendChild(t);
	div.appendChild(newBotao);
	div.setAttribute("name", "like");
}

}
function publicar(idCampo){
var pub = doc(idCampo).value;
if (pub == "") {
	Materialize.toast('Você deve digitar algo!', 3000)
	return;
}else {
	if (idCampo == "postUsuario") {
		$.post("publicar.jsp", {idUsuario :<%=user.getIdusuario()%>, post : pub}, function(data, status){Materialize.toast('Publicado!', 3000)});
	} else {
		var list = idCampo.split("-");
		$.post("publicar.jsp", {idComentario: list[1],idUsuario :<%=user.getIdusuario()%>, post : pub}, function(data, status){});
		Materialize.toast('Publicado!', 3000)
		setTimeout(
				function atualizacao(){
					$.post("atPost.jsp", {id : list[1], idUser: <%=user.getIdusuario()%>}, function(data, status){doc("divPost-"+list[1]).innerHTML = data;});
				}, 500);
	}
}
doc(idCampo).value = "";
}
function enviarMsg(){
	var mensagem = doc("campoMsg").value;
	$.post("SendMsg.jsp", {
		idUser :<%=user.getIdusuario()%>,
		idAmigo : <%=iduser%>,
		msg : mensagem
	}, function(data,status) {
		
		$.post("StartChat.jsp", {
			idUser :<%=user.getIdusuario()%>,
			idAmigo : <%=iduser%>
		}, function(data,status) {
			doc("chat").innerHTML = data;
			doc("campoMsg").value = "";
			var divChat = doc("chat");
			divChat.scrollTop = divChat.scrollHeight;
		});
	});
}
function novosPosts(){
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
	<script type="text/javascript">novosPosts()</script>
	<div class="navbar-fixed" id="profile">
		<nav>
		<div class="nav-wrapper blue" style="cursor: pointer">
			<a href="#!" class="brand-logo center">MyWork</a>
			<ul class="right hide-on-med-and-down">
				<li><a href="index.jsp">Início<span class="badge white-text" id="novosPost"></span></a></li>
				<li><a onclick="location.reload()">Perfil</a></li>
				<li><a href="login.jsp?logoff=true">Logoff</a></li>
			</ul>
		</div>
		</nav>
	</div>
		<div class="container">
		<div class="col l12 s12" id="divPerfil">
			<div class='collection borda white'>
			<script type="text/javascript">
				$(document).ready(function(){
			    	// the "href" attribute of .modal-trigger must specify the modal ID that wants to be triggered
			   	 	$('.modal-trigger').leanModal();
			  	});
			</script>
			<%
				if(iduserlogado == null){
					out.println("<img src='"+userInfo.getFoto()+"' alt='' class='circle left col l4 s12' style='height: 200px; width: 200px; margin-left: 5px;margin-top: 5px;'>");
					out.println("<p class='col l8 s12 titulo left'>"+userInfo.getFrase()+"</p>");
					out.println("<div class='col l12 s12'>");
						out.println("<collection class='borda col l6 s12'>");
						out.println("<p class='label-newAcc col l6 s12'>Nome:</p>");
						out.println("<span class='col s12 l6 perfil-dados'>"+userInfo.getNome()+"</span>");
						out.println("</collection>");
						out.println("<collection class='borda col l6 s12'>");
						out.println("<p class='label-newAcc col l6 s12'>Sobrenome:</p>");
						out.println("<span class='col s12 l6 perfil-dados'>"+userInfo.getSobrenome()+"</span>");
						out.println("</collection>");
						out.println("<collection class='borda col l6 s12'>");
						out.println("<p class='label-newAcc col l6 s12'>Login:</p>");
						out.println("<span class='col s12 l6 perfil-dados'>"+userInfo.getLogin()+"</span>");
						out.println("</collection>");
						out.println("<collection class='borda col l6 s12'>");
						out.println("<p class='label-newAcc col l6 s12'>Email:</p>");
						out.println("<span class='col s12 l6 perfil-dados'>"+userInfo.getEmail()+"</span>");
						out.println("</collection>");
						out.println("<collection class='borda col l6 s12'>");
						out.println("<p class='label-newAcc col l6 s12'>Telefone:</p>");
						out.println("<span class='col s12 l6 perfil-dados'>"+userInfo.getTelefone()+"</span>");
						out.println("</collection>");
						out.println("<collection class='borda col l6 s12'>");
						out.println("<p class='label-newAcc col l6 s12'>Cargo:</p>");
						out.println("<span class='col s12 l6 perfil-dados'>"+userInfo.getCargo()+"</span>");
						out.println("</collection>");
						out.println("<collection class='borda col l6 s12'>");
						out.println("<p class='label-newAcc col l6 s12'>Setor:</p>");
						out.println("<span class='col s12 l6 perfil-dados'>"+userInfo.getSetor()+"</span>");
						out.println("</collection>");
						out.println("<collection class='borda col l6 s12'>");
						out.println("<p class='label-newAcc col l6 s12'>Gênero:</p>");
						if(userInfo.getGenero() == 0){
							out.println("<span class='col s12 l6 perfil-dados'>Masculino</span>");
						}else out.println("<span class='col s12 l6 perfil-dados'>Feminino</span>");
						out.println("</collection>");
					%>
						<a class='modal-trigger waves-effect waves-light btn col s12 l6 blue margin-botao' href='#chatModal'>Enviar uma Mensagem</a>
						<div id='chatModal' class='modal'><div class='modal-content'><h4>Chat com <%=userInfo.getNome()%></h4>
						<div class='container-msg col l12 s12' id='chat'>
						</div>
						<script>
							$.post("StartChat.jsp", {
								idUser :<%=user.getIdusuario()%>,
								idAmigo : <%=iduser%>
							}, function(data,status) {
								doc("chat").innerHTML = data;
								doc("campoMsg").value = "";
								var divChat = doc("chat");
								divChat.scrollTop = divChat.scrollHeight;
							});
							</script>
						<input onKeyDown='if(event.keyCode==13) enviarMsg()' placeholder='Mensagem ...' type='text' class='validate col l12 s12 white' id='campoMsg'>
						</div>
						<div class='modal-footer'><a href='#!' class='modal-action modal-close waves-effect waves-light btn-flat'>Fechar</a></div></div>
					<%
					out.println("<button class='btn col s12 l6 waves-effect waves-light blue margin-botao right' onclick='fecharAba()'>Cancelar</button>");
					out.println("</div>");
					out.println("<br>");
					out.println("<div class='col l12 s12'>");
					out.println("<p class='titulo'>Posts do Usuário:</p>");
					out.println("<br>");
					out.println("<div class='collection borda-posts col l12 s12' id='publicacoesAmigo'>");
					out.println("<script type='text/javascript'>");
						out.println("$.post('ActionPosts.jsp', {idAmigo : "+userInfo.getIdusuario()+", id: "+user.getIdusuario()+"}, function(data, status) {doc('publicacoesAmigo').innerHTML = data;});");
					out.println("</script>");
					out.println("</div>");
				}else{
					out.println("<img src='"+userInfo.getFoto()+"' alt='' class='circle left col l4 s12' style='height: 200px; width: 200px; margin-left: 5px;margin-top: 5px;'>");
					out.println("<p class='col l8 s12 titulo left'>"+user.getFrase()+"</p>");
					out.println("<form class='col l12 s12' method='post' action='EditAcc.jsp'>");
						out.println("<p class='label-newAcc col l2 s12'>Nome:</p>");
						out.println("<input placeholder='Ex:João' name='nome' id='nome' type='text'class='validate col s12 l4' value='"+userInfo.getNome()+"'>");
						out.println("<p class='label-newAcc col l2 s12'>Sobrenome:</p>");
						out.println("<input placeholder='Ex:Silva' name='sobrenome' id='sobrenome' type='text'class='validate col s12 l4' value='"+userInfo.getSobrenome()+"'>");
						out.println("<p style='color: red' class='col l12 s12'>*Apenas preencha o campo da senha se você deseja alterar sua senha!</p>");
						out.println("<p class='label-newAcc col l2 s12'>Senha:</p>");
						out.println("<input placeholder='Ex:12345' name='senha' id='senha' type='password'class='validate col s12 l4'>");
						out.println("<p class='label-newAcc col l2 s12'>Login:</p>");
						out.println("<input placeholder='Ex:JoãoSilva' name='login' id='login' type='text'class='validate col s12 l4' value='"+userInfo.getLogin()+"'>");
						out.println("<p class='label-newAcc col l2 s12'>Email:</p>");
						out.println("<input placeholder='Ex:joaosilva@gmail.com' name='email' id='email' type='text'class='validate col s12 l10' value='"+userInfo.getEmail()+"'>");
						out.println("<p class='label-newAcc col l2 s12'>Telefone:</p>");
						out.println("<input placeholder='Ex:(51) 0000-0000' name='telefone' id='telefone' type='text'class='validate col s12 l4' value='"+userInfo.getTelefone()+"'>");
						out.println("<p class='label-newAcc col l2 s12'>Cargo:</p>");
						out.println("<input placeholder='Ex:Gerente' name='cargo' id='cargo' type='text'class='validate col s12 l4' value='"+userInfo.getCargo()+"'>");
						out.println("<p class='label-newAcc col l2 s12'>Setor:</p>");
						out.println("<input placeholder='Ex:Setor 1' name='setor' id='setor' type='text'class='validate col s12 l4' value='"+userInfo.getSetor()+"'>");
						out.println("<p class='label-newAcc col l2 s12'>Gênero:</p>");
						out.println("<div class='col s12 l4'>");
						if(userInfo.getGenero() == 0){
							out.println("<p><input name='genero' checked type='radio' id='masc' value='0'/><label for='masc'>Masculino</label></p>");
							out.println("<p><input name='genero' type='radio' id='femn' value='1'/><label for='femn'>Feminino</label></p>");
						}else {
							out.println("<p><input name='genero' type='radio' id='masc' value='0'/><label for='masc'>Masculino</label></p>");
							out.println("<p><input name='genero' checked type='radio' id='femn' value='1'/><label for='femn'>Feminino</label></p>");
						}
						out.println("</div>");
						//out.println("<input placeholder='Ex:Maculino, Feminino' name='genero' type='text'class='validate col s12 l4'>");
						out.println("<p class='label-newAcc col l12 s12'>Foto (URL):</p>");
						out.println("<input placeholder='URL' name='foto' type='text'class='validate col s12 l12' value='"+userInfo.getFoto()+"'>");
						out.println("<button class='btn col s12 l12 waves-effect waves-light blue margin-botao' type='submit' name='action'>Salvar</button>");
					out.println("</form>");
					out.println("<div class='col l12 s12'>");
						out.println("<button class='btn col s12 l6 waves-effect waves-light blue margin-botao' onclick='voltar()'>Cancelar</button>");
						out.println("<button class='btn col s12 l6 waves-effect waves-light blue margin-botao' onclick='limparCampos()'>Limpar Campos</button>");
					out.println("</div>");
					out.println("<br>");
					out.println("<div class='col l12 s12'>");
					out.println("<p class='titulo'>Posts do Usuário:</p>");
					out.println("<br>");
					out.println("<div class='collection borda-posts col l12 s12' id='publicacoesAmigo'>");
					out.println("<script type='text/javascript'>");
						out.println("$.post('ActionPosts.jsp', {idAmigo : "+userInfo.getIdusuario()+", id: "+iduserlogado+"}, function(data, status) {doc('publicacoesAmigo').innerHTML = data;});");
					out.println("</script>");
					out.println("</div>");
				}
			%>
			</div>
		</div>
	</div>
</body>
</html>