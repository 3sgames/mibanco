package com.tsg.slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import com.gloop.ui.ScreenManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.tsg.slotmachine.Global;
	import com.greensock.TweenLite;
	//-------
	import com.adobe.serialization.json.JSON;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import com.tsg.slotmachine.WinValidator;

	public class WaitScreen extends Screen 
	{
		private var loader:URLLoader = new URLLoader();
		private var winLoader:URLLoader = new URLLoader();
		private var checkLoader:URLLoader = new URLLoader();
		
		private var ran:Number = -1;
		
		public function WaitScreen(canvas:MovieClip) 
		{
			super(canvas);
			var content:MovieClip = new mcWaitScreen();
			canvas.addChild(content);
			
			var amo:Number = parseFloat(Global.amountInput);
			
			if(amo <= 500){
				Global.prize = "S/. 50";
				Global.category = "PZ01";
			}
			else if(amo <= 2000){
				Global.prize = "S/. 100";
				Global.category = "PZ02";
			}
			else if(amo <= 5000){
				Global.prize = "S/. 150";
				Global.category = "PZ03";
			}
			else if(amo > 5000){
				Global.prize = "S/. 300";
				Global.category = "PZ04";
			}
			
			readData();
		}
		
		private function readData()
		{
			Main.debugger.setText("Sending data to server.(Check User)");
			var _variables:URLVariables = new URLVariables();
			_variables.method = "readData";
			_variables.suc = Global.codSuc;
			_variables.mod = Global.codMod;
			_variables.trans = Global.codTrans;
			_variables.rel = Global.codRel;
			_variables.amo = Global.amountInput;
			_variables.cat = Global.category;
			_variables.totDays = Global.totDays;
			var _request:URLRequest = new URLRequest(Global.URLfile);
			_request.method = URLRequestMethod.POST;
			_request.data = _variables;
			loader.addEventListener(Event.COMPLETE, loadingdata);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			loader.load(_request);
		}
		private function handleIOError(evt:Event)
		{
			Main.debugger.println("Failed to send");
		}
		
		private function loadingdata(evt:Event)
		{
			loader.removeEventListener(Event.COMPLETE, loadingdata);
			Main.debugger.println("Successfully sent");
			Main.debugger.println("Reading retrieved values");
			var resp:String= evt.currentTarget.data as String;
			resp = resp.substring(0,resp.indexOf("\n"));
			var jarr:Array = JSON.decode(resp) as Array;
			
			if (jarr[0].error != "OK")
			{
				TweenLite.delayedCall(3, function():void
				{
					ScreenManager.instance.gotoScreen(ErrorScreen);
				});
			}
			else
			{
				Global.tipoDoc = jarr[1].tipoDoc;
				Global.numDoc = jarr[1].numDoc;
				Global.nomCli = jarr[1].nomCli;
				Global.nomAge = jarr[1].nomAge;
				Global.req = jarr[1].req;
				Global.codRet = jarr[1].codRet;
				Global.msgErr = jarr[1].msgErr;
				
				if (WinValidator.isTimeToWin())
				{
					trace("gano");
				}
				
				//var amo:Number = parseFloat(Global.amountInput);
				//
				//ran = Math.floor(Math.random() * 10);
				//
				//if(amo < 50){
					//ran = 10;
				//}
				//if(parseInt(jarr[2].stock) == 0)
					//ran = 11;
				//
				//Global.ratio = Math.ceil(Global.totDays / (parseInt(jarr[2].totWinners) + parseInt(jarr[2].stock)));
				//var tmp = Math.floor(Global.remainingDays / parseInt(jarr[2].stock));
				//Main.debugger.println("ratio : "+Global.ratio + "|| tmp : "+tmp);
				//if(Global.ratio != tmp && Global.remainingDays <= parseInt(jarr[2].stock))
					//Global.ratio = 1;
				//55
				//30|20|10|5
				//2
				//Main.debugger.println("Participa por:"+Global.prize);
				//Main.debugger.println("Ganadores hasta la fecha:"+jarr[2].totWinners);
				//Main.debugger.println("Razon de entrega: 1 premio cada "+Global.ratio+" dia(s)");
				//Main.debugger.println("Stock restante:"+jarr[2].stock);
				//Main.debugger.println("Probabilidad:"+ran);
				//Main.debugger.println("Días transcurridos de período:"+(Global.elapsedDays % Global.ratio));
				//Main.debugger.println("Días de campaña transcurridos: "+Global.elapsedDays);
				//Main.debugger.println("Días de campaña restantes: "+ Global.remainingDays);
				//
				//checkPeriod();
			}
		}
		//private function checkPeriod(){
			//Main.debugger.println("Sending data to verify if can win");
			//var _variables:URLVariables = new URLVariables();
			//_variables.method = "checkTime";
			//_variables.time = WinValidator.getTimeMillis();
			//_variables.daysBefore = (Global.elapsedDays % Global.ratio)+1;
			//_variables.cat = Global.category;
			//var _request:URLRequest = new URLRequest(Global.URLfile);
			//_request.method = URLRequestMethod.POST;
			//_request.data = _variables;
			//checkLoader.addEventListener(Event.COMPLETE, loadedVerification);
			//checkLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			//checkLoader.load(_request);
		//}
		
		//private function loadedVerification(evt:Event)
		//{
			//checkLoader.removeEventListener(Event.COMPLETE, loadedVerification);
			//Main.debugger.println("Pass");
			//var resp:String= evt.currentTarget.data as String;
			//resp = resp.substring(0,resp.indexOf("\n"));
			//var jarr:Array = JSON.decode(resp) as Array;
			//
			//Main.debugger.println("Insurance Policy(Hour):"+jarr[0].happyHour);
			//Main.debugger.println("Hay ganador en período:"+jarr[0].existWinner);
			//
			//var existWinner:Number = parseInt(jarr[0].existWinner);
			//var happyHour:Boolean = (jarr[0].happyHour == "true")?true:false;
			//
			//if(ran != 11){
				//if(existWinner !=0) {
					//ran = 12;
					//Main.debugger.println("No puede ganar porque ya hay ganadore(s) en el período");
				//}
					//
				//if((Global.elapsedDays + 1) % Global.ratio == 0 && existWinner == 0 && happyHour){
					//ran = 0;
					//Main.debugger.println("La jugada es ganadora por estar en fecha límite de período y no haber ganadores.");
				//}
			//}
			//
			//if(ran < 0){
				//TweenLite.delayedCall(3, function():void {
					//ScreenManager.instance.gotoScreen(ErrorScreen);
				//});
			//}
			//else if (ran < 3){
				//saveData(true);
			//}
			//else{
				//saveData(false);
			//}
		//}
		//
		//private function saveData(winner:Boolean){
			//Main.debugger.println("Sending data to Server.(Save result)");
			//var _variables:URLVariables = new URLVariables();
			//_variables.method = "saveData";
			//_variables.suc = Global.codSuc;
			//_variables.mod = Global.codMod;
			//_variables.trans = Global.codTrans;
			//_variables.rel = Global.codRel;
			//_variables.amo = Global.amountInput;
			//_variables.tipoDoc = Global.tipoDoc;
			//_variables.numDoc = Global.numDoc;
			//_variables.nomCli = Global.nomCli;
			//_variables.nomAge = Global.nomAge;
			//_variables.cat = Global.category;
			//_variables.prize = Global.prize;
			//_variables.req = Global.req;
			//_variables.codRet = Global.codRet;
			//_variables.msgErr = Global.msgErr;
			//_variables.winner = winner;
			//var _request:URLRequest = new URLRequest(Global.URLfile);
			//_request.method = URLRequestMethod.POST;
			//_request.data = _variables;
			//if(winner)
				//winLoader.addEventListener(Event.COMPLETE, showWin);
			//else
				//winLoader.addEventListener(Event.COMPLETE, showLose);
			//winLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			//winLoader.load(_request);
		//}
		//
		//private function showWin(evt:Event)
		//{
			//winLoader.removeEventListener(Event.COMPLETE, showWin);
			//Main.debugger.println("Successfully sent");
			//var resp:String= evt.currentTarget.data as String;
			//resp = resp.substring(0,resp.indexOf("\n"));
			//var jarr:Array = JSON.decode(resp) as Array;
			//var err:String = jarr[0].error;
			//trace("e>"+err);
			//if(err == "OK"){
				//TweenLite.delayedCall(3, function():void {
					//ScreenManager.instance.gotoScreen(WinScreen);
				//});
			//}
			//else{
				//TweenLite.delayedCall(3, function():void {
					//ScreenManager.instance.gotoScreen(LoseScreen);
				//});
			//}
		//}
		//private function showLose(evt:Event)
		//{
			//winLoader.removeEventListener(Event.COMPLETE, showLose);
			//Main.debugger.println("Successfully sent");
			//var resp:String= evt.currentTarget.data as String;
			//resp = resp.substring(0,resp.indexOf("\n"));
			//TweenLite.delayedCall(3, function():void {
				//ScreenManager.instance.gotoScreen(LoseScreen);
			//});
		//}
		
		override public function update(dt:int):void 
		{
			super.update(dt);
		}
		
		override public function destroy():void 
		{
			super.destroy();
		}
	}
}