package com.tsg.slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import com.gloop.ui.ScreenManager;
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	
	public class ErrorScreen extends Screen 
	{
		public function ErrorScreen(canvas:MovieClip) 
		{
			super(canvas);
			var content:MovieClip = new mcErrorScreen();
			canvas.addChild(content);
			
			TweenLite.delayedCall(3, function():void {
				ScreenManager.instance.gotoScreen(HomeScreen);
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