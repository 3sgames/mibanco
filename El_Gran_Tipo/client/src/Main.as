package 
{
	import com.gloop.Engine;
	import com.tsg.slotmachine.Global;
	import com.tsg.slotmachine.TestScreen;
	import com.tsg.slotmachine.ui.HomeScreen;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import com.tsg.util.Debugger;
	
	import flash.display.LoaderInfo;
	import flash.external.ExternalInterface;

	public class Main extends Sprite 
	{
		public static var debugger:Debugger = new Debugger();
		
		public function Main():void 
		{
			init();
		}
		
		private function init():void 
		{
			var d:Boolean = ExternalInterface.call("checkDebug");
			
			//Modificar la siguiente línea
			debugger.visible = true;//d;
			debugger.setText("Start Application ");
			Global.stage = stage;
			var engine:Engine = new Engine(this.stage, HomeScreen);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
		}
		
		private function _onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == 32)
			{
				debugger.visible = !debugger.visible;
			}
		}
	}
}