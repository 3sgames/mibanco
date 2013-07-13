package com.tsg.slotmachine
{
	/**
	 * ...
	 * @author Jerson La Torre (jerson.latorre@gmail.com)
	 */
	
	public class RollMotion 
	{
		private var _value:int;
		private var _valuePaused:int;
		private var _t:Number;
		private var _dt:Number;
		
		private var _inD:int;
		private var _inA:int;
		private var _susD:int;
		private var _susA:int;
		private var _outD:int;
		private var _outA:int;
		private var _callback:Function;
		private var _callbackSustain:Function;
		
		private var _totalTime:int;
		private var _isPaused:Boolean;
		private var _isSustainEnd:Boolean;
		
		public function RollMotion
		(
			inDuration:int,
			inAmplitude:int,
			sustainDuration:int,
			sustainAmplitude:int,
			outDuration:int,
			outAmplitude:int,
			callbackSustain:Function,
			callback:Function
		)
		{
			_inD = inDuration;
			_inA = inAmplitude;
			_susD = sustainDuration;
			_susA = sustainAmplitude;
			_outD = outDuration;
			_outA = outAmplitude;
			_callbackSustain = callbackSustain
			_callback = callback;
			
			_t = 0;
			_totalTime = _inD + _susD + _outD;
			_dt = 33 / (_totalTime);
			//_isPaused = true;
		}
		
		public function getValue():int
		{
			return _value;
		}
		
		public function update():void
		{
			//trace("L0", _t, _dt);
			if (_isPaused) return;
			
			_t = _t + _dt;
			//trace("L1", _t, _dt);
			
			if (_t < _inD / _totalTime)
			{
				_value = int(-_inA * Math.sin(_t * 3.14 / (_inD / _totalTime)));
			}
			else if (_t >= _inD / _totalTime && _t < (_inD + _susD) / _totalTime)
			{
				//trace("L2");
				_value = int(_susA);
			}
			else if (_t >= (_inD + _susD) / _totalTime && _t <= 1)
			{
				//trace("L3");
				if (!_isSustainEnd)
				{
					_isSustainEnd = true;
					_callbackSustain();
				}
				
				_value = int(-_inA * Math.sin((_t - (_inD + _susD) / _totalTime) * 3.14 / (_outD / _totalTime)));
			}
			else 
			{
				//
			}
			
			if (_t >= 1)
			{
				//trace("L4");
				_t = 1;
				_value = 0;
				_isPaused = true;
				_callback();
			}
		}
		
		public function setPause(value:Boolean):void 
		{
			if (_t == 1) return;
			
			_isPaused = value;
			
			if (_isPaused)
			{
				_value = _valuePaused;
			}
			else
			{
				_valuePaused = _value;
				_value = 0;
			}
			
			//trace("paused to:", value, "in time:", _value);
		}
		
		public function get isPaused():Boolean 
		{
			return _isPaused;
		}
	}
}