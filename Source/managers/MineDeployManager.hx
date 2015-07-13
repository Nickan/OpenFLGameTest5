package managers;
import framework.Point;
import framework.Random;
import sprites.Cell;

/**
 * ...
 * @author Nickan
 */
class MineDeployManager
{
	public static inline var TOTAL_MINES :Int = 20;
	
	var _mineCount :Int = 0;
	var _mineField :Array<Array<Cell>>;
	var _deployedArea :Array<Point>;
	
	public function new(mineField :Array<Array<Cell>>) 
	{
		_mineField = mineField;
	}
	
	public function randomlyDeployMines() 
	{
		_deployedArea = [];
		while (_mineCount < TOTAL_MINES)  {
			var x = Random.int(0, _mineField.length - 1);
			var y = Random.int(0, _mineField[0].length - 1);
			if (!isInDeployedArea(x, y)) {
				_mineCount++;
				_deployedArea.push(new Point(x, y));
				_mineField[x][y].type = CellType.MINE;
				
				//...
				//trace("Deployed at: " + x + " " + y);
			}
		}
	}
	
	function isInDeployedArea(x :Int, y :Int)
	{
		for (point in _deployedArea) {
			if (point.x == x && point.y == y)
				return true;
		}
		return false;
	}
	
	public function getFlaggedMineCount() {
		var flaggedAreas :Array<Point> = getFlaggedMines();
		var flaggedMineCount :Int = 0;
		for (areaPoint in flaggedAreas) {
			if (isInDeployedArea(areaPoint.x, areaPoint.y))
				flaggedMineCount++;
		}
		return flaggedMineCount;
	}
	
	function getFlaggedMines() 
	{
		var flaggedAreas :Array<Point> = [];
		for (x in 0..._mineField.length) {
			for (y in 0..._mineField[0].length) {
				var cell = _mineField[x][y];
				if (cell.type == CellType.MINE && cell.flagged) {
					flaggedAreas.push(new Point(x, y));
				}
			}
		}
		return flaggedAreas;
	}
	
}