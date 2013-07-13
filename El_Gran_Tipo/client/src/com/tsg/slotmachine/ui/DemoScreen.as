package com.tsg.slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import com.gloop.ui.ScreenManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	
	public class DemoScreen extends Screen 
	{
		
		public function DemoScreen(canvas:MovieClip) 
		{
			super(canvas);
			var content:MovieClip = new mcDemoScreen();
			canvas.addChild(content);
			content["btnOK"].addEventListener(MouseEvent.CLICK, onPush);
			/*
			TweenLite.delayedCall(3, function():void {
				ScreenManager.instance.gotoScreen(VoucherScreen);
			});*/
		}
		
		private function onPush(evt:MouseEvent):void 
		{
			ScreenManager.instance.gotoScreen(VoucherScreen);
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