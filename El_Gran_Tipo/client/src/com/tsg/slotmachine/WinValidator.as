﻿package com.tsg.slotmachine 
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
			
			if (getDayToday() == 6)
			{
				if(n == 12)
				{
					half = true;
				}
				else
				{
					half = false;
				}
			}
			else
			{
				if(n == 17)
				{
					half = true;
				}
				else
				{
					half = false;
				}
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
		
		static public function getWinnerDays():Array 
		{
			var seed:int = Global.seed;
			
			// generar dias aleatorios solo para la cantidad de dias habiles
			var randomWinners:Array = MiBancoGenerator.getValues(Global.totDays, Global.iniStock);
			//trace(randomWinners);
			var totalNoBusinessDaysElapsed:int = getNoBusinessDaysElapsed(Global.startDate, Global.endDate);
			
			// repartir los premios entre los días habiles
			var i:int;
			var counter:int = 0;
			var winnerDays:Array = [];
			
			for (i = 0; i < totalNoBusinessDaysElapsed; i++)
			{
				var info:Object = { };
				info.day = Global.businessDays[i].day;
				info.isBusiness = Global.businessDays[i].isBusiness;
				
				if (Global.businessDays[i].isBusiness == 1)
				{
					info.prizes = randomWinners[counter];
					counter++;
				}
				else
				{
					info.prizes = 0;
				}
				
				winnerDays.push(info);
			}
			
			winnerDays.toString = function()
			{
				var str:String = "";
				var date:Date = new Date(Global.startDate.fullYear, Global.startDate.month, Global.startDate.date, 0, 0, 0, 0);
				
				for (var i:int = 0; i < winnerDays.length; i++)
				{
					date.setTime(date.getTime() + millisecondsPerDay);
					str = str + ("\n" + date + "\ndia: " + winnerDays[i].day + " - util: " + winnerDays[i].isBusiness + " - prizes: " + winnerDays[i].prizes + "\n");
				}
				
				return str;
			}
			
			trace(winnerDays);
			
			return winnerDays;
		}
		
		public static function isTimeToWin():Boolean 
		{
			Global.winnerDays = getWinnerDays();
			trace("s: " + Global.startDate);
			trace("e: "+Global.todayDate);
			var elapsedNoBusinessDays:int = getNoBusinessDaysElapsed(Global.startDate, Global.todayDate);
			var remainingPrizes:int = Global.iniStock - Global.stock;
			var i:int;
			var accumulated:int = 0;
			trace(">"+elapsedNoBusinessDays);
			for (i = 0; i <= elapsedNoBusinessDays; i++)
			{
				accumulated += Global.winnerDays[i].prizes;
			}
			
			Main.debugger.println("" + Global.winnerDays);
			
			Main.debugger.println("\nstock inicial: " + Global.iniStock);
			Main.debugger.println("stock actual : " + Global.stock);
			Main.debugger.println("premios acumulados : " + accumulated);
			
			
			if (accumulated > 0 && Global.iniStock - accumulated <= Global.stock)
			{
				// aun no se acaban los premios programados hasta hoy
				//var accumulatedPrizesForToday:int = (Global.stock - Global.iniStock + accumulated);
				
				//Main.debugger.println("premios acumulados hasta la fecha: " + accumulatedPrizesForToday);
				
				//---- esto se calcula con la ultima jugada del día 
				var initTime:Date = new Date(Global.lastWinDate.fullYear, Global.lastWinDate.month, Global.lastWinDate.date, Global.lastWinDate.hours, Global.lastWinDate.minutes, 0, 0);
				
				if (initTime.getTime() < new Date(Global.todayDate.fullYear, Global.todayDate.month, Global.todayDate.date, 9, 0, 0, 0).getTime())
				{
					initTime = new Date(Global.todayDate.fullYear, Global.todayDate.month, Global.todayDate.date, 9, 0, 0, 0);
				}
				
				var endTime:Date = new Date(Global.todayDate.fullYear, Global.todayDate.month, Global.todayDate.date, 18, 0, 0, 0);
				var lapse:int = (endTime.getTime() - initTime.getTime()) / (accumulated + 1);
				
				Main.debugger.println("\ninicio del rango:\t " + initTime);
				Main.debugger.println("fin del rango   :\t " + endTime);
				
				initTime.setTime(initTime.getTime() + lapse)
				
				Main.debugger.println("\nhora actual  :\t\t " + Global.todayDate);
				Main.debugger.println("hora ganadora:\t\t " + initTime);
				
				if (Global.todayDate.getTime() >= initTime.getTime())
				{
					Main.debugger.println("el jugador ganó.");
					return true;
				}
			}
			else
			{
				Main.debugger.println("Ya se agotaron los premios programados para hoy");
			}
			
			Main.debugger.println("el jugador no ganó.");
			return false;
		}
		
		static public function getBusinessDays(startDate:Date, endDate:Date):Array
		{
			var days:Array = [];
			
			var _startDate:Date = new Date(startDate.fullYear, startDate.month, startDate.date, 0, 0, 0, 0);
			var _endDate:Date = new Date(endDate.fullYear, endDate.month, endDate.date, 0, 0, 0, 0);
			
			while (_startDate < _endDate)
			{
				var info:Object = new Object();
				info.day = _startDate.day;
				info.isBusiness = (_startDate.day >= 1 && _startDate.day <= 6) ? 1 : 0;
				
				_startDate.setTime(_startDate.getTime() + millisecondsPerDay);
				
				days.push(info);
			}
			
			days.toString = function()
			{
				var str:String = "";
				
				for (var i:int = 0; i < days.length; i++)
				{
					str = str + ("dia: " + days[i].day + " - util: " + days[i].isBusiness + "\n");
				}
				
				return str;
			}
			
			return days;
		}
		
		static public function businessDaysElapsed(startDate:Date, endDate:Date):int 
		{
			var businessDays:Array = getBusinessDays(startDate, endDate);
			var count:int = 0;
			var i:int;
			
			for (i = 0; i < businessDays.length; i++)
			{
				if (businessDays[i].isBusiness == 1)
				{
					count++;
				}
			}
			
			return count;
		}
		
		static public function getNoBusinessDaysElapsed(startDate:Date, endDate:Date):int 
		{
			var _startDate:Date = new Date(startDate.fullYear, startDate.month, startDate.date, 0, 0, 0, 0);
			var _endDate:Date = new Date(endDate.fullYear, endDate.month, endDate.date, 0, 0, 0, 0);
			var count:int = 0;
			
			while (_startDate < _endDate)
			{
				count++;
				_startDate.setTime(_startDate.getTime() + millisecondsPerDay);
			}
			
			return count;
		}
	}
}