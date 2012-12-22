package 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import flash.desktop.*;
	
	public class GameState extends FlxState 
	{
		private var ball:FlxSprite;
		private var borders:FlxGroup;
		private var ballTrail:FlxTrail;
		private var gY:int = 80;
		
		// These NEED to be public so FlxSlider.as can access them
		public var ballRotation:int = 3;
		public var Length:int = 10;
		public var Alpha:Number = 0.4; 
		public var alphaDec:Number = 0.05;
		public var Delay:int = 2;
		
		private const SQUARE:int = 0;
		private const RECTANGLE:int = 1;
		private const CIRCLE:int = 2;
		private const TRIANGLE:int = 3;
		
		public var shape:int = 0;
	
		[Embed(source = "../img/square.png")] private var square:Class;
		[Embed(source = "../img/rectangle.png")] private var rectangle:Class;
		[Embed(source = "../img/circle.png")] private var circle:Class;
		[Embed(source = "../img/triangle.png")] private var triangle:Class;
		
		[Embed(source = "../sfx/Hover.mp3")] private var HoverSound:Class;
		
		private var IMAGES:Array;
		private var NAMES:Array = ["Square", "Rectangle", "Circle", "Triangle"];
			
		override public function create():void
		{
			FlxG.mouse.show();
			
			IMAGES = [square, rectangle, circle, triangle];
			
			var background:FlxSprite = new FlxSprite(0, 0);
			background.makeGraphic(FlxG.width, FlxG.height);
			add(background);
			
			var ballSpeed:int = 400;
			ball = new FlxSprite(FlxG.width / 2 + 100 - 300, FlxG.height / 2, square);
			ball.elasticity = 1;
			ball.velocity.y = ballSpeed - 200;
			ball.velocity.x = ballSpeed - 100;
			add(ball);

			ballTrail = new FlxTrail(ball, square, Length, Delay, Alpha, alphaDec);
			add(ballTrail);
			
			// Borders
			var borderColor:uint = 0xFF000000;
			var borderSize:int = 20;
			var guiSize:int = 300;
			
			var border1:FlxSprite = new FlxSprite(0, 0);
			border1.makeGraphic(FlxG.width - guiSize, borderSize, borderColor);
			border1.immovable = true;
			var border2:FlxSprite = new FlxSprite(0, FlxG.height - borderSize);
			border2.makeGraphic(FlxG.width - guiSize, borderSize, borderColor);
			border2.immovable = true;
			
			var border3:FlxSprite = new FlxSprite(0, 0);
			border3.makeGraphic(borderSize, FlxG.height, borderColor);
			border3.immovable = true;
			var border4:FlxSprite = new FlxSprite(FlxG.width - borderSize - guiSize, 0);
			border4.makeGraphic(borderSize, FlxG.height, borderColor);
			border4.immovable = true;
			
			borders = new FlxGroup; 
			borders.add(border1);
			borders.add(border2);
			borders.add(border3);
			borders.add(border4);
			add(borders);
		
			// Sliders
			var sliderX:int = 512;
			createSlider("X", sliderX, gY, "x", ball.velocity, 0, 800, xCallback);
			createSlider("Y", sliderX, gY, "y", ball.velocity, 0, 800, yCallback);
			createSlider("Sprites", sliderX, gY, "Length", this, 0, 40, changeLength);
			createSlider("Sprite Alpha", sliderX, gY, "Alpha", this, 0, 1, changeAlpha);
			createSlider("A. Decrement", sliderX, gY, "alphaDec", this, 0, 0.1, changeDecrement);
			createSlider("Update Delay", sliderX, gY, "Delay", this, 1, 10, changeDelay);
			createSlider("Rotation", sliderX, gY, "ballRotation", this, 0, 90);
			
			// We need a reference to this one because the labels need to be adjusted
			var shapeSlider:FlxSlider = createSlider("Shape", sliderX, gY, "shape", this, 0, 3, changeShape);
			shapeSlider.currentLabel.text = NAMES[0];
			shapeSlider.setTexts("", true, "", "");
			
			// Reset button
			var buttonY:int = 445;
			var buttonGap:int = 90;
			var resetButton:FlxButton = new FlxButton(700, buttonY, "Reset Trail", resetCallback);
			var resetParamsButton:FlxButton = new FlxButton(resetButton.x - buttonGap, buttonY, "Reset Params", resetParamsCallback);
			var copyParamsButton:FlxButton = new FlxButton(resetParamsButton.x - buttonGap, buttonY, "Copy Params", copyParamsCallback);
			add(resetButton);
			add(resetParamsButton);
			add(copyParamsButton);

			// Texts
			var headline:FlxText = new FlxText(525, 15, 500, "FlxSlider.as / FlxTrail.as");
			headline.color = FlxG.BLACK;
			headline.shadow = 0xFF999999;
			headline.size = 16;
			add(headline);
			
			var credits:FlxText = new FlxText(FlxG.width - 275, FlxG.height - 18, 500, "Demo Suite and FlxSlider.as / FlxTrail.as by Gama11");
			credits.color = FlxG.BLACK;
			add(credits);
			
			super.create();
		}
		
		override public function update():void
		{
			FlxG.collide(borders, ball);
			
			ball.angle += ballRotation;
			
			super.update();
		}
		
		private function createSlider(Desc:String, X:int, Y:int, Var:String, Parent:Object, Min:Number, Max:Number, Callback:Function = null):FlxSlider
		{
			var desc:FlxText = new FlxText(X, Y, 200, Desc + ":")
			desc.color = FlxG.BLACK;
			desc.size = 16;
			add(desc);
			
			var slider:FlxSlider = new FlxSlider(X + 150, Y + 5, Min, Max, Callback, Var, Parent, 100);
			slider.setTexts("");
			slider.hoverSound = HoverSound;
			add(slider);
			
			gY += 45;
			
			return slider;
		}
		
		// Slider Callback Functions
		
		private function xCallback(n:Number, currentLabel:FlxText):void
		{	
			ball.velocity.x = n;
			currentLabel.text = (Math.abs(ball.velocity.x)).toString();
		}
		
		private function yCallback(n:Number, currentLabel:FlxText):void
		{
			ball.velocity.y = n;
			currentLabel.text = (Math.abs(ball.velocity.y)).toString();
		}
		
		private function changeLength(n:Number, currentLabel:FlxText):void
		{
			Length = n;
			currentLabel.text = Length.toString();
			redrawTail();
		}
		
		private function changeAlpha(n:Number, currentLabel:FlxText):void
		{
			Alpha = n;
			currentLabel.text = n.toString();
			redrawTail();
		}
		
		private function changeDecrement(n:Number, currentLabel:FlxText):void
		{
			alphaDec = n;
			currentLabel.text = n.toString();
			redrawTail();
		}
		
		private function changeDelay(n:Number, currentLabel:FlxText):void
		{
			ballTrail.delay = n;
			Delay = n;
			currentLabel.text = Delay.toString();
		}
		
		private function changeShape(n:Number, currentLabel:FlxText):void
		{
			shape = n;
			ballTrail.changeGraphic(IMAGES[shape]);
			ball.loadGraphic(IMAGES[shape]);
			currentLabel.text = NAMES[n];
		}
		
		private function redrawTail():void
		{
			if (!FlxG.mouse.pressed()) return;

			ballTrail.kill();
			ballTrail = new FlxTrail(ball, IMAGES[shape], Length, Delay, Alpha, alphaDec);
			add(ballTrail);
		}
		
		// Button callbacks
		
		private function resetCallback():void
		{
			ballTrail.resetTrail();
		}
		
		private function resetParamsCallback():void
		{
			FlxG.switchState(new GameState);
		}
		
		private function copyParamsCallback():void
		{
			var s:String = "trail:FlxTrail = new FlxTrail(object, image," + Length + "," + Delay + "," + Alpha + ","  + alphaDec + ");";
			Clipboard.generalClipboard.clear();
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, s, false);
		}
	}
}