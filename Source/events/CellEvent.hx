package events;
import openfl.events.Event;
import sprites.Cell;

/**
 * ...
 * @author ...
 */
class CellEvent extends Event
{
	public static inline var OPEN_CELL :String = "openCell";
	public static inline var FLAG_CELL :String = "flagCell";
	
	public var cell :Cell;
	
	public function new(type :String, bubbles :Bool = false, cancelable :Bool = false, cell :Cell) 
	{
		super(type, bubbles, cancelable);
		this.cell = cell;
	}
	
}