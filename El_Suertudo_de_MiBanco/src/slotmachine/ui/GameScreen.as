package slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import flash.display.MovieClip;
	import slotmachine.SlotMachineGame;
	//-------
	import com.adobe.serialization.json.JSON;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	
	public class GameScreen extends Screen 
	{
		private var _game:SlotMachineGame;
		private var _gameCanvas:MovieClip;
		//private var _isActive:Boolean;
		
		var content:MovieClip = new mcGameScreen();
		
		public function GameScreen(canvas:MovieClip) 
		{
			super(canvas);
			
			
			canvas.addChild(content);
			
			_gameCanvas = new MovieClip();
			_canvas.addChild(_gameCanvas);
			_game = new SlotMachineGame(_gameCanvas);
		}
		
		
		
		override public function update(dt:int):void 
		{
			//if (!_isActive) return;
			
			super.update(dt);
			_game.update(dt);
		}
		
		override public function destroy():void 
		{
			super.destroy();
			SlotMachineGame(_game).destroy();
		}
	}
}