<HTML>
<HEAD>
<meta http-equiv=Content-Type content="text/html; 
 charset=UTF-8">
<TITLE>El Gran Tipo</TITLE>
<SCRIPT language="javascript">
	function ShowVideoInTv(NameFile, TMaxEjec, NameVar, ValVar) {
		//Crea el Objeto ActiveX para mostrarlo en la TV de la agencia
		NewInstanceCom = new ActiveXObject("colas.srvllamada");
		NewInstanceCom.u_ShowVideoInTv(NameFile, TMaxEjec, NameVar, ValVar);
		return true;
	}
	function checkDebug(){
		//Retorna true para mostrar los prints en el flash y false para ocultarlo
		return true;
	}
</SCRIPT>
</HEAD>
<BODY>
	<!-- bgcolor="#2C723F"---->
	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
		codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab"
		id="Game" width="800" height="600">
		<param name="movie" value="resources/main.swf" />
		<param name="quality" value="high" />
		<param name="bgcolor" value="#FFFFFF" />
		<param name="allowScriptAccess" value="sameDomain" />
		<!--[if !IE]> <-->
		<object data="resources/main.swf" width="800" height="600"
			type="application/x-shockwave-flash" align="middle">
			<param name="name" value="Bedrukt-web" />
			<param name="movie" value="resources/main.swf" />
			<param name="quality" value="high" />
			<param name="play" value="true" />
			<param name="loop" value="false" />
			<param name="bgcolor" value="#FFFFFF" />
			<param name="allowScriptAccess" value="sameDomain" />
			<param name="pluginurl"
				value="http://www.macromedia.com/go/getflashplayer" />
		</object>
	</object>
</BODY>
</HTML>