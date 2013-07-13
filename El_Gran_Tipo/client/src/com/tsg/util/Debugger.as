package com.tsg.util {
	
	import flash.display.MovieClip;
	
	
	public class Debugger extends MovieClip
	{
		public function Debugger()
		{
		}
		
		public function setText(txt:String)
		{
			this["txtDebug"].text = txt;
		}
		
		public function appendText(txt:String)
		{
			this["txtDebug"].text += txt;
		}
		
		public function println(txt:String)
		{
			this["txtDebug"].text += "\n"+txt;
		}
	}
}
