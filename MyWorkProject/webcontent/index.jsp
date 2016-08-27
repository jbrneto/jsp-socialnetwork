<%@page import="java.util.ArrayList"%>
<%@page import="utils.UserUtils"%>
<%@page import="utils.AmigosUtils"%>
<%@ page language="java" contentType="text/html;charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	UserUtils user = (UserUtils) session.getAttribute("user");
	if (user == null) {
		response.sendRedirect("login.jsp?erro=loginError");
		return;
	}
	int idUser = user.getIdusuario();
	String nomeUser = user.getNome();
	String sobrenomeUser = user.getSobrenome();
	String loginUser = user.getLogin();
	String emailUser = user.getEmail();
	String fotoUser = user.getFoto();
	String telefoneUser = user.getTelefone();
	String cargoUser = user.getCargo();
	String setorUser = user.getSetor();
	String fraseUser = user.getFrase();
	String generoUser;
	if(fraseUser == null){
		fraseUser = "";
	}
	if (user.getGenero() == 0) {
		generoUser = "Masculino";
	} else {
		generoUser = "Feminino";
	}
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script src="js/jquery-2.2.0.min.js"></script>
<script src="js/materialize.min.js"></script>
<link href="css/materialize.min.css" rel="stylesheet"></link>
<link href="css/MW.css" rel="stylesheet"></link>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<title>MyWork-Home</title>
<script type="text/javascript">
	function doc(x){return document.getElementById(x);}
	function curtir(id) {
		var div = doc(id);
		$.post("curtir.jsp", {idPost :id, idUser :<%=idUser%>}, function(data, status){
			document.getElementById("io"+id).innerHTML = data;
		});
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
			Materialize.toast('Você deve digitar algo!', 3000);
			return;
		}else {
			if (idCampo == "postUsuario") {
				$.post("publicar.jsp", {idUsuario :<%=idUser%>, post : pub}, function(data, status){Materialize.toast('Publicado!', 3000)});
			} else {
				var list = idCampo.split("-");
				$.post("publicar.jsp", {idComentario: list[1],idUsuario :<%=idUser%>, post : pub}, function(data, status){});
				Materialize.toast('Publicado!', 2000);
				setTimeout(
						function atualizacao(){
							$.post("atPost.jsp", {id : list[1], idUser: <%=idUser%>}, function(data, status){doc("divPost-"+list[1]).innerHTML = data;});
						}, 500);
			}
		}
		doc(idCampo).value = "";
	}
	function fraseChange(){
		var campo = doc("text-frase").value;
		if(campo == ""){
			Materialize.toast('Você deve digitar algo!', 3000);
			return;
		}
		$.post("FraseChange.jsp", {
			idUser :<%=idUser%>,
			frase : campo
		}, function(data, status) {
			Materialize.toast('Salvo!', 3000);
		});
	}
	function showChat(idChat){
		var div = doc(idChat);
		if(div.status == "0"){
			div.style.display = "block";
			div.status = "1";
			
			/* var amigoId = idChat.split("-")
			var divChat = doc("chat-"+amigoId[1]);
			divChat.scrollTop = divChat.scrollHeight; */
			var amigoId = idChat.split("-");
			
			doc("novaMsg-"+amigoId[1]).innerHTML = "";
			
			setInterval(function chat(){
				if(div.status == "1"){
					$.post("StartChat.jsp", {
						idUser :<%=idUser%>,
						idAmigo : amigoId[1]
					}, function(data,status) {
						doc("chat-"+amigoId[1]).innerHTML = data;
						var divChat = doc("chat-"+amigoId[1]);
						divChat.scrollTop = divChat.scrollHeight;
					});
				}else return;
			}, 1500);
		}else{
			div.style.display = "none";
			div.status = "0";
		}
	}
	function sendMsg(id){
		var mensagem = doc("campoMsg-"+id).value;
		$.post("SendMsg.jsp", {
			idUser :<%=idUser%>,
			idAmigo : id,
			msg : mensagem
		}, function(data,status) {
			var divChat = doc("chat-"+id);
			divChat.scrollTop = divChat.scrollHeight;
			
			<%-- $.post("StartChat.jsp", {
				idUser :<%=idUser%>,
				idAmigo : id
			}, function(data,status) {
				doc("chat-"+id).innerHTML = data;
				doc("campoMsg-"+id).value = "";
				var divChat = doc("chat-"+amigoId[1]);
				divChat.scrollTop = divChat.scrollHeight;
			}); --%>
		});
	}
	function pesquisaAmg(){
		window.open("Pesquisa.jsp?idUser="+<%=idUser%>+"&&pesq="+doc("pesquisa").value,"_blank");
	}
	function novosPost(){
		setInterval(function novos(){
			$.post("newPosts.jsp", {
				idUser :<%=idUser%>,
				nPost : "true"
			}, function(data,status) {
				if(data > 0){
					doc("novosPost").innerHTML = "";
				}
			});
		}, 10000);
	}
	function maisPosts(){
		$(".morePubs").remove();
		$.post("newPosts.jsp", {
			idUser :<%=idUser%>,
		}, function(data,status) {
			doc("publicacoes").innerHTML += data;
		});
	}
	function novasMsg(){
		setInterval(function newMsg(){
			$.post("novasMsg.jsp", {
				idUser :<%=idUser%>,
			}, function(data,status) {
				var novas = data.split("-");
				for(var i=0; i< novas.length; i++){
					var id = novas[i].trim();
					if(id != null && id != "" && id.length != 0){
						doc("novaMsg-"+id).innerHTML = " NOVA";
					}
				}
			});
		}, 5000);
	}
