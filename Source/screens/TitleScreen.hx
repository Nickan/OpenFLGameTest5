package screens;
import events.ScreenChangeEvent;
import framework.TextButton;
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Elastic;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Nickan
 */
class TitleScreen extends Sprite
{
	static inline var SHOW_DURATION :Float = 0.4;
	
	var _playButton :TextButton;

	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		setupBackground();
		setupTitle();
	}
	
	function setupBackground() 
	{
		var bg = new Bitmap(Assets.getBitmapData("assets/asset_menu_bg.png"));
		addChild(bg);
	}
	
	function setupTitle() 
	{
		var title = new Bitmap(Assets.getBitmapData("assets/asset_logo.png"));
		addChild(title);
		title.x = -title.width;
		title.y = stage.stageHeight * 0.4 - (title.height * 0.5);
		Actuate.tween(title, SHOW_DURATION, { x: (stage.stageWidth * 0.5 - title.width * 0.5) } ).ease(Back.easeOut).onComplete(onDoneShowingTitle);
	}
	
	function onDoneShowingTitle() 
	{
		setupPlayButton();
	}
	
	function setupPlayButton() 
	{
		_playButton = new TextButton("Play", new Bitmap(Assets.getBitmapData("assets/asset_button_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_hover.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_down.png")), null, onPlay, "Play");
		addChild(_playButton);
		_playButton.x = stage.stageWidth * 0.5 - (_playButton.width * 0.5);
		_playButton.y = stage.stageHeight * 1;
		
		Actuate.tween(_playButton, SHOW_DURATION, { y :stage.stageHeight * 0.65 } ).ease(Back.easeOut);
	}
	
	function onPlay(text :String) 
	{
		Actuate.tween(_playButton, SHOW_DURATION, { y :stage.stageHeight } ).ease(Back.easeIn);
		Actuate.tween(this, SHOW_DURATION, { alpha :0 } ).onComplete(onGameScreen).delay(SHOW_DURATION);
	}
	
	function onGameScreen() 
	{
		_playButton.dispose();
		dispatchEvent(new ScreenChangeEvent(ScreenChangeEvent.TO_GAME_SCREEN));
	}
	
}