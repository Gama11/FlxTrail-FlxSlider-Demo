package 
{
	import org.flixel.*;
	
	/**
	 * Nothing too fancy, just a handy little class to attach a trail effect to a FlxSprite.
	 * Inspired by the way "Buck" from the inofficial #flixel IRC channel 
	 * creates a trail effect for the character in his game.
	 * Feel free to use this class and adjust it to your needs.
	 * 
	 * @author Gama11
	 */
	public class FlxTrail extends FlxGroup 
	{		
		/**
		 *  Stores the FlxSprite the trail is attached to.
		 */
		public var sprite:FlxSprite;
		/**
		 *  How often to update the trail.
		 */
		public var delay:int;
		/**
		 *  Whether to check for X changes or not.
		 */
		public var xEnabled:Boolean = true;
		/**
		 *  Whether to check for Y changes or not.
		 */
		public var yEnabled:Boolean = true;
		/**
		 *  Whether to check for angle changes or not.
		 */
		public var rotationsEnabled:Boolean = true;
		/**
		 *  Counts the frames passed.
		 */
		private var counter:int;
		/**
		 *  How long is the trail?
		 */
		private var trailLength:int;
		/**
		 *  Stores the trailsprite image.
		 */
		private var image:Class;
		/**
		 *  The alpha value for the next trailsprite.
		 */
		private var transp:Number = 1;
		/**
		 *  How much lower the alpha value of the next trailsprite is.
		 */
		public var difference:Number;
		/**
		 *  Stores the sprites recent positions.
		 */
		private var recentPositions:Array = [];
		/**
		 *  Stores the sprites recent angles.
		 */
		private var recentAngles:Array = [];

		/**
		 * Creates a new <code>FlxTrail</code> effect for a specific FlxSprite.
		 * 
		 * @param	Sprite		The FlxSprite the trail is attached to.
		 * @param	Image		The image to ues for the trailsprites.
		 * @param	Length		The amount of trailsprites to create. 
		 * @param	Delay		How often to update the trail.
		 * @param	Alpha		The alpha value for the very first trailsprite.
		 * @param	Diff		How much lower the alpha of the next trailsprite is.
		 */
		override public function FlxTrail(Sprite:FlxSprite, Image:Class, Length:int = 10, Delay:int = 3, Alpha:Number = 0.4, Diff:Number = 0.05):void
		{
			// Sync the vars 
			sprite = Sprite;
			delay = Delay;
			image = Image;
			transp = Alpha;
			difference = Diff;
			
			// Create the initial trailsprites
			increaseLength(Length);
		}		
		
		/**
		 * Updates positions and other values according to the delay that has been set.
		 * 
		 */
		override public function update():void
		{
			// Count the frames
			counter++;
			
			// Update the trail in case the intervall and there actually is one.
			if (counter >= delay && trailLength >= 1)
			{
				counter = 0;
				
				// Push the current position into the positons array and drop one.
				var spritePosition:FlxPoint = new FlxPoint(sprite.x, sprite.y);
				spritePosition.x -= ((members[0].frameWidth - sprite.width) / 2);
				spritePosition.y -= ((members[0].frameHeight - sprite.height) / 2);
				recentPositions.unshift(spritePosition);
				
				if (recentPositions.length > trailLength) recentPositions.pop();
	
				// Also do the same thing for the Sprites angle if rotationsEnabled 
				if (rotationsEnabled) 
				{
					var spriteAngle:Number = sprite.angle;
					recentAngles.unshift(spriteAngle);
					if (recentAngles.length > trailLength) recentAngles.pop();
				}
		
				// Now we need to update the all the Trailsprites' values
				for (var i:int = 0; i < recentPositions.length; i++) 
				{
					members[i].x = recentPositions[i].x;
					members[i].y = recentPositions[i].y;
					// And the angle...
					if (rotationsEnabled) members[i].angle = recentAngles[i];
					// Is the trailsprite even visible?
					if (!members[i].visible) members[i].visible = true; 
				}
			}
			
			super.update();
		}
		
		/**
		 * A function to add a specific number of sprites to the trail to increase its length.
		 *
		 * @param 	amount	The amount of sprites to add to the trail.
		 */
		public function increaseLength(amount:int):void
		{
			// Can't create less than 1 sprite obviously
			if (amount <= 0) return;
			
			trailLength += amount;

			// Create the trail sprites
			for (var i:int = 0; i < amount; i++) {
				var trailSprite:FlxSprite = new FlxSprite(0, 0, image);
				add(trailSprite);
				trailSprite.alpha = transp;
				transp -= difference;
				
				if (trailSprite.alpha <= 0) trailSprite.kill();
			}	
		}
		
		/**
		 * Simple helper function that resets the trail.
		 */
		public function resetTrail():void
		{
			recentPositions = [];
			recentAngles = [];
			for each (var i:* in members) {
				(i as FlxSprite).visible = false;
			}
		}
		
		/**
		 * In case you want to change the trailsprite image in runtime...
		 *
		 * @param 	Image	The image the sprites should load
		 */
		public function changeGraphic(Image:Class):void
		{
			image = Image;
			
			for (var i:int = 0; i < trailLength; i++) {
				members[i].loadGraphic(Image);
			}	
		}
		
		/**
		 * Handy little function to change which events affect the trail.
		 *
		 * @param 	Angle 	Whether the trail reacts to angle changes or not.
		 * @param 	X 		Whether the trail reacts to x changes or not.
		 * @param 	Y 		Whether the trail reacts to y changes or not.
		 */
		public function changeValuesEnabled(Angle:Boolean, X:Boolean = true, Y:Boolean = true):void
		{
			rotationsEnabled = Angle;
			xEnabled = X;
			yEnabled = Y;
		}
	}
}