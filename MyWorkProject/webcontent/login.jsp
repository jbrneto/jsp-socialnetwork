<%@page import="utils.UserUtils"%>
<%@page import="utils.MD5Utils"%>
<%@page import="utils.DataBaseUtils"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String l = request.getParameter("login");
	String s = request.getParameter("senha");
	String erro = request.getParameter("erro");
	String sucess = request.getParameter("sucess");
	String logoff = request.getParameter("logoff");
	
	
	if (logoff != null) {
		session.invalidate();
	}
	if (sucess != null) {
		if(sucess.equals("trueE")){
			out.println("<script>alert('Conta alterada com Sucesso! faça Login!')</script>");
			response.sendRedirect("login.jsp");
		}else{
			out.println("<script>alert('Conta criada com Sucesso! faça Login!')</script>");
			response.sendRedirect("login.jsp");
		}
	}
	if (erro != null) {
		if (erro.equals("loginError")) {
			out.println("<script>alert('Você deve fazer Login antes!')</script>");
		} else if (erro.equals("invalidPass")) {
			out.println("<script>alert('Senha inválida!')</script>");
		} else if (erro.equals("invalidLogin")) {
			out.println("<script>alert('Login inválido!')</script>");
		} else if (erro.equals("emptyField")) {
			out.println("<script>alert('Você deve preencher todos os campos!')</script>");
		} else if (erro.equals("connection")) {
			out.println("<script>alert('Erro de conexão!')</script>");
		}else if (erro.equals("doubleLogin")) {
			out.println("<script>alert('Ja existe um usuário com este Login!')</script>");
		}else if(erro.equals("expireSession")){
			out.println("<script>alert('A sessão expirou, faça Login novamente!')</script>");
		}
	}
	if (l != null && s != null) {
		ResultSet rs = DataBaseUtils.executeQuery("SELECT * FROM usuario WHERE login = '"+ l + "';");
		if (rs.next()) {
			s = MD5Utils.getMD5(s);
			if (s.equals(rs.getString("senha"))) {
				UserUtils user = new UserUtils();
				user.setIdusuario(rs.getInt("idusuario"));
				user.setNome(rs.getString("nome"));
				user.setSobrenome(rs.getString("sobrenome"));
				user.setSenha(rs.getString("senha"));
				user.setLogin(rs.getString("login"));
				user.setEmail(rs.getString("email"));
				user.setFoto(rs.getString("foto"));
				user.setTelefone(rs.getString("telefone"));
				user.setCargo(rs.getString("cargo"));
				user.setSetor(rs.getString("setor"));
				user.setGenero(rs.getInt("genero"));
				user.setFrase(rs.getString("frase"));

				session.setAttribute("user", user);
				response.sendRedirect("index.jsp");
			} else {
				response.sendRedirect("login.jsp?erro=invalidPass");
				return;
			}
		} else {
			response.sendRedirect("login.jsp?erro=invalidLogin");
			return;
		}
	}
%>
<html>
<head>
<link href="css/materialize.min.css" rel="stylesheet"></link>
<link href="css/MW.css" rel="stylesheet"></link>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
<script src="js/jquery-2.2.0.min.js"></script>
<script src="js/materialize.min.js"></script>
<title>MyWork-Login</title>
<script type="text/javascript">
	function mostrar(){
		document.getElementById("divCreateConta").style.display = "block";
	}
</script>
</head>
<body class="row fundo">
<script type="text/javascript">
	$(document).ready(function() {
    	$('select').material_select();
  	});
  	$(document).ready(function(){
	    $('.tooltipped').tooltip({delay: 50});
	});
</script>
	<div class="col l4 s12 right collection borda white">
		<p class="titulo">MyWork</p>
		<br> <br>
		<form action="login.jsp" class="col l12 s12">
			<p class="text-login col l2 s12">Login:</p>
			<input placeholder="Ex:JoãoSilva" name="login" type="text" class="validate col s12 l10">
			<p class="text-login col l2 s12">Senha:</p>
			<input placeholder="Ex:12345" name="senha" type="password" class="validate col s12 l10">
			<button class="col s12 l2 btn waves-effect waves-light blue right margin-botao" type="submit" name="action">Login</button>
		</form>
		<button class="col s12 l4 btn waves-effect waves-light blue right margin-botao" onclick="mostrar()">Criar Conta</button>
	</div>
	<div class="container">
		<div class="col l8 s12" id="divCreateConta" style="display: none;">
			<div class='collection borda white'>
				<form class='col l12 s12' method="post" action="CreateAcc.jsp">
					<p class='titulo'>Criar Conta</p>
					<p class='label-newAcc col l2 s12'>Nome:</p>
					<input placeholder='Ex:João' name='nomeC' type='text'class='validate col s12 l4'>
					<p class='label-newAcc col l2 s12'>Sobrenome:</p>
					<input placeholder='Ex:Silva' name='sobrenomeC' type='text'class='validate col s12 l4'>
					<p class='label-newAcc col l2 s12'>Senha:</p>
					<input placeholder='Ex:12345' name='senhaC' type='password'class='validate col s12 l4'>
					<p class='label-newAcc col l2 s12'>Login:</p>
					<input placeholder='Ex:JoãoSilva' name='loginC' type='text'class='validate col s12 l4'>
					<p class='label-newAcc col l2 s12'>Email:</p>
					<input placeholder='Ex:joaosilva@gmail.com' name='emailC' type='text'class='validate col s12 l10'>
					<p class='label-newAcc col l2 s12'>Telefone:</p>
					<input placeholder='Ex:(51) 0000-0000' name='telefoneC' type='text'class='validate col s12 l4'>
					<p class='label-newAcc col l2 s12'>Cargo:</p>
					<input placeholder='Ex:Gerente' name='cargoC' type='text'class='validate col s12 l4'>
					<p class='label-newAcc col l2 s12'>Setor:</p>
					<input placeholder='Ex:Setor 1' name='setorC' type='text'class='validate col s12 l4'>
					<p class='label-newAcc col l2 s12'>Gênero:</p>
					<div class="col l4 s12">
						 <p><input name="genero" checked type="radio" id="masc" value="0"/><label for="masc">Masculino</label></p>
						 <p><input name="genero" type="radio" id="femn" value="1"/><label for="femn">Feminino</label></p>
					</div>
					<!-- <input placeholder='Ex:Maculino, Feminino' name='generoC' type='text'class='validate col s12 l4'> -->
					<p class='label-newAcc col l12 s12'>Foto (URL):</p>
					<input placeholder='URL' name='fotoC' type='text'class='validate col s12 l12'>
					<button class='btn col s12 l4 waves-effect waves-light blue margin-botao right'type="submit" name='action'>Criar</button>
				</form>
			</div>
		</div>
	</div>
</body>
</html>