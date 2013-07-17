package slotmachine 
{
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	import com.adobe.serialization.json.JSON;
	
	
	public class WinValidator 
	{
		
		private static var _isTimeToWin:Boolean;
		public static var values:Array;
		private var resultado:String;
		
		public function WinValidator() 
		{
		}
		
		static public function getDayToday():int{
			var today_date:Date = new Date();
			return today_date.getDay();
		}
		
		static public function getRandomHourToday():int
		{
			var mod:uint = 4;
			var mod0:uint = 7;
			var ran:int = Math.floor(Math.random() * 12);
			
			//trace(">"+getDayToday());
			if(getDayToday() == 6){
				mod = 2;
				mod0 = 8;
			}
			
			var date:uint = (new Date()).getDate() + 100;
			var n:uint = (1372383749 * date + 1289706101) & 4294967295;
			n = n % mod + mod0;//+ 8;//n % 11 + 8;
			/*if(ran < 0.3){
				if(n <= 4)
					mod = 8;
				else if(n > 4)
					mod = 4;
			}
			else if(ran < 1){
				if(n <= 4)
					mod = 13;
				else if(n > 4)
					mod = 8;
			}*/
			n += mod;
			
			//trace("random hour: ", n);
			
			
			return n;
			
		}
		
		static public function getRandomMinuteToday():int
		{
			var date:uint = (new Date()).getDate() + 200;
			var n:uint = (1372383749 * date + 1289706101) & 4294967295;
			var mod:int = 60;
			if(getRandomHourToday() >= 17)
				mod = 30;
			n = n % mod;//60;
			//trace("random minute: ", n);
			return n;
		}
		
		static public function setInitValues():void
		{
			values = getRandomValues();
		}
		
		static public function setFinalValues():void 
		{
			values = getRandomValues();
			
			if (isTimeToWin())
			{	
				values[1] = 1;
				values[4] = 1;
				values[7] = 1;
			}
		}
		
		static private function getRandomValues():Array
		{
			values = [2, 3, 4, 5, 6, 7, 8, 9, 0];
			values[8] =  Math.floor(Math.random() * 7) + 2;
			
			values.sort(function shuffle(a:Object,b:Object):Number {
				return Math.floor(Math.random() * 3) - 1;
			});
				
			return values;
		}	
		
		public static function isTimeToWin():Boolean 
		{
			//if (!isWinAvailable()) return false;
			/*
			var hour:int = new Date().getHours();
			var minutes:int = new Date().getMinutes();
			trace(hour, minutes);
			trace(getRandomHourToday()+":"+getRandomMinuteToday());
			
			if (hour > getRandomHourToday() || (hour == getRandomHourToday() && minutes >= getRandomMinuteToday()))
			{
				trace("won");
				return true;
			}
			
			return false;*/
			return Global.timeToWin;
		}
		
		static public function saveWin():void 
		{
			
			
			
			// aquí se guardaría un flag para indicar que ya alguien ganó el premio
			
			// se debería hacer el lock respectivo en la base de datoe mientras se está guardando
			// para evitar que dos personas ganen el premio al mismo tiempo
		}
		
		
		
		static private function isWinAvailable():void 
		{
			
			// aquí iría la verificación con la base de datos de ellos para ver si es que ya nadie ganó en el día
		}
	}
}