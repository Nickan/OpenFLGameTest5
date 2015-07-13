package managers;
import sprites.Cell;

/**
 * ...
 * @author Nickan
 */
class NumberDeployManager
{
	var _mineField:Array<Array<Cell>>;

	public function new(mineField :Array<Array<Cell>>) 
	{
		_mineField = mineField;
	}
	
	public function deployNumber() 
	{
		for (x in 0..._mineField.length) {
			for (y in 0..._mineField[0].length) {
				var cell = _mineField[x][y];
				if (cell.type == CellType.MINE)
					continue;
					
				var numOfMinesAround :Int = getNumberOfMinesAround(x, y);
				setCellTypeNumber(cell, numOfMinesAround);
			}
		}
	}
	
	function setCellTypeNumber(cell :Cell, numOfMinesAround :Int) 
	{
		switch (numOfMinesAround) {
			case 1: cell.type = CellType.NUMBER_1;
			case 2: cell.type = CellType.NUMBER_2;
			case 3: cell.type = CellType.NUMBER_3;
			case 4: cell.type = CellType.NUMBER_4;
			case 5: cell.type = CellType.NUMBER_5;
			case 6: cell.type = CellType.NUMBER_6;
			case 7: cell.type = CellType.NUMBER_7;
			case 8: cell.type = CellType.NUMBER_8;
			case 9: cell.type = CellType.NUMBER_9;
			default:
		}
	}
	
	function getNumberOfMinesAround(x :Int, y :Int) :Int
	{
		var mineCount :Int = 0;
		for (countX in 0...3) {
			for (countY in 0...3) {
				var xIndex = (x - 1) + countX;
				var yIndex = (y - 1) + countY;
				if ( (xIndex >= 0 && xIndex < _mineField.length) &&
					(yIndex >= 0 && yIndex < _mineField[0].length) ) {
					var cellType = _mineField[xIndex][yIndex].type;
					
					if (xIndex == 1 && yIndex == 1)		// Cell itself, no need to check
						continue;
					
					if (cellType == CellType.MINE)
						mineCount++;
				}
			}
		}
		return mineCount;
	}
	
}