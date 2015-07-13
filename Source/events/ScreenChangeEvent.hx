package events;
import openfl.events.Event;

/**
 * ...
 * @author Nickan
 */
class ScreenChangeEvent extends Event
{
	public static inline var TO_GAME_SCREEN :String = "toGameScreen";
	static public inline var TO_TITLE_SCREEN:String = "toTitleScreen";
	
	public function new(type :String, bubbles :Bool = false, cancelable = false) 
	{
		super(type, bubbles, cancelable);
	}
	
}