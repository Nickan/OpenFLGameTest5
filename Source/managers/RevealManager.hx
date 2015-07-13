package managers;
import framework.Point;
import sprites.Cell;

/**
 * ...
 * @author Nickan
 */
class RevealManager
{

	var _mineField:Array<Array<Cell>>;

	public function new(mineField :Array<Array<Cell>>) 
	{
		_mineField = mineField;
	}
	
	public function reveal(cell :Cell) 
	{
		if (cell.type != CellType.BLANK) {
			cell.state = State.OPENED;
			return;
		}
		
		var xIndex :Int = 0;
		var yIndex :Int = 0;
		for (x in 0..._mineField.length) {
			for (y in 0..._mineField[0].length) {
				var c = _mineField[x][y];
				if (cell == c) {
					xIndex = x;
					yIndex = y;
					break;
				}
			}
		}
		
		openNeighboringCellsThatAreNotMine(new Point(xIndex, yIndex));
	}
	
	public function revealMines() {
		for (x in 0..._mineField.length) {
			for (y in 0..._mineField[0].length) {
				var cell = _mineField[x][y];
				if (cell.type == CellType.MINE) {
					if (cell.state == State.UNOPENED)
						cell.state = State.OPENED;
				}
			}
		}
	}
	
	
	function openNeighboringCellsThatAreNotMine(unopenedPoint :Point) 
	{
		var unopenedPoints = [];
		unopenedPoints.push(unopenedPoint);
		
		while (unopenedPoints.length != 0) {
			var point = unopenedPoints[0];
			unopenedPoints.remove(point);
			
			var toOpenCell = _mineField[point.x][point.y];
			toOpenCell.state = State.OPENED;
			for (countX in 0...3) {
				for (countY in 0...3) {
					var xIndex = (point.x - 1) + countX;
					var yIndex = (point.y - 1) + countY;
					if ( (xIndex >= 0 && xIndex < _mineField.length) &&
						(yIndex >= 0 && yIndex < _mineField[0].length) ) {
						var cell = _mineField[xIndex][yIndex];
						
						if (cell.type == CellType.MINE || cell.flagged)
							continue;
						
						if (xIndex == point.x && yIndex == point.y)		// Cell itself, no need to check
							continue;
						
						if (cell.state == State.UNOPENED && cell.type == CellType.BLANK) {
							if (!isInArray(unopenedPoints, xIndex, yIndex))
								unopenedPoints.push(new Point(xIndex, yIndex));
						}
						else {
							if (!cell.flagged)
								cell.state = State.OPENED;
						}
					}
				}
			}
			
		}
	}
	
	function isInArray(points :Array<Point>, x :Int, y :Int)
	{
		for (point in points) {
			if (point.x == x && point.y == y)
				return true;
		}
		return false;
	}
	
	
	
}