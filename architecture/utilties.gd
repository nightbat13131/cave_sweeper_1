class_name Utilties extends RefCounted

const COLOR_PATH_OUTER_CELL := Color(217/255.0, 160/255.0, 102/255.0, 0.5) # Color(0.9, 0.541, 0.369, 0.5)
const COLOR_PATH_CENTER_CELL := COLOR_PATH_OUTER_CELL # Color(.3,.3,.3,.5)

enum Popups {NA = 0, SOUND_SETTINGS = 1, HELP = 2}

enum SFX { NA = 0, 
	BUTTON_PRESS = 1,
	FLAG_PLACED = 50, FLAG_REMOVED = 51,
	
	PICKUP_LOOT = 60, 
	DIED = 100, HURT = 101, 
	}

enum Results {INPROGRESS = 0, WIN = 1, LOSS = 2}

enum PathSweeper_Alts { MOVE = -1, REPELL = -2, FLAG_DANGER = -3, FLAG_SAFE = -4, # Used in UI, so don't change
	NA = 0, 
	BLOCKED  = 5, REPELL_SUCCESS = 6, REPELL_WASTED = 7,
	DANGER0 = 10,
	LOOT0 = 20,
	WALL = 30, BOULDER = 31
	}

## Display the grid with row and column numbers.
static func display_grid(grid : Array[Array], title="Grid"):
	print(title)
	var row : Array
	var row_print := ""
	#var cell : int
	for y in range(grid.size()):
		row = grid[y]
		row_print = str(y) + "| "
		for cell: PuzzleCellInfo in row:
			row_print += str(cell)
		row_print += " | "
		print(row_print)
