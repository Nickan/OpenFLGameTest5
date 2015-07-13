package sprites;
import events.CellEvent;
import events.GameOverEvent;
import events.MineEvent;
import events.ScreenChangeEvent;
import managers.MineDeployManager;
import managers.NumberDeployManager;
import managers.RevealManager;
import openfl.display.Sprite;
import openfl.events.Event;
import sprites.Cell;

/**
 * ...
 * @author Nickan
 */
class MineField extends Sprite
{
	public static inline var TOTAL_FLAGS :Int = 20;
	
	static inline var HORIZONTAL_NUMBER :Int = 15;
	static inline var VERTICAL_NUMBER :Int = 14;
	
	public var flagsDeployed(default, null) :Int = 0;
	
	var _mineField :Array<Array<Cell>>;
	var _mineDeployer :MineDeployManager;
	var _revealManager :RevealManager;
	var _onGameOver :Bool->Void;
	
	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		setupMineField();
		setupMineDeployer();
		setupNumberDeployer();
		setupRevealManager();
	}

	function setupMineField() 
	{
		_mineField = [];
		for (x in 0...HORIZONTAL_NUMBER) {
			var verticalField = new Array<Cell>();
			_mineField.push(verticalField);
			for (y in 0...VERTICAL_NUMBER) {
				var cell = new Cell();
				cell.x = x * cell.width;
				cell.y = y * cell.height;
				cell.addEventListener(CellEvent.OPEN_CELL, onCellOpen);
				cell.addEventListener(CellEvent.FLAG_CELL, onCellFlagged);
				
				verticalField.push(cell);
				addChild(cell);
			}
		}
	}

	function setupMineDeployer() 
	{
		_mineDeployer = new MineDeployManager(_mineField);
		_mineDeployer.randomlyDeployMines();
	}
	
	function setupNumberDeployer() 
	{
		var _numberDeployer = new NumberDeployManager(_mineField);
		_numberDeployer.deployNumber();
	}
	
	function setupRevealManager() 
	{
		_revealManager = new RevealManager(_mineField);
	}
	
	private function onCellOpen(e:CellEvent):Void 
	{
		e.cell.removeEventListener(CellEvent.OPEN_CELL, onCellOpen);
		//e.cell.state = Cell.State.OPENED;
		if (e.cell.type == CellType.MINE)
			onMineClicked(e.cell);
		_revealManager.reveal(e.cell);
		checkIfAlreadyWon();
	}
	
	function checkIfAlreadyWon() 
	{
		var unopenedCount :Int = 0;
		for (x in 0...HORIZONTAL_NUMBER) {
			for (y in 0...VERTICAL_NUMBER) {
				var cell = _mineField[x][y];
				
				if (cell.state == State.UNOPENED) {
					unopenedCount++;
					
					if (unopenedCount > MineDeployManager.TOTAL_MINES)
						break;
				}
			}
		}
		
		if (unopenedCount == MineDeployManager.TOTAL_MINES) {
			var unOpenedCells = getUnopenedCells();
			var unOpenedMines :Int = 0;
			
			for (tempCell in unOpenedCells) {
				if (tempCell.type == CellType.MINE) {
					unOpenedMines++;
					if (unOpenedMines == MineDeployManager.TOTAL_MINES) {
						_onGameOver(true);
					}
				}
			}
			
		}
		
		if (_mineDeployer.getFlaggedMineCount() == MineDeployManager.TOTAL_MINES) 
			_onGameOver(true);
	}
	
	function getUnopenedCells() 
	{
		var unopenedCells = [];
		for (x in 0...HORIZONTAL_NUMBER) {
			for (y in 0...VERTICAL_NUMBER) {
				var cell = _mineField[x][y];
				
				if (cell.state == State.UNOPENED) 
					unopenedCells.push(cell);
			}
		}
		return unopenedCells;
	}
	
	function onMineClicked(cell:Cell) 
	{
		dispatchEvent(new MineEvent(MineEvent.MINE_CLICKED));
		_revealManager.revealMines();
	}
	
	private function onCellFlagged(e:CellEvent):Void 
	{
		if (e.cell.flagged) {
			if (flagsDeployed < TOTAL_FLAGS)
				flagsDeployed++;
		}
		else
			flagsDeployed--;
			
		if (flagsDeployed == TOTAL_FLAGS) {
			for (x in 0...HORIZONTAL_NUMBER) {
				for (y in 0...VERTICAL_NUMBER) {
					_mineField[x][y].stopFlagging = true;
				}
			}
		} else {
			for (x in 0...HORIZONTAL_NUMBER) {
				for (y in 0...VERTICAL_NUMBER) {
					_mineField[x][y].stopFlagging = false;
				}
			}
		}
		
		if (_mineDeployer.getFlaggedMineCount() == MineDeployManager.TOTAL_MINES) 
			_onGameOver(true);
	}
	
	private function onRemoved(e:Event):Void 
	{
		for (x in 0...HORIZONTAL_NUMBER) {
			for (y in 0...VERTICAL_NUMBER) {
				var cell = _mineField[x][y];
				cell.removeEventListener(CellEvent.FLAG_CELL, onCellFlagged);
			}
		}
	}
	
	public function getFlaggedMinesCount() {
		return _mineDeployer.getFlaggedMineCount();
	}
	
	public function setOnGameOverFunctionToCall(onGameOver :Bool->Void) 
	{
		_onGameOver = onGameOver;
	}
	
}