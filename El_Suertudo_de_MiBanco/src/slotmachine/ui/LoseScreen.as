package slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import com.gloop.ui.ScreenManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import slotmachine.SlotMachineGame;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import slotmachine.Global;
	import com.adobe.serialization.json.JSON;
	import flash.net.URLLoader;
	
	public class LoseScreen extends Screen 
	{
		private var loader:URLLoader = new URLLoader();
		private var dbgloader:URLLoader = new URLLoader();
		
		public function LoseScreen(canvas:MovieClip) 
		{
			super(canvas);
			var content:MovieClip = new mcLoseScreen();
			canvas.addChild(content);
			
			//content["btnJugar"].addEventListener(MouseEvent.CLICK, onPlay);
			
			saveData();
			/*TweenLite.delayedCall(5, function():void {
				ScreenManager.instance.gotoScreen(WaitScreen);
			});*/
		}
		
		private function saveData(){
			var _variables:URLVariables = new URLVariables();
			_variables.method = "saveVars";
			_variables.age_cod = Global.bt_age_cod;
			_variables.cli_acc = Global.bt_cli_acc;
			_variables.tit_nam = Global.bt_tit_nam;
			_variables.acc_typ = Global.bt_acc_typ;
			_variables.user_dni = Global.bt_user_dni;
			_variables.user_sex = Global.bt_user_sex;
			_variables.ope_dat = Global.bt_ope_dat;
			_variables.fir_dep_dat = Global.bt_fir_dep_dat;
			//_variables.game_dat = Global.bt_game_dat;
			_variables.dep_curr = Global.bt_dep_curr;
			_variables.fir_dep_amo = Global.bt_fir_dep_amo;
			_variables.mac_user = Global.bt_mac_user;
			_variables.winner = "N";//Global.bt_winner;
			_variables.prize = "NULL";//Global.bt_prize;
			var _request:URLRequest = new URLRequest("index.jsp");
			_request.method = URLRequestMethod.POST;
			_request.data = _variables;
			loader.addEventListener(Event.COMPLETE, loadingdata);
			loader.load(_request);
		}
		
		private function loadingdata(evt:Event)
		{
			loader.removeEventListener(Event.COMPLETE, loadingdata);
			
			TweenLite.delayedCall(5, function():void {
					//closePage();//ScreenManager.instance.gotoScreen(WaitScreen);
			});
		}
		/*
		private function debugToServ(str:String):void{
			var _variables:URLVariables = new URLVariables();
			_variables.method = "debugger";
			_variables.logged = str;
			var _request:URLRequest = new URLRequest("post.jsp");
			_request.method = URLRequestMethod.POST;
			_request.data = _variables;
			dbgloader.load(_request);
		}*/
		
		private function closePage(str:String):void{
			var _variables:URLVariables = new URLVariables();
			_variables.method = "close";
			var _request:URLRequest = new URLRequest("index.jsp");
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