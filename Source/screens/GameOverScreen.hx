package screens;
import events.GameOverEvent;
import events.ScreenChangeEvent;
import framework.TextButton;
import haxe.Timer;
import motion.Actuate;
import motion.easing.Back;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import sprites.TextSprite;

/**
 * ...
 * @author Nickan
 */
class GameOverScreen extends Sprite
{
	static inline var SHOW_DURATION :Float = 0.4;
	
	var _flaggedMinesCount :Int;
	var _timeRemaining :String;
	var _retryButton :TextButton;
	var _quitButton :TextButton;
	var _won :Bool;
	
	public function new(flaggedMinesCount :Int, timeRemaining :String, won :Bool = false) 
	{
		super();
		_flaggedMinesCount = flaggedMinesCount;
		_timeRemaining = timeRemaining;
		_won = won;
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		setupBackground();
	}
	
	function setupBackground() 
	{
		graphics.beginFill(0x000000, 0.3);
		graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		graphics.endFill();
		
		Actuate.tween(this, 0.4, { alpha :1 } ).onComplete(onCompleted);
	}
	
	function onCompleted() 
	{
		if (_won) {
			setupFlaggedMinesCount();
			Timer.delay(onFinishedShowingGameOverSprite, 400);
		}
		else
			Timer.delay(setupGameOverSprite, 0);
		//Timer.delay(setupGameOverSprite, 5000);
		//setupGameOverSprite();
	}
	
	function setupGameOverSprite() 
	{
		var gameOver = new Bitmap(Assets.getBitmapData("assets/asset_game_over_header.png"));
		addChild(gameOver);
		gameOver.x = -gameOver.width;
		gameOver.y = stage.stageHeight * 0.35 - (gameOver.height * 0.5);
		
		var dest = stage.stageWidth * 0.5 - (gameOver.width * 0.5);
		Actuate.tween(gameOver, 0.4, { x :dest } ).onComplete(onFinishedShowingGameOverSprite);
		
		setupFlaggedMinesCount();
	}
	
	function setupFlaggedMinesCount() 
	{
		var flaggedMinesSprite = new TextSprite();
		addChild(flaggedMinesSprite);
		flaggedMinesSprite.x = stage.stageWidth * 0.2 - (flaggedMinesSprite.width * 0.5);
		flaggedMinesSprite.y = stage.stageHeight * 0.1 - (flaggedMinesSprite.height * 0.5);
		if (_won)
			flaggedMinesSprite.showText("You Won!");
		else
			flaggedMinesSprite.showText("Total Flagged mines " + _flaggedMinesCount);
	}
	
	function onFinishedShowingGameOverSprite() 
	{
		setupRetryButton();
		Timer.delay(setupQuitButton, 200);
	}
	
	function setupRetryButton() 
	{
		_retryButton = new TextButton("Retry", new Bitmap(Assets.getBitmapData("assets/asset_button_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_hover.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_down.png")), null, onRetry, "Retry");
		addChild(_retryButton);
		_retryButton.x = stage.stageWidth * 0.5 - (_retryButton.width * 0.5);
		_retryButton.y = stage.stageHeight * 1;
		
		Actuate.tween(_retryButton, SHOW_DURATION, { y :stage.stageHeight * 0.45 } ).ease(Back.easeOut);
	}
	
	function setupQuitButton() 
	{
		_quitButton = new TextButton("Quit", new Bitmap(Assets.getBitmapData("assets/asset_button_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_hover.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_down.png")), null, onQuit, "Quit");
		addChild(_quitButton);
		_quitButton.x = stage.stageWidth * 0.5 - (_retryButton.width * 0.5);
		_quitButton.y = stage.stageHeight * 1;
		
		Actuate.tween(_quitButton, SHOW_DURATION, { y :stage.stageHeight * 0.60 } ).ease(Back.easeOut);
	}

	function onRetry(string :String) 
	{
		playRemoveButtons();
		Timer.delay(playAlphaFade, 400);
		Timer.delay(goToGameScreen, 800);
	}
	
	function onQuit(string :String) 
	{
		playRemoveButtons();
		Timer.delay(playAlphaFade, 400);
		Timer.delay(goToTitleScreen, 800);
	}
	
	function playRemoveButtons() 
	{
		Actuate.tween(_retryButton, 0.4, { y :stage.stageHeight } );
		Actuate.tween(_quitButton, 0.4, { y :stage.stageHeight } );
	}
	
	function playAlphaFade() 
	{
		Actuate.tween(parent, 0.4, { alpha :0 } );
		Actuate.tween(this, 0.4, { alpha :0 } );
		
	}
	
	function goToTitleScreen() 
	{
		parent.dispatchEvent(new ScreenChangeEvent(ScreenChangeEvent.TO_TITLE_SCREEN));
	}
	
	function goToGameScreen() 
	{
		parent.dispatchEvent(new ScreenChangeEvent(ScreenChangeEvent.TO_GAME_SCREEN));
	}
}