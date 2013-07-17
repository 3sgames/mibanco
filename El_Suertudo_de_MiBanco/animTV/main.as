package  {
	
	import flash.display.MovieClip;
	
	
	public class main extends MovieClip {
		
		
		public function main() {
			var msg:String = root.loaderInfo.parameters.Trama as String;

			this["txtAgencia"].text = msg;
		}
	}
	
}
