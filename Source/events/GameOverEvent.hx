package events;
import openfl.events.Event;

/**
 * ...
 * @author Nickan
 */
class GameOverEvent extends Event
{
	public static inline var GAME_OVER :String = "gameOver";
	public var minesLeft(default, null) :Int;
	public var timeElapsed(default, null) :Int;
	
	public var win(default, null) :Bool = false;

	public function new(type :String, bubbles :Bool = false, cancelable = false, minesLeft :Int, timeElapsed :Int, win :Bool = false) 
	{
		super(type, bubbles, cancelable);
		this.minesLeft = minesLeft;
		this.timeElapsed = timeElapsed;
		this.win = win;
	}
	
}