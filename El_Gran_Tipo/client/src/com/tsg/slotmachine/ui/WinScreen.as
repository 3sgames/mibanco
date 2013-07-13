package com.tsg.slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import com.gloop.ui.ScreenManager;
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import com.tsg.slotmachine.Global;
	import flash.external.ExternalInterface;
	
	public class WinScreen extends Screen 
	{
		public function WinScreen(canvas:MovieClip) 
		{
			super(canvas);
			var content:MovieClip = new mcWinScreen();
			canvas.addChild(content);
			content["txtPrize"].text = "¡Acabas de ganar un premio de " + Global.prize + "!";
			showOnTV();
			TweenLite.delayedCall(6, function():void {
				ScreenManager.instance.gotoScreen(EndScreen);
			});
		}
		
		function showOnTV(){
			var pass:String = ExternalInterface.call("ShowVideoInTv('gt_anim.swf', '14', '', '')") as String;
			
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