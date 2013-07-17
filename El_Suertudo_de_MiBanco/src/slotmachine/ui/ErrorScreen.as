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
	
	public class ErrorScreen extends Screen 
	{
		private var _game:SlotMachineGame;
		private var _gameCanvas:MovieClip;
		private var _isActive:Boolean;
		
		public function ErrorScreen(canvas:MovieClip) 
		{
			super(canvas);
			var content:MovieClip = new mcErrorScreen();
			canvas.addChild(content);
			
			content["txtMSG"].text = Global.bt_Msgerr;
			
			TweenLite.delayedCall(3, function():void {
					ScreenManager.instance.gotoScreen(LoginScreen);
				
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