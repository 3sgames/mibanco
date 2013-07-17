package slotmachine 
{
	import com.gloop.Game;
	import flash.display.Stage;
	
	public class Global 
	{
		public static var stage:Stage;
		public static var game:SlotMachineGame;
		public static var stageWidth:int = 800;
		public static var stageHeight:int = 600;
		
		public static var bt_age_cod:String = "";
		public static var bt_cli_acc:String = "";
		public static var bt_tit_nam:String = "";
		public static var bt_acc_typ:String = "";
		public static var bt_user_dni:String = "";
		public static var bt_user_sex:String = "";
		public static var bt_ope_dat:String = "";
		public static var bt_fir_dep_dat:String = "";
		//public static var bt_game_dat:String = "";
		public static var bt_dep_curr:String = "";
		public static var bt_fir_dep_amo:String = "";
		public static var bt_mac_user:String = "";
		//public static var bt_winner:String = "";
		//public static var bt_prize:String = "";
		
		public static var winner_comb:Array;
		
		
		public static var timeToWin:Boolean = new Boolean();
		
		public function Global() 
		{
			
		}
		
		public static function flush() 
		{
			bt_age_cod = "";
			bt_cli_acc = "";
			bt_tit_nam = "";
			bt_acc_typ = "";
			bt_user_dni = "";
			bt_user_sex = "";
			bt_ope_dat = "";
			bt_fir_dep_dat = "";
			//bt_game_dat = "";
			bt_dep_curr = "";
			bt_fir_dep_amo = "";
			bt_mac_user = "";
			//bt_winner = "";
			//bt_prize = "";
		}
		
	}

}