</script>
</head>
<body class="fundo">

	<script type="text/javascript">
		$.post("ActionPosts.jsp", {
			id :<%=idUser%>
		}, function(data, status) {
			doc("publicacoes").innerHTML = data;
		});
		//CASO O USUÁRIO VOLTE DE OUTRA JANELA, ELE RECRIA A LISTA
		<%session.removeAttribute("amigos");%>
		//GERA A LISTA PELA PRIMEIRA VEZ
		$.post("ActionMensagens.jsp", {
			idusuario:<%=idUser%>
		},function(data,status){
			if(data != null && data != "" && !(data.length == 0) && (data.indexOf("<") > -1)){
				var amigos = doc("mensagens").innerHTML;
				doc("mensagens").innerHTML = data + amigos;
				//CHAMA O METODO NOVAMENTE PARA REPETIR A CADA 10 SEG
				setInterval(function mensagens(){
					$.post("ActionMensagens.jsp", {
						idusuario:<%=idUser%>
					},function(data,status){
						if(data != null && data != "" && !(data.length == 0) && (data.indexOf("<") > -1)){
							var amigos = doc("mensagens").innerHTML;
							doc("mensagens").innerHTML = data + amigos;
						}
					});
				}, 10000);
			}
		});
		novosPost();
		novasMsg();
	</script>

	<div class="navbar-fixed" id="profile">
		<nav>
			<div class="nav-wrapper blue" style="cursor: pointer">
				<a href="#!" class="brand-logo center">MyWork</a>
				<ul class="right hide-on-med-and-down">
					<li><a onclick="location.reload()">Início<span class="badge white-text" id="novosPost"></span></a></li>
					<li><a href="Perfil.jsp?idUserLogado=<%=idUser%>">Perfil</a></li>
					<li><a href="login.jsp?logoff=true">Logoff</a></li>
				</ul>
			</div>
		</nav>
	</div>
<div class="row">

	<div class="col s12 l2" name="esquerdo">
		<div class="collection borda white" id="perfil">
			<div class="col l12 s6 left">
			<h5 class="text-centralizar"><%=loginUser%></h5>
			<div>
				<img src="<%=fotoUser%>" alt="" class="circle image-centralizar" style="height: 100px; width: 100px;">
			</div>
			</div>
			<br>
			<hr class="hrMW">
			<div id="infoPerfil" class="container perfil-info col l12 s6">
				<p><%=nomeUser%> <%=sobrenomeUser%> / <%=generoUser%></p>
				<p><%=cargoUser%> / <%=setorUser%></p>
				<p><%=telefoneUser%></p> 
				<p><%=emailUser%></p>
			</div>
		</div>
		<div class="collection borda white col l12 s12" id="frase">
			<p class='label-newAcc col l12 s12 perfil-info'>Frase:</p>
			<textarea onKeyDown="if(event.keyCode==13) fraseChange()" placeholder='EX: Bom Dia! :D' class="frase-margin materialize-textarea" id="text-frase"><%=fraseUser%></textarea>
			<!-- <button class="frase-margin col s12 l12 btn waves-effect waves-light blue pub-button" onclick="fraseChange()">OK</button> -->
		</div>
	</div>

	<div class="col s12 l7 row-principal" name="meio" id="principal">
		<div class="input-field col s12 l12 white borda">
			<input placeholder='Pesquisar por...' type='text' class='validate' id="pesquisa" onKeyDown="if(event.keyCode==13) pesquisaAmg()">
		</div>
		<div id="publicacao" class="collection borda col l12 s12 white">
			<div class="col s10 l10">
				<!-- /*INPUT-COR-MW*/ PROCURAR NO CSS PARA MUDAR A COR DO TEXTAREA -->
				<textarea placeholder="Compartilhe algo aqui." id="postUsuario" type="text" class="materialize-textarea pub-input" maxlength="140"></textarea>
			</div>
			<button class="col s12 l2 btn waves-effect waves-light blue pub-button" onclick="publicar('postUsuario')">Publicar</button>
		</div>
		<div class="collection borda-posts col l12 s12" id="publicacoes"></div>
		
	</div>
	<div class="col s12 l3" name="direito">
		<div class="collection borda white">
			<h4 class="blue-text text-centralizar">Mensagens</h4>
			<div style="overflow: auto;">
			<div id="mensagens" class="collection" style="cursor: pointer;"></div>
					<!-- 
					<div class="collapsible-header"><i class="material-icons"></i>First</div>
      				<div class="collapsible-body"><p>Lorem ipsum dolor sit amet.</p></div>
					<a onclick="msg(12)" class="collection-item blue-text" id="12">Bruno</a>
					<a class="collection-item blue-text">Carlos<i class="tiny material-icons">textsms</i></a> 
					<a class="collection-item blue-text">João<i class="tiny material-icons">chat_bubble</i></a>
					<a class="collection-item blue-text">Rebeca</a> -->
			</div>
		</div>
	</div>
</div>
	<script type="text/javascript">
		$('.row-principal').css({
			height : $(window).innerHeight()-85
		});
		$(window).resize(function() {
			$('.row-principal').css({
				height : $(window).innerHeight()
			});
		});
	</script>
</body>
</html>