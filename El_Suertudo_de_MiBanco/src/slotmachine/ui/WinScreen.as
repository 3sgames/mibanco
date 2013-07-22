package slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import com.gloop.ui.ScreenManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import slotmachine.Global;
	import slotmachine.SlotMachineGame;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import com.adobe.serialization.json.JSON;
	import flash.net.URLLoader;
	import slotmachine.Piece;
	import flash.utils.getDefinitionByName;
	
	public class WinScreen extends Screen 
	{
		private var loader:URLLoader = new URLLoader();
		private var dbgloader:URLLoader = new URLLoader();
		
		var classLoader:Class;
		
		var xOffSet:int = 50;
		
		public function WinScreen(canvas:MovieClip) 
		{
			super(canvas);
			var content:MovieClip = new mcWinScreen();
			canvas.addChild(content);
			
			content["txtPrize"].text = Global.winner_comb[5];
			
			addPieces();
			saveData();
			/*TweenLite.delayedCall(5, function():void {
					ScreenManager.instance.gotoScreen(WaitScreen);
			});*/
		}
		
		function addPieces(){
			for(var j:int = 0; j < Global.winner_comb.length - 2; j++)
				addPiece(j,150,Global.winner_comb[j]);
		}
		
		function addPiece(xCoord:Number,yCoord:Number,id:Number){
			classLoader = getDefinitionByName("piece"+id) as Class;
			//var tmp:Piece = classLoader(xOffSet+(xCoord * 128),yOffSet+(yCoord * 128),id);
			var tmp:Piece = new classLoader();
			tmp.x = xOffSet+(xCoord * 180);
			tmp.y = yCoord
			tmp.gotoAndStop(2);
			this._canvas.addChild(tmp);
			trace("added");
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
			_variables.winner = "S";//Global.bt_winner;
			_variables.prize = Global.winner_comb[4];//Global.bt_prize;
			var _request:URLRequest = new URLRequest("http://192.168.1.47:8080/Sabiasque/index.jsp");
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