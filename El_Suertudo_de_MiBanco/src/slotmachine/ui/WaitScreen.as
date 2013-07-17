package slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import com.gloop.ui.ScreenManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import slotmachine.Global;
	import slotmachine.SlotMachineGame;
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
	import slotmachine.WinValidator;
/*
	import mx.rpc.soap.*;
	import mx.rpc.events.*;
	import mx.rpc.AbstractOperation;
	*/
	public class WaitScreen extends Screen 
	{
		private var _game:SlotMachineGame;
		private var _gameCanvas:MovieClip;
		private var _isActive:Boolean;
		private var loader:URLLoader = new URLLoader();
		private var dbgloader:URLLoader = new URLLoader();
		
		public function WaitScreen(canvas:MovieClip) 
		{
			
			super(canvas);
			var content:MovieClip = new mcWaitScreen();
			canvas.addChild(content);
			
			readData();
			/*TweenLite.delayedCall(1.5, function():void {
				ScreenManager.instance.gotoScreen(GameScreen);
			});*/
		}
		
		private function readData()
		{
			var _variables:URLVariables = new URLVariables();
			_variables.method = "readVars";
			var _request:URLRequest = new URLRequest("index.jsp");
			_request.method = URLRequestMethod.POST;
			_request.data = _variables;
			loader.addEventListener(Event.COMPLETE, loadingdata);
			loader.load(_request);
		}
		
		private function loadingdata(evt:Event)
		{
			loader.removeEventListener(Event.COMPLETE, loadingdata);
			
			var resp:String= evt.currentTarget.data as String;
			resp = resp.substring(0,resp.indexOf("\n"));
			
			var jarr:Array = JSON.decode(resp) as Array;
			Global.bt_age_cod = jarr[0].age_cod;
			Global.bt_cli_acc = jarr[1].cli_acc;
			Global.bt_tit_nam = jarr[2].tit_nam;
			Global.bt_acc_typ = jarr[3].acc_typ;
			Global.bt_user_dni = jarr[4].user_dni;
			Global.bt_user_sex = jarr[5].user_sex;
			Global.bt_ope_dat = jarr[6].ope_dat;
			Global.bt_fir_dep_dat = jarr[7].fir_dep_dat;
			//Global.bt_game_dat = jarr[8].game_dat;
			Global.bt_dep_curr = jarr[9].dep_curr;
			Global.bt_fir_dep_amo = jarr[10].fir_dep_amo;
			Global.bt_mac_user = jarr[11].mac_user;
			//Global.bt_winner = jarr[12].winner;
			//Global.bt_prize = jarr[13].prize;
			
			debugToServ(Global.bt_age_cod+"\n"+
						Global.bt_cli_acc+"\n"+
						Global.bt_tit_nam+"\n"+
						Global.bt_acc_typ+"\n"+
						Global.bt_user_dni+"\n"+
						Global.bt_user_sex+"\n"+
						Global.bt_ope_dat+"\n"+
						Global.bt_fir_dep_dat+"\n"+
						//Global.bt_game_dat+"\n"+
						Global.bt_dep_curr+"\n"+
						Global.bt_fir_dep_amo+"\n"+
						Global.bt_mac_user+"\n"
						//Global.bt_winner+"\n"+
						//Global.bt_prize
						);
			
			TweenLite.delayedCall(1.5, function():void {
				ScreenManager.instance.gotoScreen(GameScreen);
			});
		}
		
		private function debugToServ(str:String):void{
			var _variables:URLVariables = new URLVariables();
			_variables.method = "debugger";
			_variables.logged = str;
			var _request:URLRequest = new URLRequest("post.jsp");
			_request.method = URLRequestMethod.POST;
			_request.data = _variables;
			dbgloader.load(_request);
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