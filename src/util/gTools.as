package util
{
	import org.flixel.*;
	import flash.display.*;
	import org.flixel.plugin.photonstorm.FlxMath;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class gTools
	{
		// Returns a random number between min and max
		 
		public static function rnd(min:Number = 0, max:Number = 1):Number
		{
			//return FlxMath.rand(min, max, exlcudes);
			return Math.floor(Math.random() * (1 + max - min) + min);
		}
		
		// Returns whether or not two numbers have the same sign
		
		public static function sameSign(n1:Number, n2:Number):Boolean
		{
			var _sameSign:Boolean = false;
			if (n1 < 0 && n2 < 0) _sameSign = true;
			else if (n1 > 0 && n2 > 0) _sameSign = true;
			
			return _sameSign;
		}
		
		// Returns whether or not a string is Numeric.
		
		public static function isNumeric(string:String):Boolean
		{
			var testFlag:Boolean = true;

			if (isNaN(Number(string))) testFlag = false;
			else testFlag = true;
		
			return testFlag;
		}	
		
		// Checks whether or not game is hosted on testURL
		
		public static function checkSite(testURL:String):Boolean
		{
			var testFlag:Boolean = false;
			
			var url:String = FlxG.stage.loaderInfo.url;
			var urlStart:Number = url.indexOf("://")+3;
			var urlEnd:Number = url.indexOf("/", urlStart);
			var domain:String = url.substring(urlStart, urlEnd);
			var LastDot:Number = domain.lastIndexOf(".")-1;
			var domEnd:Number = domain.lastIndexOf(".", LastDot)+1;
			domain = domain.substring(domEnd, domain.length);
			
			if (domain == testURL) testFlag = true;
			return testFlag;
		}
		
		// Removes -
		
		public static function abs(n:Number):Number
		{
			if (n < 0) n *= -1;
			return n;
		}
		
		public static function pythagoras(c:Number, a:Number):int
		{
			return Math.sqrt(Math.pow(c, 2) - Math.pow(a, 2));
		}
		
		// Return class
		
		public static function getClass(obj:FlxObject):Class 
		{
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
	}
}