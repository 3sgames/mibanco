package slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import com.gloop.ui.ScreenManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import slotmachine.Global;
	import slotmachine.SlotMachineGame;
	import com.greensock.TweenLite;
	
	/**
	 * ...
	 * @author 
	 */
	
	public class PrevScreen extends Screen 
	{
		private var _game:SlotMachineGame;
		private var _gameCanvas:MovieClip;
		private var _isActive:Boolean;
		
		public function PrevScreen(canvas:MovieClip) 
		{
			super(canvas);
			var content:MovieClip = new mcPrevScreen();
			canvas.addChild(content);
			
			//content["btnJugar"].addEventListener(MouseEvent.CLICK, onPlay);
			TweenLite.delayedCall(5, function():void {
					ScreenManager.instance.gotoScreen(GameScreen);
				
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