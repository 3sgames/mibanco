package com.tsg.slotmachine
{
	/**
	 * ...
	 * @author wara
	 */
	
	public class MiBancoGenerator 
	{
		static private var average:Number;
		static private var values:Array;
		
		public function MiBancoGenerator() 
		{
			
		}
		
		static public function getValues(nDays:int, nPrizes:int):Array
		{
			// average
			average = (nDays / (nPrizes + 1));
			
			// create array of selected values
			values = new Array();
			
			var counter:Number = 0;
			var i:int;
			for (i = 0; i < nPrizes; i++)
			{
				counter += average;
				values.push(counter);
			}
			
			for (i = 0; i < nPrizes; i++)
			{
				var random:Number = (-average / 2) + getRandomValue(100) * average;
				values[i] += random;
				values[i] = int(values[i]);
			}
			
			// create the final array with incidences
			var incidences:Array = new Array(nDays);
			
			for (i = 0; i < incidences.length; i++)
			{
				incidences[i] = 0;
			}
			
			for (i = 0; i < values.length; i++)
			{
				incidences[values[i]]++;
			}
			
			return incidences;
		}
		
		static public function getRandomValue(seed:int):Number
		{
			var m:uint = seed + 200;
			var n:uint = (1372383749 * m + 1289706101) & 4294967295;
			
			n = n % 100;
			
			return (n / 100);
		}
	}
}