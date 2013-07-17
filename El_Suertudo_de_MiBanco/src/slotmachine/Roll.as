package slotmachine 
{
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setInterval;
	/**
	 * ...
	 * @author Jerson La Torre (jerson.latorre@gmail.com)
	 */
	
	public class Roll 
	{
		private static const ICON_HEIGHT:int = 124;
		private static const ROLL_POS_Y:int = 0;
		private static const NUM_ICONS:Number = 13;//5;
		
		private var _content:MovieClip;
		private var _id:int;
		private var _rollMotion:RollMotion;
		private var _prevRollSpeed:int = 0;
		private var _currentRollSpeed:int = 0;
		private var _callback:Function;
		private var _visibleItems:Array = [];
		
		public function Roll(id:int, content:MovieClip) 
		{
			_id = id;
			_content = content;
			
			var i:int;
			
			for (i = 1; i <= NUM_ICONS; i++)
			{
				var icon:MovieClip = _content["mcFicha_" + i];
				icon.y = ROLL_POS_Y + (i - 1) * ICON_HEIGHT;
			}
			
			visibleItems[0].gotoAndStop(WinValidator.values[_id * 3 + 0]);
			visibleItems[1].gotoAndStop(WinValidator.values[_id * 3 + 1]);
			visibleItems[2].gotoAndStop(WinValidator.values[_id * 3 + 2]);
		}
		
		public function spin(delay:Number, callback:Function = null):void
		{
			_callback = callback;
			TweenLite.delayedCall(delay, delayedSpin);
		}
		
		private function delayedSpin():void 
		{
			_rollMotion = new RollMotion(300, 10, 3000, 50, 200, 30, onEndSustainMotion, onEndRollMotion);
			_content.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEndSustainMotion():void 
		{
			var i:int;
			
			for (i = 1; i <= NUM_ICONS; i++)
			{
				var icon:MovieClip = _content["mcFicha_" + i];
				icon.y = ICON_HEIGHT * Math.round(icon.y / ICON_HEIGHT) + 32;
			}
			
			visibleItems[0].gotoAndStop(WinValidator.values[_id * 3 + 0]);
			visibleItems[1].gotoAndStop(WinValidator.values[_id * 3 + 1]);
			visibleItems[2].gotoAndStop(WinValidator.values[_id * 3 + 2]);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (_rollMotion.isPaused) return;
			
			_rollMotion.update();
			_prevRollSpeed = _currentRollSpeed;
			_currentRollSpeed = _rollMotion.getValue();
			
			var i:int;
			
			for (i = 1; i <= NUM_ICONS; i++)
			{
				var icon:MovieClip = _content["mcFicha_" + i];
				icon.y += _rollMotion.getValue();
				
				if (icon.y >= ROLL_POS_Y + ICON_HEIGHT * (NUM_ICONS - 1))
				{
					icon.y -= NUM_ICONS * ICON_HEIGHT;
					icon.gotoAndStop(Math.floor(Math.random() * 9) + 1);	
				}
			}
		}
		
		private function onEndRollMotion():void 
		{
			if (_callback != null)
			{
				_content.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_callback();
			}
		}
		
		public function get visibleItems():Array 
		{
			var i:int;
			_visibleItems = new Array(3);
			
			for (i = 1; i <= NUM_ICONS; i++)
			{
				var icon:MovieClip = _content["mcFicha_" + i];
				var index:int = Math.floor((icon.y - ROLL_POS_Y) / ICON_HEIGHT);
				
				if (index == 0) _visibleItems[0] = icon;
				if (index == 1) _visibleItems[1] = icon;
				if (index == 2) _visibleItems[2] = icon;
			}
			
			return _visibleItems;
		}
	}
}