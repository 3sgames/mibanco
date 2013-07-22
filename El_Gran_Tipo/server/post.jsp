<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="javax.crypto.IllegalBlockSizeException"%>
<%@page import="javax.crypto.BadPaddingException"%>
<%@page import="javax.crypto.NoSuchPaddingException"%>
<%@page import="java.security.spec.InvalidKeySpecException"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page import="java.security.InvalidKeyException"%>
<%@page import="javax.crypto.SecretKey"%>
<%@page import="javax.crypto.SecretKeyFactory"%>
<%@page import="javax.crypto.spec.DESKeySpec"%>
<%@page import="javax.crypto.Cipher"%>
<%@page import="sun.misc.BASE64Decoder"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.DataInputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.rmi.RemoteException"%>
<%@page import="java.sql.SQLException"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.rmi.RemoteException"%>

<%@page import="org.tempuri.action.CAS218Execute"%>
<%@page import="org.tempuri.action.CAS218ExecuteResponse"%>
<%@page import="org.tempuri.action.CAS218SoapPortProxy"%>

<%@page language="java" contentType="text/html; charset=windows-31j"
    pageEncoding="windows-31j"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=windows-31j">
<title>El Gran Tipo - Server</title>
</head>
<body>

<%!
public String[] game = new String[4];
public void getGameLogin() throws IOException,FileNotFoundException{
      //System.out.println("Paso 1");
	FileInputStream fstream = new FileInputStream("C:/dataTipo");
	 //System.out.println("Paso 2");
	DataInputStream in = new DataInputStream(fstream);
	 //System.out.println("Paso 3");
	BufferedReader br = new BufferedReader(new InputStreamReader(in));
	String strLine;
	int i = 0;
	while ((strLine = br.readLine()) != null)   {
		game[i++] = strLine;
	}
	in.close();

	////------Decryption------/////
	try{
	DESKeySpec keySpec = new DESKeySpec(game[3].getBytes("UTF8")); 
	SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
	SecretKey key = keyFactory.generateSecret(keySpec);
	sun.misc.BASE64Decoder base64decoder = new BASE64Decoder();
	
	byte[] encryptedPwdBytes = base64decoder.decodeBuffer(game[2]);
	Cipher cipher;
	cipher = Cipher.getInstance("DES");
	cipher.init(Cipher.DECRYPT_MODE, key);
	byte[] password = (cipher.doFinal(encryptedPwdBytes));
	game[2] = new String(password);
	}catch(InvalidKeyException e){
		System.out.println(">"+e);
	}catch(InvalidKeySpecException e){
		System.out.println(">"+e);
	}catch(NoSuchAlgorithmException e){
		System.out.println(">"+e);
	}catch(NoSuchPaddingException e){
		System.out.println(">"+e);
	}catch(BadPaddingException e){
		System.out.println(">"+e);
	}catch(IllegalBlockSizeException e){
		System.out.println(">"+e);
	}
}
%>
<%!
private String formatCHAR(String input,int length){
	String zeros = "";
	for(int i = 0; i < (length - input.length());i++){
		zeros += "0";
	}
	return zeros + input;
}
%>
<%
try{
	getGameLogin();
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	
	Connection con = DriverManager.getConnection("jdbc:sqlserver://localhost:1433; databaseName="+game[0]+";user="+game[1]+";password="+game[2]+";");
	String method = request.getParameter("method");

	String query = "";
	PreparedStatement st;
	ResultSet rs;

	DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
	DateFormat hourFormat = new SimpleDateFormat("HH:mm:ss");
	Date date = new Date();

	//System.out.println(method);
	
	if(method.equals("check")){
		query = "exec dbo.spgt_consultar_periodo 'P01';";
		st = con.prepareStatement(query);
		rs = st.executeQuery();
		rs.next();
		String start = rs.getString(1);
		String end = rs.getString(2);
		rs.close();
		st.close();
		JSONArray jarr = new JSONArray();
		JSONObject jobj;
		jobj = new JSONObject();
		jobj.put("error", "OK");
		jobj.put("start", start);
		jobj.put("end", end);
		jarr.add(0,jobj);
		
		System.out.println("s:"+start+"\te:"+end);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(jarr.toJSONString());
	}
	else if(method.equals("readData")){
		String suc = formatCHAR(request.getParameter("suc"),3);
		String mod = formatCHAR(request.getParameter("mod"),3);
		String trans = formatCHAR(request.getParameter("trans"),3);
		String rel = formatCHAR(request.getParameter("rel"),4);
		double amo = Double.parseDouble(request.getParameter("amo"));
		String cat = request.getParameter("cat");
		int totDays = Integer.parseInt(request.getParameter("totDays"));
		
	System.out.println(
		"\nsuc: " + suc + 
		"\nmod: " + mod + 
		"\ntrans: " + trans + 
		"\nrel: " + rel + 
		"\namo: " + amo + 
		"\ncat " + cat + 
		"\ntotDays: " + totDays
	);
		
		int daysBefore = Integer.parseInt(request.getParameter("daysBefore"));
		
		System.out.println("dysBefore: " + daysBefore);
		
		query = "exec dbo.spgt_consulta_usuario '"+suc+"','"+mod+"','"+trans+"','"+rel+"','"+dateFormat.format(date)+"';";
		st = con.prepareStatement(query);
		rs = st.executeQuery();
		rs.next();
		int exist = rs.getInt(1);
		rs.close();
		st.close();
		
		JSONArray jarr = new JSONArray();
		JSONObject jobj;
		jobj = new JSONObject();
		//--
		CAS218ExecuteResponse res = null;
		try {
			CAS218SoapPortProxy proxy = new CAS218SoapPortProxy();
			CAS218Execute o = new CAS218Execute();
			o.setModo("VAL");
			o.setIsucursal(formatCHAR(suc,3));
			o.setImodulo(formatCHAR(mod,3));
			o.setItransaccion(formatCHAR(trans,3));
			o.setIrelacion(formatCHAR(rel,4));
			o.setImonto(amo);
			o.setIfecha(dateFormat.format(date));
			o.setIhora(hourFormat.format(date));
			o.setTdocumento("");
			o.setNdocumento("");
			o.setNcliente("");
			o.setNombreagencia("");
			o.setGanador("");
			o.setIpremio("");
			o.setCumplerequisitos("");
			o.setCodret("");
			o.setMsgerr("");
			res = proxy.execute(o);
		} catch (Exception e) {
			System.out.println("Error on WSDL");
		}
		//--
		System.out.println("exist: " + exist);
		System.out.println("amo: " + amo);
		System.out.println("res.getImonto: " + res.getImonto());
		System.out.println("res.getCodret: " + res.getCodret());
		
		if(exist == 0 && amo == res.getImonto() && res.getCodret().equals("OK")){
			query = "exec dbo.spgt_insertar_usuario '"+suc+"','"+mod+"','"+trans+"','"+rel+"','"+amo+"';";
			st = con.prepareStatement(query);
			st.execute();
			jobj.put("error", res.getCodret());
			jarr.add(0, jobj);
			jobj = new JSONObject();
			jobj.put("tipoDoc", res.getTdocumento());
			jobj.put("numDoc", res.getNdocumento());
			jobj.put("nomCli", res.getNcliente());
			jobj.put("nomAge", res.getNombreagencia());

			jobj.put("req", res.getCumplerequisitos());
			jobj.put("codRet", res.getCodret());
			jobj.put("msgErr", res.getMsgerr());
			jarr.add(1, jobj);
			query = "exec dbo.spgt_stock '"+cat+"';";
			st = con.prepareStatement(query);
			rs = st.executeQuery();
			rs.next();
			//int stock  = rs.getInt(1);
			Integer stock = Integer.valueOf(rs.getInt(1));
			System.out.println("stock "+stock);
			rs.close();
			st.close();
			jobj = new JSONObject();
			jobj.put("stock",stock);
			query = "exec dbo.spgt_consultar_ganador "+daysBefore+",'"+cat+"';";
			st = con.prepareStatement(query);
			rs = st.executeQuery();
			rs.next();
			//int totWinners = rs.getInt(1);
			Integer totWinners = Integer.valueOf(rs.getInt(1));
			rs.close();
			st.close();
			jobj.put("totWinners",totWinners);
			jarr.add(2,jobj);
		}
		else{
			jobj.put("error","INVALID");
			jarr.add(0,jobj);
		}
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(jarr.toJSONString());
	}
	else if(method.equals("checkTime")){
		JSONArray jarr = new JSONArray();
		JSONObject jobj;
		jobj = new JSONObject();
		int hours = Integer.parseInt(request.getParameter("hours"));
		int mins = Integer.parseInt(request.getParameter("mins"));
		int daysBefore = Integer.parseInt(request.getParameter("daysBefore"));
		String cat = request.getParameter("cat");
		if(hours > date.getHours()){
			jobj.put("happyHour","true");
		}
		else if(hours == date.getHours() && mins >= date.getMinutes()){
			jobj.put("happyHour","true");
		}
		else{
			jobj.put("happyHour","false");
		}
		query = "exec dbo.spgt_consultar_ganador "+daysBefore+",'"+cat+"';";
		st = con.prepareStatement(query);
		rs = st.executeQuery();
		rs.next();
		//int exist = rs.getInt(1);
		Integer exist = Integer.valueOf(rs.getInt(1));
		rs.close();
		st.close();
		jobj.put("existWinner",exist);
		jarr.add(0,jobj);
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(jarr.toJSONString());
	}
	else if(method.equals("saveData")){
		String suc = formatCHAR(request.getParameter("suc"),3);
		String mod = formatCHAR(request.getParameter("mod"),3);
		String trans = formatCHAR(request.getParameter("trans"),3);
		String rel = formatCHAR(request.getParameter("rel"),4);
		double amo = Double.parseDouble(request.getParameter("amo"));

		String tipoDoc = request.getParameter("tipoDoc");
		String numDoc = request.getParameter("numDoc");
		String nomCli = request.getParameter("nomCli");
		String nomAge = request.getParameter("nomAge");

		String win = request.getParameter("winner");
		String pz = request.getParameter("prize");
		String cat = request.getParameter("cat");

		String req = request.getParameter("req");
		String codRet = request.getParameter("codRet");
		String msgErr = request.getParameter("msgErr");

		JSONArray jarr = new JSONArray();
		JSONObject jobj;
		//--
		CAS218ExecuteResponse res = null;
		try {
			CAS218SoapPortProxy proxy = new CAS218SoapPortProxy();
			CAS218Execute o = new CAS218Execute();
			o.setModo("GRA");
			o.setIsucursal(formatCHAR(suc,3));
			o.setImodulo(formatCHAR(mod,3));
			o.setItransaccion(formatCHAR(trans,3));
			o.setIrelacion(formatCHAR(rel,4));
			o.setImonto(amo);
			o.setIfecha(dateFormat.format(date));
			o.setIhora(hourFormat.format(date));
			o.setTdocumento(tipoDoc);
			o.setNdocumento(numDoc);
			o.setNcliente(nomCli);
			o.setNombreagencia(nomAge);
			if(win.equals("true")){
				o.setGanador("S");
				o.setIpremio(pz);
			}else{
				o.setGanador("N");
				o.setIpremio("");
			}
			o.setCumplerequisitos(req);
			o.setCodret(codRet);
			o.setMsgerr(msgErr);
			res = proxy.execute(o);
		} catch (RemoteException e) {
			System.out.println("Error on WSDL");
			jobj = new JSONObject();
			jobj.put("error","Error on WSDL");
			jarr.add(0,jobj);
		}
		//--
		jobj = new JSONObject();
		jobj.put("error","OK");
		jarr.add(0,jobj);
		
		if(win.equals("true")){
			query = "exec dbo.spgt_insertar_ganador '"+suc+"','"+mod+"','"+trans+"','"+rel+"','"+cat+"';";
			st = con.prepareStatement(query);
			int rows = st.executeUpdate();
			//System.out.println("r:"+rows);
			st.close();
			if(rows == 0){
				jobj = new JSONObject();
				jobj.put("error","INVALID");
				jarr.add(0,jobj);
			}
		}
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(jarr.toJSONString());
	}
	con.close();
}
catch ( SQLException excepcionSql){
	System.out.println("Database Error - "+excepcionSql);
}
catch (ClassNotFoundException claseNoEncontrada ){
	System.out.println("Driver class not found");
}
catch(IOException e){
	System.out.println("Cannot read config file");
}
%>
</body>
</html>