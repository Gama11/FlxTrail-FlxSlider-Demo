package org.flixel
{
	import flash.ui.Mouse;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import org.flixel.FlxG;
	import org.flixel.FlxCamera;
	import org.flixel.FlxButton;
	
	public class FlxInputText extends FlxButton 
	{
		static public var _mouseVisible:Boolean;
		static public var _deactivating:Boolean;
		protected var _input:TextField;
		protected var callback:Function;
		
		public function FlxInputText(_x:Number = 0, _y:Number = 0, _label:String = null, _callback:Function = null):void 
		{
			super(_x, _y, _label, show);
			_input = new TextField();
			_input.selectable = true;
			_input.type = TextFieldType.INPUT;
			_input.background = true;
			_input.backgroundColor = 0xffffff;
			_deactivating = false;
			callback = _callback;
		}
		
		override public function destroy():void 
		{
			super.destroy();
			if (FlxG.stage != null) {
				_input.removeEventListener(Event.CHANGE, onChange);
				_input.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
				FlxG.stage.addEventListener(Event.ACTIVATE, onActivate);
				FlxG.stage.addEventListener(Event.DEACTIVATE, onDeactivate);
			}
		}
		public function show():void 
		{
			_mouseVisible = FlxG.mouse.visible;
			FlxG.mouse.hide();
			flash.ui.Mouse.show();
			FlxG.stage.addChild(_input);
			_input.text = label.text;
			_input.setSelection(_input.length, _input.length);
			_input.x = x * FlxCamera.defaultZoom;
			_input.y = y * FlxCamera.defaultZoom;
			_input.width = width * FlxCamera.defaultZoom;
			_input.height = height * FlxCamera.defaultZoom;
			_input.addEventListener(Event.CHANGE, onChange);
			_input.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			FlxG.stage.addEventListener(Event.ACTIVATE, onActivate);
			FlxG.stage.addEventListener(Event.DEACTIVATE, onDeactivate);
			FlxG.stage.focus = _input;
			active = false;
		}
		public function onChange(_event:Event):void 
		{
			label.text = _input.text;
			if (callback != null) callback(Number(_input.text));
		}
		 public function onActivate(_event:Event):void 
		{
			_deactivating = false;
			FlxG.stage.removeEventListener(Event.ACTIVATE, onActivate);
		}
		 public function onDeactivate(_event:Event):void 
		{
			_deactivating = true;
			FlxG.stage.removeEventListener(Event.DEACTIVATE, onDeactivate);
		}
		public function onFocusOut(_event:Event):void 
		{
			if (_mouseVisible) FlxG.mouse.show();
			if(!_deactivating) flash.ui.Mouse.hide();
			_input.removeEventListener(Event.CHANGE, onChange);
			_input.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			FlxG.stage.removeChild(_input);
			active = true;
		}
	}
}