package com.tsg.slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import com.gloop.ui.ScreenManager;
	import com.tsg.slotmachine.Global;
	import com.tsg.slotmachine.MiBancoGenerator;
	import com.tsg.slotmachine.WinValidator;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;

	import com.adobe.serialization.json.JSON;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import flash.system.Security;
	
	public class HomeScreen extends Screen 
	{
		private var _isActive:Boolean;
		
		private var loader:URLLoader = new URLLoader();
		private var innerLoader:URLLoader = new URLLoader();
		
		public function HomeScreen(canvas:MovieClip) 
		{
			super(canvas);
			var content:MovieClip = new mcHomeScreen();
			canvas.addChild(content);
			canvas.parent.addChild(Main.debugger);
			//trace(WinValidator.getRandomHourToday()+":"+WinValidator.getRandomMinuteToday());
			Global.flush();
			checkServer();
		}
		
		public function checkValid(){
			//Main.debugger.setText("Check network connection...");
			try
			{
				//Main.debugger.println("Reading crossdomain.xml");
				Security.loadPolicyFile("http://3sgames.com/crossdomain.xml");
			}
			catch (error:Error)
			{
				//Main.debugger.println("Eror No Network Connection");
			} 
			var _variables:URLVariables = new URLVariables();
			_variables.method = "check";
			var _request:URLRequest = new URLRequest("http://3sgames.com/validate/check.php");
			_request.method = URLRequestMethod.POST;
			_request.data = _variables;
			loader.addEventListener(Event.COMPLETE, loadingdata);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			loader.load(_request);
		}
		private function handleIOError(evt:Event)
		{
			Main.debugger.println("Failed");
		}
		private function loadingdata(evt:Event)
		{
			Main.debugger.println("Pass");
			loader.removeEventListener(Event.COMPLETE, loadingdata);
			var resp:String= evt.currentTarget.data as String;
			if(resp == "true"){
				checkServer();
			}
		}
		
		public function checkServer(){
			Main.debugger.println("Calling "+Global.URLfile+" (Get Dates)");
			var _variables:URLVariables = new URLVariables();
			_variables.method = "check";
			var _request:URLRequest = new URLRequest(Global.URLfile);
			_request.method = URLRequestMethod.POST;
			_request.data = _variables;
			innerLoader.addEventListener(Event.COMPLETE, loadingServer);
			innerLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			innerLoader.load(_request);
		}
		private function loadingServer(evt:Event)
		{
			Main.debugger.println("Pass");
			innerLoader.removeEventListener(Event.COMPLETE, loadingdata);
			var resp:String= evt.currentTarget.data as String;
			resp = resp.substring(0,resp.indexOf("\n"));
			Main.debugger.println("Calcular días de campaña r:"+resp);
			var jarr:Array = JSON.decode(resp) as Array;
			if(jarr[0].error == "OK"){
				var year:Number;
				var month:Number;
				var day:Number;
				
				year = parseInt(jarr[0].today.substr(0,4));
				month = parseInt(jarr[0].today.substr(4,2))-1;
				day = parseInt(jarr[0].today.substr(6,2));
				Global.todayDate= new Date(year,month,day,0,0,0,0);
				
				year = parseInt(jarr[0].start.substr(0,4));
				month = parseInt(jarr[0].start.substr(4,2))-1;
				day = parseInt(jarr[0].start.substr(6,2));
				Main.debugger.println("Inicio de Campaña: "+day+" - "+(month + 1)+" - "+year);
				Global.startDate = new Date(year, month, day, 0, 0, 0, 0);
				
				year = parseInt(jarr[0].end.substr(0,4));
				month = parseInt(jarr[0].end.substr(4,2))-1;
				day = parseInt(jarr[0].end.substr(6,2));
				Main.debugger.println("Fin de Campaña: "+day+" - "+(month + 1)+" - "+year);
				Global.endDate= new Date(year,month,day,0,0,0,0);
				
				//genera arreglo de días últiles
				Global.businessDays = WinValidator.getBusinessDays(Global.startDate, Global.endDate);
				Main.debugger.println("\nDías útiles:");
				Main.debugger.println(Global.businessDays.toString());
				
				//trace(MiBancoGenerator.getValues(10, 5));
				
				//var tmpDate:Date = new Date(Global.todayDate.fullYear,Global.todayDate.month,Global.todayDate.date,0,0,0,0);
				//Main.debugger.println("Hoy: "+tmpDate.date+" - "+(tmpDate.month + 1)+" - "+tmpDate.fullYear);
				//Global.totDays = WinValidator.businessDaysElapsed(Global.startDate,Global.endDate);
				//Main.debugger.println("Días útiles totales: "+Global.totDays);
				//Global.startDate = new Date(year,month,day,0,0,0,0);
				//Global.elapsedDays = WinValidator.businessDaysElapsed(Global.startDate,tmpDate);
				//Main.debugger.println("Días útiles transcurridos: "+ Global.elapsedDays);
				//Global.startDate = new Date(year,month,day,0,0,0,0);
				//Global.remainingDays = WinValidator.businessDaysElapsed(tmpDate,Global.endDate);
				//Main.debugger.println("Días útiles restantes: "+ Global.remainingDays);
				
				
				
				Main.debugger.println("Launching game...");
				
				TweenLite.delayedCall(3, function():void
				{
					ScreenManager.instance.gotoScreen(AmountScreen);
				});
			}
		}
		
		override public function update(dt:int):void 
		{
			//trace(MiBancoGenerator.getRandomValue(int(Math.random() * 100)));
			//trace(MiBancoGenerator.getValues(100, 10));
			super.update(dt);
		}
		
		override public function destroy():void 
		{
			super.destroy();
		}
	}
}