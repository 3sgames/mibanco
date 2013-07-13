package com.tsg.slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import com.gloop.ui.ScreenManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.tsg.slotmachine.Global;
	import com.greensock.TweenLite;
	
	public class AmountScreen extends Screen 
	{
		var content:MovieClip;
		var dots:int = 0;
		var decs:int = 0;
		
		public function AmountScreen(canvas:MovieClip) 
		{
			super(canvas);
			content = new mcAmountScreen();
			canvas.addChild(content);
			
			var i:int = 0;
			for (; i < 10; i++)
			{
				content["btn" + i].addEventListener(MouseEvent.CLICK, onPush);
			}
			content["btnDot"].addEventListener(MouseEvent.CLICK, addDot);
			content["btnClear"].addEventListener(MouseEvent.CLICK, deleteVoucher);
			content["btnOK"].addEventListener(MouseEvent.CLICK, onPlay);
		}
		
		private function addDot(e:MouseEvent):void
		{
			if(dots++ >= 1)
				return;
			//dots++;
			content["txtAmount"].text+= ".";
		}
		private function onPush(e:MouseEvent):void 
		{
			if(dots >= 1  && decs++ >= 2)
				return;
			if(content["txtAmount"].length < 13)
				content["txtAmount"].text+= (e.target.name).substring(3.1).toString();
		}
		
		private function deleteVoucher(e:MouseEvent):void 
		{
			dots = 0;
			decs = 0;
			content["txtAmount"].text="";
		}
		
		private function onPlay(e:MouseEvent):void 
		{
			Global.amountInput = content["txtAmount"].text;
 			
			if(Global.amountInput.length == 0)//Global.bt_Nrosolicitud.length > 10 || Global.bt_Nrosolicitud.length == 0)
				ScreenManager.instance.gotoScreen(ErrorScreen);
			else
				ScreenManager.instance.gotoScreen(DemoScreen);
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