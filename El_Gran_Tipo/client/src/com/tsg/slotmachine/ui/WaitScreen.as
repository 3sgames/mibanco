package com.tsg.slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import com.gloop.ui.ScreenManager;
	import com.tsg.slotmachine.MiBancoGenerator;
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
			
			if (amo <= 500)
			{
				Global.seed = 10;
				Global.prize = "S/. 50";
				Global.category = "PZ01";
			}
			else if (amo <= 2000)
			{
				Global.seed = 20;
				Global.prize = "S/. 100";
				Global.category = "PZ02";
			}
			else if (amo <= 5000)
			{
				Global.seed = 30;
				Global.prize = "S/. 150";
				Global.category = "PZ03";
			}
			else if (amo > 5000)
			{
				Global.seed = 40;
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
			resp = resp.substring(0, resp.indexOf("\n"));
			var jarr:Array = JSON.decode(resp) as Array;
			
			if (jarr[0].error != "OK")
			{
				TweenLite.delayedCall(2, function():void
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
				
				Global.stock = parseInt(jarr[2].stock);
				Global.iniStock = parseInt(jarr[2].iniStock);
				
				var year:int;
				var month:int;
				var day:int;
				var hours:int;
				var minutes:int;
				var seconds:int;
				
				// última jugada
				year = parseInt(jarr[2].lastWinDate.substr(0,4));
				month = parseInt(jarr[2].lastWinDate.substr(5,2))-1;
				day = parseInt(jarr[2].lastWinDate.substr(8,2));
				hours = parseInt(jarr[2].lastWinDate.substr(11,2));
				minutes = parseInt(jarr[2].lastWinDate.substr(14,2));
				Main.debugger.println("Última jugada: " + day + " - " + (month + 1) + " - " + year + " a las: " + hours + ":" + minutes);
				
				Global.lastWinDate = new Date(year, month, day, hours, minutes);
				trace(Global.lastWinDate);
				
				Main.debugger.println("\nMonto ingresado: " + Global.amountInput);
				Main.debugger.println("Categoría: " + Global.category);
				
				// si hoy hay ganadores
				if (WinValidator.isTimeToWin())
				{
					saveData(true);
				}
				else
				{
					saveData(false);
				}
			}
		}
		
		private function saveData(winner:Boolean)
		{
			Main.debugger.println("Sending data to Server.(Save result)");
			var _variables:URLVariables = new URLVariables();
			_variables.method = "saveData";
			_variables.suc = Global.codSuc;
			_variables.mod = Global.codMod;
			_variables.trans = Global.codTrans;
			_variables.rel = Global.codRel;
			_variables.amo = Global.amountInput;
			_variables.tipoDoc = Global.tipoDoc;
			_variables.numDoc = Global.numDoc;
			_variables.nomCli = Global.nomCli;
			_variables.nomAge = Global.nomAge;
			_variables.cat = Global.category;
			_variables.prize = Global.prize;
			_variables.req = Global.req;
			_variables.codRet = Global.codRet;
			_variables.msgErr = Global.msgErr;
			_variables.winner = winner;
			var _request:URLRequest = new URLRequest(Global.URLfile);
			_request.method = URLRequestMethod.POST;
			_request.data = _variables;
			
			trace("winner: " + winner);
			
			if (winner)
			{	
				trace("mostrando ganar");
				winLoader.addEventListener(Event.COMPLETE, showWin);
			}
			else
			{
				trace("mostrando perder");
				winLoader.addEventListener(Event.COMPLETE, showLose);
			}
			
			winLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			winLoader.load(_request);
		}
		
		private function showWin(evt:Event)
		{
			winLoader.removeEventListener(Event.COMPLETE, showWin);
			Main.debugger.println("Successfully sent");
			var resp:String= evt.currentTarget.data as String;
			resp = resp.substring(0,resp.indexOf("\n"));
			var jarr:Array = JSON.decode(resp) as Array;
			var err:String = jarr[0].error;
			trace("e>"+err);
			
			if (err == "OK")
			{
				TweenLite.delayedCall(3, function():void {
					ScreenManager.instance.gotoScreen(WinScreen);
				});
			}
			else
			{
				TweenLite.delayedCall(3, function():void {
					ScreenManager.instance.gotoScreen(LoseScreen);
				});
			}
		}
		
		private function showLose(evt:Event)
		{
			winLoader.removeEventListener(Event.COMPLETE, showLose);
			Main.debugger.println("Successfully sent");
			var resp:String= evt.currentTarget.data as String;
			resp = resp.substring(0,resp.indexOf("\n"));
			TweenLite.delayedCall(3, function():void {
				ScreenManager.instance.gotoScreen(LoseScreen);
			});
		}
		
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