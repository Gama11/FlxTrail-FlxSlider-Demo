package 
{
	import org.flixel.*;
	import org.flixel.system.*;

	[SWF(width="800", height="500", backgroundColor="#FFFFFF")]
    [Frame(factoryClass = "Preloader")]
	
	public class Main extends FlxGame 
	{
		public function Main():void
		{
			super(800, 500, GameState, 1, 60, 60);
		}
	}
}