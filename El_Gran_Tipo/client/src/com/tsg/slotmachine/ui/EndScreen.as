package com.tsg.slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import com.gloop.ui.ScreenManager;
	import flash.display.MovieClip;
	
	public class EndScreen extends Screen 
	{
		
		public function EndScreen(canvas:MovieClip) 
		{
			super(canvas);
			var content:MovieClip = new mcEndScreen();
			canvas.addChild(content);
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