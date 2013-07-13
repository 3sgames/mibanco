package com.tsg.slotmachine 
{
	import com.gloop.Game;
	import flash.display.Stage;
	
	public class Global 
	{
		public static var stage:Stage;
		public static var stageWidth:int = 800;
		public static var stageHeight:int = 600;
		
		public static var codSuc:String = "";
		public static var codMod:String = "";
		public static var codTrans:String = "";
		public static var codRel:String = "";
		public static var amountInput:String = "";
		
		public static var category:String = "";
		
		public static var tipoDoc:String = "";
		public static var numDoc:String = "";
		public static var nomCli:String = "";
		public static var nomAge:String = "";
		public static var req:String = "";
		public static var codRet:String = "";
		public static var msgErr:String = "";
		
		public static var prize:String = "";
		
		public static var startDate:Date;//= new Date(2013,05,23,0,0,0,0);
		public static var endDate:Date;//= new Date(2013,07,23,0,0,0,0);
		public static var todayDate:Date ;//= new Date();
		
		public static var totDays:Number = -1;
		public static var elapsedDays:Number = -1;
		public static var remainingDays:Number = -1;
		public static var ratio:Number = -1;
		
		public static var businessDays:Array = [];
		
		public static var URLfile:String = "http://192.168.1.202:8080/GranTipo/post_noWSDL.jsp";
		
		public static var timeToWin:Boolean = new Boolean();
		
		public function Global() 
		{
			
		}
		
		public static function flush() 
		{
			codSuc = "";
			codMod = "";
			codTrans = "";
			codRel = "";
			amountInput = "";
			
			category = "";
			
			tipoDoc = "";
			numDoc = "";
			nomCli = "";
			nomAge = "";
			req = "";
			codRet = "";
			msgErr = "";
			
			prize = "";
			startDate = null;
			endDate = null;
			todayDate = null;
		
			totDays = -1;
			elapsedDays = -1;
			remainingDays = -1;
			ratio = -1;
		}
	}
}