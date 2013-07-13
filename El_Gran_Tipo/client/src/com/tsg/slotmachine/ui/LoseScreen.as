package com.tsg.slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import com.gloop.ui.ScreenManager;
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	
	public class LoseScreen extends Screen 
	{
		public function LoseScreen(canvas:MovieClip) 
		{
			super(canvas);
			var content:MovieClip = new mcLoseScreen();
			canvas.addChild(content);
			
			TweenLite.delayedCall(6, function():void {
				ScreenManager.instance.gotoScreen(EndScreen);
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