package slotmachine
{
	import com.gloop.Game;
	import com.gloop.ui.ScreenManager;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import slotmachine.ui.LoseScreen;
	import slotmachine.ui.WinScreen;
	//-------
	import com.adobe.serialization.json.JSON;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.system.SecurityDomain;
	import flash.utils.getDefinitionByName;

	
	public class SlotMachineGame extends Game
	{
		private var dbgloader:URLLoader = new URLLoader();
		/*private var _mcContent:MovieClip;
		private var _rolls:Array = [];
		private var _isPlaying:Boolean;
		private var rankingLoader:URLLoader = new URLLoader();
		private var existWinner= new Boolean();
		private var loader:URLLoader = new URLLoader();
		private var result1:String = new String();
		private var player:Object = new Object();
		private var mensaje:Array = new Array();
		private var url:String = new String();
		private var requestData:URLRequest;
		private var requestVars:URLVariables;*/
		var xOffSet:Number = 100;
		var yOffSet:Number = 125;
		var piece_array:Array;
		var pieces:Array = new Array();
		var classLoader:Class;
		var piecesShowing:Array = new Array(null,null,null,null);
		var canClick:Boolean = true;	
		
		var maxRepeatedPieces:int = 2;
		/*
		0 = buddha
		1 = gato
		2 = herradura
		3 = wayruro
		4 = pluma
		5 = trebol
		*/
		var combinations:Array = [
							[3,4,1,5,"a01","Sandwichera"],
							[3,2,5,0,"a02","Plancha"],
							[2,0,3,1,"a03","Olla Arrocera"],
							[2,4,5,1,"a04","Camara Digital"],
							[5,3,4,2,"a05","Reproductor MP4"],
							[5,1,2,0,"a06","Licuadora"],
							[0,4,5,3,"a07","TV"],
							[0,1,3,2,"a08","Radio CD"],
							[4,3,2,5,"a09","Hervidor"],
							[4,0,5,1,"a10","Microondas"],
							[1,2,3,4,"m01","Lapicero"],
							[1,5,0,3,"m02","Libretas"],
							[5,2,4,1,"m03","Polo"],
							[3,1,5,2,"m04","Gorro"],
							[4,2,5,0,"m05","Chimpunera"]
			];
		
		public function SlotMachineGame(canvas:MovieClip)
		{
			super(canvas);
			Global.game = this;

			LuckyGame();
		}
		
		
		public function LuckyGame(){
			Global.game = this;
			
			piece_array = [
						   [(-1),(-1),(-1)],
						   [(-1),(-1),(-1)],
						   [(-1),(-1),(-1)],
						   [(-1),(-1),(-1)]
			];
			startGame();
		}
		
		function startGame(){
			for(var i:int = 0; i < piece_array.length; i++){
				var ran:int = getNextID(6);
				for(var j:int = 0; j < piece_array[i].length; j++){
					if(checkNumber(ran)){
						piece_array[i][j] = ran;
					}else{
						ran = getNextID(6);
						j--;
					}
				}
			}
				trace(""+piece_array);
				//debugToServ(""+ piece_array);
				addPieces();
		}
		
		function checkNumber(id:int):Boolean{
			var counter:int = 0;
			for(var m:int = 0; m < piece_array.length; m++){
				for(var n:int = 0; n < piece_array[m].length; n++){
					if(id == piece_array[m][n])
						counter++;
					if(counter >= maxRepeatedPieces)
						return false;
				}
			}
			return true;
		}
		
		function getNextID(qty:Number):Number{
			return Math.floor(Math.random() * qty);
		}
		
		function addPieces(){
			for(var i:int = 0; i < piece_array.length; i++){
				//trace(piece_array.length+"===>"+piece_array[i].length);
				for(var j:int = 0; j < piece_array[i].length; j++)
					addPiece(i,j,piece_array[i][j]);
			}
		}
		
		function addPiece(xCoord:Number,yCoord:Number,id:Number){
			classLoader = getDefinitionByName("piece"+id) as Class;
			//var tmp:Piece = classLoader(xOffSet+(xCoord * 128),yOffSet+(yCoord * 128),id);
			var tmp:Piece = new classLoader();
			tmp.x = xOffSet+(xCoord * 155);
			tmp.y = yOffSet+(yCoord * 145);
			tmp.id = id;
			tmp.addEventListener(MouseEvent.CLICK,pieceEventListener);
			//trace("===>"+tmp.x + ","+tmp.y)
			pieces.push(tmp);
			this._canvas.addChild(tmp);
		}

		function pieceEventListener(evt:MouseEvent){
			//if(canClick == false) return;
			if(piecesShowing[3] == null && piecesShowing[0] != evt.currentTarget && piecesShowing[1] != evt.currentTarget && piecesShowing[2] != evt.currentTarget){
				//trace(""+piecesShowing);
				evt.currentTarget.play();
				
				if(piecesShowing[0] == null)
					piecesShowing[0] = evt.currentTarget;
				else if(piecesShowing[1] == null)
					piecesShowing[1] = evt.currentTarget;
				else if(piecesShowing[2] == null)
					piecesShowing[2] = evt.currentTarget;
				else{
					piecesShowing[3] = evt.currentTarget;
					endGame();
				}
			}
		}	
		
		function endGame(){
			if(checkCombination()){
				TweenLite.delayedCall(1.5, function():void {
					ScreenManager.instance.gotoScreen(WinScreen);
				});
			}
			else {
				TweenLite.delayedCall(1.5, function():void {
					ScreenManager.instance.gotoScreen(LoseScreen);
				});
			}
		}
		
		function checkCombination():Boolean{
			for(var i:int = 0; i < combinations.length; i++){
				var tmpCheck:Array = new Array();
				tmpCheck[0] = piecesShowing[0];
				tmpCheck[1] = piecesShowing[1];
				tmpCheck[2] = piecesShowing[2];
				tmpCheck[3] = piecesShowing[3];
				for(var j:int = 0; j < combinations[i].length - 2; j++){
					for(var m:int = 0; m < tmpCheck.length; m++){
						if(combinations[i][j] == tmpCheck[m].id)
							tmpCheck.splice(m,1);
					}
				}
				if(tmpCheck.length == 0){
					Global.winner_comb = combinations[i];
					return true;
				}
			}
			return false;
		}
		
		private function debugToServ(str:String):void{
			var _variables:URLVariables = new URLVariables();
			_variables.method = "debugger";
			_variables.logged = str;
			var _request:URLRequest = new URLRequest("index.jsp");
			_request.method = URLRequestMethod.POST;
			_request.data = _variables;
			//dbgloader.addEventListener(Event.COMPLETE, debugging);
			dbgloader.load(_request);
		}
		
/*
		private function init():void
		{
			WinValidator.setInitValues();

			_mcContent = new mcGameScreen();

			_mcContent["mcLuz_1"].gotoAndPlay("amarillo");
			_mcContent["mcLuz_2"].gotoAndPlay("magenta");
			_mcContent["mcLuz_3"].gotoAndPlay("verde");
			_mcContent["mcLuz_4"].gotoAndPlay("magenta");
			_mcContent["mcLuz_5"].gotoAndPlay("verde");
			_mcContent["mcLuz_6"].gotoAndPlay("amarillo");

			_rolls.push(new Roll(0, _mcContent["mcRoll_1"]));
			_rolls.push(new Roll(1, _mcContent["mcRoll_2"]));
			_rolls.push(new Roll(2, _mcContent["mcRoll_3"]));

			//_mcContent["btnPlay"].addEventListener(MouseEvent.CLICK, onSpin);

			_canvas.addChild(_mcContent);
			//seekingWinner();
		}
		*/
		/*private function onSpin(e:MouseEvent):void
		{
			if (_isPlaying)
			{
				return;
			}
			saveUser();
		}*/
		
		/*private function saveUser(){
			var _variables:URLVariables = new URLVariables();
			_variables.method = "registerUser";
			_variables.nrosolicitud = Global.bt_Nrosolicitud;
			_variables.cuenta =  Global.bt_Cuenta;
			_variables.operacion =  Global.bt_Operacion;
			_variables.modulo = Global.bt_Modulo;
			_variables.toperacion =  Global.bt_Toperacion;
			_variables.tdocumento =  Global.bt_Tdocumento;
			_variables.ndocumento =  Global.bt_Ndocumento;
			_variables.ncliente =  Global.bt_NCliente;
			_variables.sucurs = Global.bt_Sucurs;
			_variables.nombreagencia =  Global.bt_Nombreagencia;
			
			var _request:URLRequest = new URLRequest("post.jsp");
			_request.method = URLRequestMethod.POST;
			_request.data = _variables;
			loader.addEventListener(Event.COMPLETE, userSaved);
			loader.load(_request);
		}*/
		/*
		private function userSaved(evt:Event)
		{
			loader.removeEventListener(Event.COMPLETE, userSaved);
			
			checkWinner();
		}
		
		private function checkWinner(){
			var _variables:URLVariables = new URLVariables();
			_variables.method = "checkWinner";
			_variables.voucher = Global.bt_Nrosolicitud;
			_variables.sucurs = Global.bt_Sucurs;
			_variables.hour = ""+WinValidator.getRandomHourToday();
			_variables.min = ""+WinValidator.getRandomMinuteToday();
			var _request:URLRequest = new URLRequest("post.jsp");
			_request.method = URLRequestMethod.POST;
			_request.data = _variables;
			loader.addEventListener(Event.COMPLETE, returnWinner);
			loader.load(_request);
		}
		
		private function returnWinner(evt:Event)
		{
			loader.removeEventListener(Event.COMPLETE, returnWinner);
			
			var resp:String= evt.currentTarget.data as String;
			resp = resp.substring(resp.indexOf(":") + 2,resp.indexOf("\n") - 3);
			
			if(resp == "true"){
				Global.timeToWin = true;
			}
			else if(resp == "false"){
				Global.timeToWin = false;
			}
			
			
			WinValidator.setFinalValues();
			//_mcContent["btnPlay"].removeEventListener(MouseEvent.CLICK, onSpin);

			_isPlaying = true;
			_rolls[0].spin(0);
			_rolls[1].spin(0.3);
			_rolls[2].spin(0.6, onSpinEnd);
			
		}
		
		private function onSpinEnd():void
		{
			_isPlaying = false;

			var i:int;
			var roll:Array = [3];

			for (i = 0; i < 3; i++)
			{
				roll[i] = _rolls[i].visibleItems;
			}

			//roll[0][1] = roll[1][1];
			//roll[1][1] = roll[2][1];

			//trace(roll[0][0].currentLabel, roll[1][0].currentLabel, roll[2][0].currentLabel);

			//if (roll[0][1].currentLabel == roll[1][1].currentLabel && roll[1][1].currentLabel == roll[2][1].currentLabel)
			if (roll[0][0].currentLabel == roll[1][0].currentLabel && roll[1][0].currentLabel == roll[2][0].currentLabel)
						//if (roll[1][1] == roll[2][1])
			{
				
				//trace("llego aca");
				//Buscando si hay ganador
				if (!Global.timeToWin)
				{
					//trace("lose");
					//setGameLose();
					//saveResult("N");
					TweenLite.delayedCall(1.5, function():void {
					ScreenManager.instance.gotoScreen(LoseScreen);
				
				});
					
				}
				else if (Global.timeToWin)
				{
					//trace("won");
					//setGameWin();
					saveResult("S");
					//WinValidator.saveWin();
					TweenLite.delayedCall(1.5, function():void {
					ScreenManager.instance.gotoScreen(WinScreen);
					});

				}


			}
			else
			{
					//trace("lose by omision");
				//setGameLose();
				//saveResult("N");

				TweenLite.delayedCall(1.5, function():void {
				ScreenManager.instance.gotoScreen(LoseScreen);
				
				});
			}
		}
*/
		public function restart():void
		{
			destroy();
		}
/*
		public function saveResult(won:String):void
		{
			var _variables:URLVariables = new URLVariables();
			_variables.method = "saveResult";
			_variables.vc = Global.bt_Nrosolicitud;
			_variables.ct = Global.bt_Cuenta;
			_variables.op = Global.bt_Operacion;
			_variables.md = Global.bt_Modulo;
			_variables.to = Global.bt_Toperacion;
			_variables.td = Global.bt_Tdocumento;
			_variables.dc = Global.bt_Ndocumento;
			_variables.cl = Global.bt_NCliente;
			_variables.sc = Global.bt_Sucurs;
			_variables.ag = Global.bt_Nombreagencia;
			_variables.gn = won;
			_variables.rq = Global.bt_Cumplerequisitos;
			var _request:URLRequest = new URLRequest("post.jsp");
			_request.method = URLRequestMethod.POST;
			_request.data = _variables;
			//loader.addEventListener(Event.COMPLETE, loadingdata);
			loader.load(_request);
		}*/
/*
		private function loadingdata(evt:Event)
		{
			loader.removeEventListener(Event.COMPLETE, loadingdata);
			
			var resp:String= evt.currentTarget.data as String;
			
			//var jarr:Array = JSON.decode(resp) as Array;
			debugToServ(resp+"\n");
		}
		*/
		/*public function setGameLose()
		{
			player.cod_voucher=Global.cod_voucher;
			player.resultado = "L";
			mensaje.push(player);
			url = "post.jsp";
			requestData = new URLRequest(url);
			requestData.method = URLRequestMethod.POST;
			requestVars = new URLVariables();
			requestVars.method = "setLose";
			requestVars.myObject = JSON.encode(mensaje);
			requestData.data = requestVars;
			loader.load(requestData);
		
		}
		*/
		/*function setGameWin()
		{*/
			/*
			player.resultado = "W";
			mensaje.push(player);
			url = "post.jsp";
			requestData = new URLRequest(url);
			requestData.method = URLRequestMethod.POST;
			requestVars = new URLVariables();
			requestVars.method = "setWin";
			requestVars.myObject = JSON.encode(mensaje);
			requestData.data = requestVars;
			loader.load(requestData);
			*/

		/*}
		*/
		/*public function seekingWinner()
		{
		}
*/

/*
		override public function destroy():void
		{
			_mcContent = null;
			_rolls = [];
			_isPlaying = false;
			super.destroy();
		}
*/
		
	}
}