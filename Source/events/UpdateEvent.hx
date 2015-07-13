package events;
import openfl.events.Event;

/**
 * ...
 * @author Nickan
 */
class UpdateEvent extends Event
{
	public static inline var UPDATE :String = "update";
	public var delta(default, null) :Float;
	
	public function new(type :String, bubbles :Bool = false, cancelable :Bool = false, delta :Float) 
	{
		super(type, bubbles, cancelable);
		this.delta = delta;
	}
	
}