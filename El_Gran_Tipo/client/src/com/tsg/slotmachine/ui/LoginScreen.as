package com.tsg.slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import com.gloop.ui.ScreenManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import slotmachine.SlotMachineGame;
	import com.tsg.slotmachine.Global;
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import slotmachine.WinValidator;
	

	
	public class LoginScreen extends Screen 
	{	
		var content:MovieClip = new mcLoginScreen();
		private var loader:URLLoader = new URLLoader();
		private var dbgloader:URLLoader = new URLLoader();
		//private var test = "";
		public function LoginScreen(canvas:MovieClip) 
		{
			super(canvas);
			
			canvas.addChild(content);
			
			content["btn1"].addEventListener(MouseEvent.CLICK, onPush);
			content["btn2"].addEventListener(MouseEvent.CLICK, onPush);
			content["btn3"].addEventListener(MouseEvent.CLICK, onPush);
			content["btn4"].addEventListener(MouseEvent.CLICK, onPush);
			content["btn5"].addEventListener(MouseEvent.CLICK, onPush);
			content["btn6"].addEventListener(MouseEvent.CLICK, onPush);
			content["btn7"].addEventListener(MouseEvent.CLICK, onPush);
			content["btn8"].addEventListener(MouseEvent.CLICK, onPush);
			content["btn9"].addEventListener(MouseEvent.CLICK, onPush);
			content["btn0"].addEventListener(MouseEvent.CLICK, onPush);
			content["btnBorrar"].addEventListener(MouseEvent.CLICK, deleteVoucher);
			content["btnEmpezar"].addEventListener(MouseEvent.CLICK, onPlay);
			
			Global.flush();
			//trace("H:"+WinValidator.getRandomHourToday());
			//trace("M:"+WinValidator.getRandomMinuteToday());
			
			//debugToServ("Time to win: "+WinValidator.getRandomHourToday()+"."+WinValidator.getRandomMinuteToday());
			
			//callDummy();
		}
		/*
		private function callDummy(){
			var _variables:URLVariables = new URLVariables();
			_variables.method = "dummyTest";
			_variables.voucher = "1234567890";
			_variables.name = "Luigi Maguina";
			var _request:URLRequest = new URLRequest("post.jsp");
			_request.method = URLRequestMethod.POST;
			_request.data = _variables;
			loader.addEventListener(Event.COMPLETE, loadingdata);
			loader.load(_request);
		}
		*/
		/*private function loadingdata(evt:Event)
		{
			loader.removeEventListener(Event.COMPLETE, loadingdata);
			
			var resp:String= evt.currentTarget.data as String;
			
			resp = resp.substring(0,resp.indexOf("\n")-1);
			var jarr:Array = JSON.decode(resp) as Array;
			
			//test = ""+resp.indexOf("\n");//resp+"::"+jarr[0].resp;
			
			var t:String = jarr[0].resp;
			var m:String = jarr[1].nm;
			var p:String = jarr[2].vc;
			
			var debug:String = "";
			for(var i:int = 0; i< jarr.length; i++){
				debug += jarr[i];
			}
			//debugToServ(resp+"::"+jarr.length+"::"+t+"-"+m+"-"+p+"\n"+debug);
		}*/
		/*
		private function debugToServ(str:String):void{
			var _variables:URLVariables = new URLVariables();
			_variables.method = "debugger";
			_variables.logged = str;
			var _request:URLRequest = new URLRequest("post.jsp");
			_request.method = URLRequestMethod.POST;
			_request.data = _variables;
			//dbgloader.addEventListener(Event.COMPLETE, debugging);
			dbgloader.load(_request);
		}
		*/
		private function onPush(e:MouseEvent):void 
		{
			if(content["txtCode"].length < 10)
				content["txtCode"].text+= (e.target.name).substring(3).toString() ;
		}
		
		
		private function deleteVoucher(e:MouseEvent):void 
		{
			content["txtCode"].text="";
		}
		
		
		private function onPlay(e:MouseEvent):void 
		{
			/*Global.bt_Nrosolicitud = content["txtCode"].text;
 			
			if(Global.bt_Nrosolicitud.length == 0)//Global.bt_Nrosolicitud.length > 10 || Global.bt_Nrosolicitud.length == 0)
				ScreenManager.instance.gotoScreen(ErrorScreen);
			else
				ScreenManager.instance.gotoScreen(GameScreen);*/
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