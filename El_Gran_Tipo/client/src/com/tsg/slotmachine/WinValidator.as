package com.tsg.slotmachine 
{
	public class WinValidator 
	{
		private static const millisecondsPerDay:int = 1000 * 60 * 60 * 24;

		private static var _isTimeToWin:Boolean;
		public static var values:Array;
		private var resultado:String;
		
		private static var half:Boolean = false;
		
		public function WinValidator() 
		{
		}
		
		static public function getDayToday():int{
			var today_date:Date = Global.todayDate;
			return today_date.getDay();
		}
		
		static public function getRandomHourToday():int
		{
			var mod:uint;// = 8;
			var mod0:uint = 10;
			var ran:Number = 0.3;//Math.random();
			
			//trace(">"+getDayToday());
			//if(getDayToday() == 6)
			//	mod = 5;
			var date:uint = (Global.todayDate).getDate() + 100;
			var n:uint = (1372383749 * date + 1289706101) & 4294967295;
			n = n % mod0;//+ 8;//n % 11 + 8;
			trace("random hour: ", n);
			/*if(ran <= 0.2){
				if(getDayToday() == 6){
					if(n < 4)
						mod = 8;
					else if(n == 4)
						mod = 4;
				}
				else{
					if(n < 8)
						mod = 8;
					else if(n >= 8)
						mod = 5;
				}
			}
			else {*/
				if(getDayToday() == 6){
					if(n < 3)
						mod = 10;
					else if(n >= 3){
						n %= 3;
						mod = 10;
					}
				}
				else{
					if(n < 8){
						n %= 3;
						mod = 15;
					}else if(n >= 8)
						mod = 8;
				}
			//}
			n += mod;
			
			//trace("random hour mod: ", n,ran);
			
			if(getDayToday() == 6){
				if(n == 12)
					half = true;
				else
					half = false;
			}else{
				if(n == 17)
					half = true;
				else
					half = false;
			}
			return n;
			
		}
		
		static public function getRandomMinuteToday():int
		{
			var date:uint = (Global.todayDate).getDate() + 200;
			var n:uint = (1372383749 * date + 1289706101) & 4294967295;
			var mod:int = 60;
			if(half)
				mod = 30;
			n = n % mod;//60;
			//trace("random minute: ", n);
			return n;
		}
		
		static public function getTimeMillis():Number
		{
			var hours:Number = getRandomHourToday();
			var mins:Number = getRandomMinuteToday();
			var returnDate:Date = new Date(Global.todayDate.fullYear,Global.todayDate.month,Global.todayDate.date,hours,mins,0,0);
			
			return returnDate.time;
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
			
			values.sort(function shuffle(a:Object, b:Object):Number {
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
		
		static public function getBusinessDays(startDate:Date,endDate:Date):Array
		{
			var days:Array = [];
			trace(startDate, endDate);
			
			while (startDate < endDate)
			{
				var info:Object = new Object();
				info.day = startDate.day;
				info.isBusiness = (startDate.day >= 1 && startDate.day <= 6) ? 1 : 0;
				
				//increment day by day
				startDate.setTime(startDate.getTime() + millisecondsPerDay);
				
				days.push(info);
			}
			
			days.toString = function() {
				var str:String = "";
				
				for (var i:int = 0; i < days.length; i++)
				{
					str = str + ("dia: " + days[i].day + " - util: " + days[i].isBusiness + "\n");
				}
				
				return str;
			}
			
			return days;
		}
		
		static public function businessDaysElapsed(startDate:Date,endDate:Date):int 
		{
			var numberOfDays:int = 0;
			
			while(startDate < endDate){
				//increment day by day
				startDate.setTime(startDate.getTime() + millisecondsPerDay);
				//if day is between monday and saturday, add one day
				if(startDate.day >= 1 && startDate.day <= 6)
					numberOfDays++;
			}
			return numberOfDays;
		}
	}
}