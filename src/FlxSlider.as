package 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;
	import org.flixel.plugin.photonstorm.FlxMouseControl;
	
	/**
	 *
	 * A simple slider object for Flixel - v 0.2
	 * 
	 * @author Gama11
	 */
	
	public class FlxSlider extends FlxGroup 
	{	
		/**
		 *  The dragable handle - loadGraphic() to change its graphic.
		 */
		public var handle:FlxExtendedSprite;
		/**
		 *  The dragable area for the handle. Is configured automatically.
		 */
		private var bounds:FlxRect;
		/**
		 *  The horizontal line in the background.
		 */
		public var line:FlxSprite;
		/**
		 *  The left border sprite.
		 */
		public var leftBorder:FlxSprite;
		/**
		 *  The right border sprite.
		 */
		public var rightBorder:FlxSprite;
		/**
		 *  The text under the left border - equals minValue by default.
		 */
		public var minLabel:FlxText;
		/**
		 *  The text under the right border - equals maxValue by default.
		 */
		public var maxLabel:FlxText;
		/**
		 *  A text above the slider that displays its name.
		 */
		public var nameLabel:FlxText;
		/**
		 *  A text under the slider that displays the current value.
		 */
		public var currentLabel:FlxText;
		
		/**
		 *  The width of the slider.
		 */
		public var width:int = 100;
		/**
		 *  The height of the slider - make sure to call createSlider() if you 
		 *  want to change this.
		 */
		public var height:int = 8;
		/**
		 *  The thickness of the slider - make sure to call createSlider() if you 
		 *  want to change this.
		 */
		public var thickness:int = 2;
		/**
		 *  The color of the slider - make sure to call createSlider() if you 
		 *  want to change this.
		 */
		public var color:uint = 0xFF000000;
		/**
		 *  The color of the handle - make sure to call createSlider() if you 
		 *  want to change this.
		 */
		public var handleColor:uint = 0xFF828282;;
		/**
		 *  Current x pos.
		 */
		public var xCoord:int = 0;
		/**
		 *  Current y pos.
		 */
		public var yCoord:int = 0;
		/**
		 *  Stores a reference to parent object.
		 */
		private var obj:Object;
		/**
		 *  (Optional) Function to be called when slider was dragged / value changed.
		 *  Two parameters are passed:
		 *  The value the var is supossed to have (Number) and
		 *  The currentLabel (FlxText) - needs to be updated manually in that case.
		*/
		public var callback:Function;
		/**
		 *  Stores the variable the slider controls.
		 */
		public var varString:String;
		/**
		 *  Stores the value of the variable - updated each frame.
		 */
		public var value:Number;
		/**
		 * Mininum value the variable can be changed to.
		 */
		public var minValue:Number;
		/**
		 * Maximum value the variable can be changed to.
		 */
		public var maxValue:Number;
		/**
		 * The handle's position relative to the slider's width.
		 */
		public var relHandlePos:Number;
		/**
		 * How many decimals the variable can have at max. Default is zero,
		 * or "only whole numbers".
		 */
		public var decimals:int = 0;
		/**
		 * Whether this class should handle the changes to the specified var 
		 * or if you wanna do that yourself / not at all. Automatically set to 
		 * false if you specify a Callback function. 
		 */
		public var overwriting:Boolean = true;
		/**
		 * Sound that's played whenever the slider is clicked.
		 */
		public var clickSound:Class;
		/**
		 * Sound that's played whenever the slider is hovered over.
		 */
		public var hoverSound:Class;
		/**
		 * Helper variable to avoid the clickSound playing every frame.
		 */
		private var justClicked:Boolean = false;
		/**
		 * Helper variable to avoid the hoverSound playing every frame.
		 */
		private var justHovered:Boolean = false;
		
		/**
		 * Creates a new <code>FlxSlider</code>.
		 * 
		 * @param	X			X Position
		 * @param	Y			Y Position
		 * @param	MinValue	Mininum value the variable can be changed to.
		 * @param	MaxValue	Maximum value the variable can be changed to.
		 * @param	Callback	Function to be called when slider was dragged / value changed.
		 * @param	VarString	Variable that the slider controls - NEEDS TO BE PUBLIC! Not needed if Callback is used.
		 * @param	Obj      	Reference to the object the variable belongs to. Not needed if Callback is used.
		 * @param	Width		Width of the slider.
		 */
		override public function FlxSlider(X:int = 0, Y:int = 0, MinValue:Number = 0, MaxValue:Number = 10, Callback:Function = null, VarString:String = null, Obj:Object = null, Width:int = 100):void
		{
			// Assign all those constructor vars
			xCoord = X;
			yCoord = Y;
			minValue = MinValue;
			maxValue = MaxValue;
			varString = VarString;
			obj = Obj;
			width = Width;
			callback = Callback;
			if (Callback != null) overwriting = false;
			if (Obj[VarString] != Math.round(Obj[VarString])) decimals = 2;
			
			// Create the slider	
			createSlider();
		}		
		
		/**
		 * Initially creates the slider with all its objects. Can also be 
		 * called to redraw the thing if certain vars are changed manually later.
		 */
		public function createSlider():void
		{				
			// Need that to make use of the FlxPowerTools' dragable sprite feature
			if (FlxG.getPlugin(FlxMouseControl) == null) FlxG.addPlugin(new FlxMouseControl);
			
			// Creating the "body" of the slider
			line = new FlxSprite(0, 0);
			line.makeGraphic(width + thickness * 3, thickness, color);
			
			var yPos:int = - height / 2 + thickness / 2;
			leftBorder = new FlxSprite(0 - thickness, yPos);
			leftBorder.makeGraphic(thickness, height, color);
			rightBorder = new FlxSprite(width + thickness * 2, yPos);
			rightBorder.makeGraphic(thickness, height, color);
			
			// Creating the texts
			var textOffset:int = 3;
			
			minLabel = new FlxText(2 - thickness * 2, (height / 2) + textOffset, 100, minValue.toString()); 
			minLabel.setFormat(null, 12, FlxG.BLACK, "left");
			maxLabel = new FlxText(width, (height / 2) + textOffset, 100, maxValue.toString());
			maxLabel.setFormat(null, 12, FlxG.BLACK, "left");
			
			nameLabel = new FlxText(0, - height * 3, width, varString); 
			nameLabel.setFormat(null, 16, FlxG.BLACK, "center");
			
			currentLabel = new FlxText(0, (height / 2) + textOffset, width, ""); 
			currentLabel.setFormat(null, 12, handleColor, "center");
			if (obj != null && varString != null) currentLabel.text = (obj[varString]).toString();
			
			// Creating the handle
			if (obj != null && varString != null) value = obj[varString];
			
			bounds = new FlxRect(xCoord, 0, width + thickness * 2, FlxG.height);
			
			handle = new FlxExtendedSprite(0, yPos);
			handle.makeGraphic(thickness * 2, height, handleColor);
			handle.enableMouseDrag(false, false, 255, bounds);
			handle.setDragLock(true, false);
		
			if (obj != null && varString != null) handle.x = (value / maxValue) * width;
			
			// Add all the objects
			add(line);
			add(leftBorder);
			add(rightBorder);
			add(minLabel);
			add(maxLabel);
			add(nameLabel);
			add(currentLabel);
			add(handle);
			
			// Position the objects
			x = xCoord;
			y = yCoord;
			
			// Fire Callback just once so that a text for currentLabel can be set
			relHandlePos = (handle.x - xCoord) / width;
			if (callback != null) callback(round(relHandlePos * maxValue), currentLabel);
		}
		
		override public function update():void
		{
			// Update the variable's value
			if (callback == null) currentLabel.text = (round(obj[varString])).toString();
			
			// Update the var that stores the handle position relative to the slider's width
			relHandlePos = (handle.x - xCoord) / width;
			// ...and change the variable's value if the handle has been dragged
			if (value != relHandlePos * maxValue) {
				if (overwriting) obj[varString] = round(relHandlePos * maxValue);
				if (callback != null) callback(round(relHandlePos * maxValue), currentLabel);
				
				value = relHandlePos * maxValue;
			}
			
			// Make it possible to click anywhere on the slider 
			
			var xM:int = FlxG.mouse.x;
			var yM:int = FlxG.mouse.y;
				
			if (xM >= xCoord && xM <= xCoord + width && yM >= (yCoord) && yM <= (yCoord + height * 2) && visible) {
				
				if (FlxG.mouse.pressed()) {
					handle.x = FlxG.mouse.x;
					if (!justClicked && clickSound != null) {
						FlxG.play(clickSound);
						justClicked = true;
					}
				}
				else {
					justClicked = false;
				}
				alpha = 0.5;
				if (!justHovered && hoverSound != null) FlxG.play(hoverSound);
				justHovered = true;
			}
			else if (visible) {
				alpha = 1;
				justHovered = false;
			}
			
			super.update();
		}
		
		/**
		 * Handy function for changing the textfields.
		 * 
		 * @param	Name	Name of the slider - "" to hide
		 * @param	Current	Whether to show the current value or not
		 * @param	Left	Label for the left border text - "" to hide
		 * @param	Right	Label for the right border text - "" to hide
		 */
		public function setTexts(Name:String, Current:Boolean = true, Left:String = null, Right:String = null):void
		{
			if (Left == "") minLabel.visible = false;
			else if (Left != null) {
				minLabel.text = Left;
				minLabel.visible = true;
			}
			
			if (Right == "") maxLabel.visible = false;
			else if (Right != null) {
				maxLabel.text = Right;
				maxLabel.visible = true;
			}
			
			if (Name == "") nameLabel.visible = false;
			else if (Name != null) {
				nameLabel.text = Name;
				nameLabel.visible = true;
			}
			
			if (!Current) currentLabel.visible = false;
			else currentLabel.visible = true;
		}
		
		/**
		 * Handy function to round a number to set amount of decimals.
		 * 
		 * @param	n	Number to round
		 */
		private function round(n:Number):Number
		{
			decimals = Math.abs(decimals);

			return int((n) * Math.pow(10, decimals)) / Math.pow(10, decimals);
		}
		
		/**
		 * Need that to make use of the FlxPowerTools' dragable sprite feature as well.
		 */
		override public function destroy():void
		{
			//	Important! Clear out the plugin otherwise resources will get messed right up after a while
			FlxMouseControl.clear();

			super.destroy();
		}
		
		// Code that makes sure this class has alpha, x and y properties just like a FlxSprite would.
		
		private var _alpha:Number = 1;
		
		public function set alpha(n:Number):void 
		{
			_alpha = n;
			if (_alpha > 1) _alpha = 1;
			else if (_alpha < 0) _alpha = 0;
			
			for each (var m:* in members) {
				m.alpha = _alpha;
			}
		}
		
		public function get alpha():Number { return _alpha }
			
		private var _x:int = 0
		private var _y:int = 0
		
		public function set x(nx:int):void
		{
			var offset:int = nx - _x;
			
			for each (var object:* in members) {
				object.x += offset;
			}
			
			_x = nx;
		}
		
		public function get x():int {return _x}
		
		public function set y(ny:int):void
		{
			var offset:int = ny - _y;
			
			for each (var object:* in members) {
				object.y += offset;
			}
			
			_y = ny;
		}
		
		public function get y():int { return _y }
	}
}