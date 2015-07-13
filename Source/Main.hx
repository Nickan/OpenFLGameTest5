package;


import events.ScreenChangeEvent;
import events.UpdateEvent;
import framework.TimeManager;
import haxe.Timer;
import motion.Actuate;
import openfl.display.Sprite;
import openfl.events.Event;
import screens.GameScreen;
import screens.TitleScreen;


class Main extends Sprite {
	
	var _titleScreen:TitleScreen;
	var _gameScreen :GameScreen;
	
	public function new () {
		
		super ();
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
		addEventListener(Event.ENTER_FRAME, onUpdate);
	}
	
	private function onUpdate(e:Event):Void 
	{
		TimeManager.getInstance().update();
		dispatchEvent(new UpdateEvent(UpdateEvent.UPDATE, false, false, TimeManager.getInstance().delta));
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		setupTitleScreen();
	}
	
	function setupTitleScreen() 
	{
		_titleScreen = new TitleScreen();
		_titleScreen.alpha = 0;
		Actuate.tween(_titleScreen, 0.4, { alpha : 1 } );
		addChild(_titleScreen);
		_titleScreen.addEventListener(ScreenChangeEvent.TO_GAME_SCREEN, onGameScreen);
	}
	
	private function onGameScreen(e:ScreenChangeEvent):Void 
	{
		disposeTitleScreen();
		disposeGameScreen();
		setupGameScreen();
	}
	
	private function onTitleScreen(e:ScreenChangeEvent):Void 
	{
		disposeTitleScreen();
		disposeGameScreen();
		setupTitleScreen();
	}
	
	
	function setupGameScreen() 
	{
		_gameScreen = new GameScreen();
		_gameScreen.alpha = 0;
		Actuate.tween(_gameScreen, 0.4, { alpha : 1 } );
		addChild(_gameScreen);
		
		_gameScreen.addEventListener(ScreenChangeEvent.TO_GAME_SCREEN, onGameScreen);
		_gameScreen.addEventListener(ScreenChangeEvent.TO_TITLE_SCREEN, onTitleScreen);
	}
	
	
	
	function disposeGameScreen() 
	{
		if (_gameScreen == null)
			return;
		_gameScreen.removeEventListener(ScreenChangeEvent.TO_GAME_SCREEN, onGameScreen);
		_gameScreen.removeEventListener(ScreenChangeEvent.TO_TITLE_SCREEN, onTitleScreen);
		removeChild(_gameScreen);
		_gameScreen = null;
	}
	
	function disposeTitleScreen()
	{
		if (_titleScreen == null)
			return;
		_titleScreen.removeEventListener(ScreenChangeEvent.TO_GAME_SCREEN, onGameScreen);
		removeChild(_titleScreen);
		_titleScreen = null;
	}
	
}