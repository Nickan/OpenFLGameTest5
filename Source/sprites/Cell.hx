package sprites;
import events.CellEvent;
import motion.Actuate;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;

enum CellType {
	BLANK;
	MINE;
	NUMBER_1;
	NUMBER_2;
	NUMBER_3;
	NUMBER_4;
	NUMBER_5;
	NUMBER_6;
	NUMBER_7;
	NUMBER_8;
	NUMBER_9;
}

enum State {
	OPENED;
	UNOPENED;
}

/**
 * ...
 * @author Nickan
 */
class Cell extends Sprite
{
	public var type(default, set) :CellType;
	public var state(default, set) :State;
	public var flagged(default, null) :Bool = false;
	public var stopFlagging(default, default) :Bool = false;
	
	var _shakeDist :Float;
	var _actualX :Float;
	
	var _typeBitmap :Bitmap;
	var _stateBitmap :Bitmap;
	var _coverBitmap :Bitmap;
	var _textField :TextField;
	var _flagBitmap :Bitmap;
	
	public function new() 
	{
		super();
		state = State.UNOPENED;
		type = CellType.BLANK;
		addEventListener(MouseEvent.CLICK, onMouseClicked);
		addEventListener(MouseEvent.MIDDLE_CLICK, onMouseMiddleClicked);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
	}
	
	private function onMouseClicked(e:MouseEvent):Void 
	{
		if (flagged)
			return;
		
		removeEventListener(MouseEvent.CLICK, onMouseClicked);
		if (state == State.UNOPENED)
			dispatchEvent(new CellEvent(CellEvent.OPEN_CELL, false, false, this));
	}
	
	private function onMouseMiddleClicked(e:MouseEvent):Void 
	{
		if (!flagged) {
			if (state == State.OPENED || stopFlagging)
				return;
		}
		
		flagged = !flagged;
		dispatchEvent(new CellEvent(CellEvent.FLAG_CELL, false, false, this));
		
		if (flagged) {
			if (_flagBitmap == null)
				_flagBitmap = new Bitmap(Assets.getBitmapData("assets/flag.png"));
			addChild(_flagBitmap);
		} else {
			if (_flagBitmap != null)
				removeChild(_flagBitmap);
		}
	}
	
	function setTypeBitmap() 
	{
		var assetPath = "assets/";
		if (_typeBitmap != null) {
			removeChild(_typeBitmap);
			_typeBitmap = null;
		}
		
		switch (type) {
			case BLANK:
			case MINE: assetPath += "asset_bomb.png";
						_typeBitmap = new Bitmap(Assets.getBitmapData(assetPath));
						addChildAt(_typeBitmap, 0);
			case NUMBER_1: setText("" + 1);
			case NUMBER_2: setText("" + 2);
			case NUMBER_3: setText("" + 3);
			case NUMBER_4: setText("" + 4);
			case NUMBER_5: setText("" + 5);
			case NUMBER_6: setText("" + 6);
			case NUMBER_7: setText("" + 7);
			case NUMBER_8: setText("" + 8);
			case NUMBER_9: setText("" + 9);
			default:
		}
		
	}
	
	function setText(string :String) 
	{
		if (_textField != null) {
			removeChild(_textField);
			addChild(_textField);
		}
		
		var textFormat = new TextFormat("Verdana", 30, 0xFFFFFF);
		
		_textField = new TextField();
		_textField.text = string;
		_textField.defaultTextFormat = textFormat;
		_textField.autoSize = TextFieldAutoSize.LEFT;
		_textField.x = this.width * 0.5 - (_textField.width * 0.5);
		_textField.y = this.height * 0.5 - (_textField.height * 0.5);
		addChildAt(_textField, 0);
	}

	function setStateBitmap() 
	{
		if (state == State.UNOPENED) {
			_coverBitmap = new Bitmap(Assets.getBitmapData("assets/asset_unpressed_block.png"));
			addChild(_coverBitmap);
		} else {
			removeCover();
			
			_stateBitmap = new Bitmap(Assets.getBitmapData("assets/asset_pressed_block.png"));
			addChildAt(_stateBitmap, 0);
		}
		
		//... Test
		//if (_coverBitmap != null)
			//_coverBitmap.alpha = 0.2;
	}
	
