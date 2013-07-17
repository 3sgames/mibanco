package com.tsg.slotmachine.ui
{	
	import com.gloop.ui.Screen;
	import com.gloop.ui.ScreenManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.tsg.slotmachine.Global;
	import com.greensock.TweenLite;
	import flash.text.TextField;
	
	public class VoucherScreen extends Screen 
	{
		private var _isActive:Boolean;
		var content:MovieClip;
		
		var txtSelected:TextField;
		var limit:int;
		
		public function VoucherScreen(canvas:MovieClip) 
		{
			super(canvas);
			content = new mcVoucherScreen();
			canvas.addChild(content);
			
			txtSelected = content["txtSuc"];
			limit = 3;
			
			var i:int = 0;
			for(;i < 10;i++)
				content["btn"+i].addEventListener(MouseEvent.CLICK, onPush);
			content["btnClear"].addEventListener(MouseEvent.CLICK, deleteVoucher);
			content["btnOK"].addEventListener(MouseEvent.CLICK, onPlay);
			
			content["txtSuc"].addEventListener(MouseEvent.CLICK, setTextField);
			content["txtMod"].addEventListener(MouseEvent.CLICK, setTextField);
			content["txtTrans"].addEventListener(MouseEvent.CLICK, setTextField);
			content["txtRel"].addEventListener(MouseEvent.CLICK, setTextField);
		}

		private function setTextField(e:MouseEvent):void 
		{
			txtSelected = (TextField)(e.currentTarget);
			if((e.target.name).substring(3.1).toString() == "Rel")
				limit = 4;
			else
				limit = 3;
		}

		private function onPush(e:MouseEvent):void 
		{
			if(txtSelected.length < limit)
				txtSelected.appendText((e.target.name).substring(3.1).toString());
		}
		
		private function deleteVoucher(e:MouseEvent):void 
		{
			content["txtSuc"].text = "";
			content["txtMod"].text = "";
			content["txtTrans"].text = "";
			content["txtRel"].text = "";
			
			txtSelected = content["txtSuc"];
			limit = 3;
		}
		
		private function onPlay(e:MouseEvent):void 
		{
			Global.codSuc = content["txtSuc"].text;
			Global.codMod = content["txtMod"].text;
			Global.codTrans = content["txtTrans"].text;
			Global.codRel = content["txtRel"].text;
 			
			if((Global.codSuc.length == 0 || Global.codSuc.length > 3) ||
			   (Global.codMod.length == 0 || Global.codMod.length > 3) ||
			   (Global.codTrans.length == 0 || Global.codTrans.length > 3) ||
			   (Global.codRel.length == 0 || Global.codRel.length > 4) ||
			   parseFloat(Global.amountInput) < 50 ||
			   !checkStartDate() || !checkEndDate())
				ScreenManager.instance.gotoScreen(ErrorScreen);
			else
				ScreenManager.instance.gotoScreen(WaitScreen);
		}
		
		private function checkStartDate():Boolean
		{
			var tmpDate:Date = new Date((new Date()).getFullYear(), (new Date()).getMonth(), (new Date()).getDate(), 0, 0, 0, 0);
			
			if (tmpDate.fullYear >= Global.startDate.fullYear)
			{
				if (tmpDate.month > Global.startDate.month)
				{
					return true;
				}
				else if (tmpDate.month == Global.startDate.month && tmpDate.date >= Global.startDate.date)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
		
		private function checkEndDate():Boolean
		{
			var tmpDate:Date = new Date((new Date()).getFullYear(), (new Date()).getMonth(), (new Date()).getDate(), 0, 0, 0, 0);
			
			if (tmpDate.fullYear <= Global.endDate.fullYear)
			{
				if (tmpDate.month < Global.endDate.month)
				{
					return true;
				}
				else if (tmpDate.month == Global.endDate.month && tmpDate.date <= Global.endDate.date)
				{
					return true;
				}
				else
				{	
					return false;
				}
			}
			else
			{
				return false;
			}
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