package 
{
	import com.gloop.Engine;
	import flash.display.Sprite;
	import flash.events.Event;
	import slotmachine.Global;
	import slotmachine.ui.WaitScreen;
	
	/**
	 * ...
	 * @author
	 */
	
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			init();
		}
		
		private function init():void 
		{
			Global.stage = stage;
			var engine:Engine = new Engine(this.stage, WaitScreen);
		}
	}
}