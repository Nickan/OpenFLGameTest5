package events;
import openfl.events.Event;

/**
 * ...
 * @author Nickan
 */
class MineEvent extends Event
{
	public static inline var MINE_CLICKED :String = "mineClicked";
	
	public function new(type :String, bubbles :Bool = false, cancelable = false) 
	{
		super(type, bubbles, cancelable);
	}
	
}