	function removeCover() 
	{
		if (type != CellType.MINE) {
			if (_coverBitmap != null)
				Actuate.tween(_coverBitmap, 2, { alpha :0 } ).onComplete(onRemovedCover);
		} else {
			if (_coverBitmap != null) {
				removeChild(_coverBitmap);
				_coverBitmap = null;
				playShakeAnimation();
			}
		}
		
	}

	function playShakeAnimation() 
	{
		_actualX = x;
		_shakeDist = this.width * 0.5;
		var DURATION :Float = 0.025;
		Actuate.tween(this, DURATION, { x :_actualX + _shakeDist }, false).delay(DURATION);
		Actuate.tween(this, DURATION, { x :_actualX - _shakeDist }, false).delay(DURATION * 2);
		
		Actuate.tween(this, DURATION, { x :_actualX + (_shakeDist / 2) }, false).delay(DURATION * 3);
		Actuate.tween(this, DURATION, { x :_actualX - (_shakeDist / 2) }, false).delay(DURATION * 4);
		
		Actuate.tween(this, DURATION, { x :_actualX + (_shakeDist / 4) }, false).delay(DURATION * 5);
		Actuate.tween(this, DURATION, { x :_actualX - (_shakeDist / 4) }, false).delay(DURATION * 6);
		Actuate.tween(this, DURATION, { x :_actualX + (_shakeDist / 4) }, false).delay(DURATION * 6);
		Actuate.tween(this, DURATION, { x :_actualX - (_shakeDist / 4) }, false).delay(DURATION * 7);
		
		Actuate.tween(this, DURATION, { x :_actualX + (_shakeDist / 8) }, false).delay(DURATION * 8);
		Actuate.tween(this, DURATION, { x :_actualX - (_shakeDist / 8) }, false).delay(DURATION * 9);
		Actuate.tween(this, DURATION, { x :_actualX + (_shakeDist / 8) }, false).delay(DURATION * 10);
		Actuate.tween(this, DURATION, { x :_actualX - (_shakeDist / 8) }, false).delay(DURATION * 11);
		Actuate.tween(this, DURATION, { x :_actualX + (_shakeDist / 8) }, false).delay(DURATION * 12);
		Actuate.tween(this, DURATION, { x :_actualX - (_shakeDist / 8) }, false).delay(DURATION * 13);
		Actuate.tween(this, DURATION, { x :_actualX + (_shakeDist / 8) }, false).delay(DURATION * 14);
		Actuate.tween(this, DURATION, { x :_actualX - (_shakeDist / 8) }, false).delay(DURATION * 15);
		
		Actuate.tween(this, DURATION, { x :_actualX + (_shakeDist / 16) }, false).delay(DURATION * 16);
		Actuate.tween(this, DURATION, { x :_actualX - (_shakeDist / 16) }, false).delay(DURATION * 17);
		Actuate.tween(this, DURATION, { x :_actualX + (_shakeDist / 16) }, false).delay(DURATION * 18);
		Actuate.tween(this, DURATION, { x :_actualX - (_shakeDist / 16) }, false).delay(DURATION * 19);
		Actuate.tween(this, DURATION, { x :_actualX + (_shakeDist / 16) }, false).delay(DURATION * 20);
		Actuate.tween(this, DURATION, { x :_actualX - (_shakeDist / 16) }, false).delay(DURATION * 21);
		Actuate.tween(this, DURATION, { x :_actualX + (_shakeDist / 16) }, false).delay(DURATION * 22);
		Actuate.tween(this, DURATION, { x :_actualX - (_shakeDist / 16) }, false).delay(DURATION * 23).onComplete(onShakeCompleted);
	}
	
	function onShakeCompleted() 
	{
		x = _actualX;
	}
	
	function onRemovedCover() 
	{
		if (_coverBitmap != null)
			removeChild(_coverBitmap);
		_coverBitmap = null;
	}
	
	function set_state(value :State)
	{
		state = value;
		setStateBitmap();
		return state;
	}
	
	function set_type(value :CellType) 
	{
		type = value;
		setTypeBitmap();
		return type;
	}
	
	private function onRemoved(e:Event):Void 
	{
		removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		removeEventListener(MouseEvent.MIDDLE_CLICK, onMouseMiddleClicked);
		if (_flagBitmap == null)
			_flagBitmap = null;
	}
	
}