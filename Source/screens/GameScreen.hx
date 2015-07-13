package screens;
import events.GameOverEvent;
import events.MineEvent;
import events.UpdateEvent;
import haxe.Timer;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import sprites.MineField;
import sprites.TextSprite;
import sprites.TimeSprite;

/**
 * ...
 * @author Nickan
 */
class GameScreen extends Sprite
{
	var _mineField :MineField;
	var _flagCounter :TextSprite;
	var _timeSprite :TimeSprite;

	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
	}

	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		parent.addEventListener(UpdateEvent.UPDATE, onUpdate);
		setupBackground();
		setupMineField();
		setupTime();
		setupMineCounter();
	}

	function setupBackground() 
	{
		var bg = new Bitmap(Assets.getBitmapData("assets/asset_ingame_bg.png"));
		addChild(bg);
	}
	
	function setupMineField() 
	{
		_mineField = new MineField();
		_mineField.x = stage.stageWidth * 0.2;
		_mineField.y = stage.stageHeight * 0.09;
		addChild(_mineField);
		
		_mineField.addEventListener(MineEvent.MINE_CLICKED, onMineClicked);
		_mineField.setOnGameOverFunctionToCall(onGameOver);
	}

	function setupTime() 
	{
		_timeSprite = new TimeSprite();
		_timeSprite.x = stage.stageWidth * 0.2525;
		_timeSprite.y = stage.stageHeight * 0.855;
		addChild(_timeSprite);
	}
	
	function setupMineCounter() 
	{
		_flagCounter = new TextSprite();
		addChild(_flagCounter);
		_flagCounter.x = stage.stageWidth * 0.7;
		_flagCounter.y = stage.stageHeight * 0.855;
		_flagCounter.showText("10");
	}
	
	
	private function onMineClicked(e:Event):Void 
	{
		_mineField.removeEventListener(MineEvent.MINE_CLICKED, onMineClicked);
		//dispatchEvent(new GameOverEvent(GameOverEvent.GAME_OVER, false, false, 
		//Timer.delay(onGameOver, 5000);
		onGameOver();
	}
	
	function onGameOver(won :Bool = false) 
	{
		var gameOverScreen = new GameOverScreen(_mineField.getFlaggedMinesCount(), _timeSprite.getTimeString(), won);
		_timeSprite.stop = true;
		addChild(gameOverScreen);
	}
	
	
	
	private function onUpdate(e:UpdateEvent):Void 
	{
		
		if (_mineField != null && _flagCounter != null)
			_flagCounter.showText("" + (MineField.TOTAL_FLAGS - _mineField.flagsDeployed));
	}
	
	
	
	
	private function onRemoved(e:Event):Void 
	{
		removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		parent.removeEventListener(UpdateEvent.UPDATE, onUpdate);
	}
	
}