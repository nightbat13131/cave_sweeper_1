class_name PathSweeper_Inner extends PuzzleFoundation

@export var _inner_grid_size : Vector2i : get = get_grid_size 

@export var _danger_count: int = 10
@export var _extra_wall_count : int = 10
@export var _danger_neighbors : int = 2
@export var _start_side := Vector2i.DOWN

func _get_results() -> Utilties.Results: return Utilties.Results.INPROGRESS

func request_restart() -> void: pass

func _restart() -> void: pass

func _new_puzzle() -> void:
	PathSweeperCellInfo.clear_doors()
	_clear_grids()
	_populate_extra_walls()
	_populate_danger()
	#Utilties.display_grid(get_cells_grid())

func get_grid_size() -> Vector2i: return _inner_grid_size + (Vector2i.ONE*2)

func _clear_grids() -> void:
	_cells_grid.clear()
	var cell : PathSweeperCellInfo
	var position : Vector2i
	var size = get_grid_size()
	for r in size.y: 
		_cells_grid.append([])
		for c in size.x: 
			position = Vector2i(c, r)
			cell = PathSweeperCellInfo.new()
			cell.set_position(position)
			_cells_grid[r].append(cell)
			for direction in [Vector2i.UP + Vector2i.LEFT, Vector2i.UP, Vector2i.LEFT, Vector2i.UP + Vector2i.RIGHT]:
				cell.add_map_neighbor(
					get_cell_from_pos(position + direction)
				)
			if r == 0 or r == size.y-1 or c == 0 or c == size.x-1:
				cell.set_wall(Utilties.PathSweeper_Alts.WALL)
	_place_doors()

func _place_doors() -> void: 
	## enter from the start side _start_side
	var rec := Rect2(Vector2i.ZERO, get_grid_size()-Vector2i.ONE)
	var _start_pos = Vector2i.ZERO
	var _end_pos = Vector2(1,0)
	var sides = [Vector2i.DOWN, Vector2i.UP, Vector2i.LEFT, Vector2i.RIGHT]
	match _start_side:
		Vector2i.UP:
			_start_pos.y = rec.position.y
			_start_pos.x = range(1,rec.size.x).pick_random()
			rec.position.y += floor(rec.size.y *.5)
			rec.size.y -= rec.position.y
			sides[sides.find(Vector2i.UP)]=Vector2i.DOWN
		Vector2i.DOWN:
			_start_pos.y = rec.end.y
			_start_pos.x = range(1,rec.size.x).pick_random()
			rec.size.y /= 2
			sides[sides.find(Vector2i.DOWN)]=Vector2i.UP
		Vector2i.LEFT:
			_start_pos.x = rec.end.x
			_start_pos.y = range(1,rec.size.y).pick_random()
			rec.size.x /= 2
			sides[sides.find(Vector2i.LEFT)]=Vector2i.RIGHT
		Vector2i.RIGHT:
			_start_pos.x = rec.position.x
			_start_pos.y = range(1,rec.size.y).pick_random()
			rec.position.x += floor(rec.size.x *.5)
			rec.size.x -= rec.position.x
			sides[sides.find(Vector2i.RIGHT)]=Vector2i.LEFT
		
	PathSweeperCellInfo.set_start(get_cell_from_pos(_start_pos))
	
	match sides.pick_random(): # sides.pick_random():
		Vector2i.UP:
			_end_pos.y = rec.position.y
			_end_pos.x = rec.position.x +  range(1,rec.size.x).pick_random()
			_start_side = Vector2i.DOWN
		Vector2i.DOWN:
			_end_pos.y = rec.end.y
			_end_pos.x = rec.position.x +  range(1,rec.size.x).pick_random()
			_start_side = Vector2i.UP
		Vector2i.LEFT:
			_end_pos.x = rec.end.x
			_end_pos.y = rec.position.y +  range(1,rec.size.y).pick_random()
			_start_side = Vector2i.RIGHT
		Vector2i.RIGHT:
			_end_pos.x = rec.position.x
			_end_pos.y = rec.position.y +  range(1,rec.size.y).pick_random()
			_start_side = Vector2i.LEFT
			
		
	PathSweeperCellInfo.set_end(get_cell_from_pos(_end_pos))

func _populate_extra_walls() -> void:
	var canidates : Array[PathSweeperCellInfo]
	for row : Array in get_cells_grid():
		for cell : PathSweeperCellInfo in row:
			if !cell.is_danger_blocked(): # cell.is_path() and !cell.is_door():
				canidates.append(cell)
				#cell._is_danger = true
	canidates.shuffle()
	var _count := 0
	while !canidates.is_empty() and _count < _extra_wall_count:
		if __try_place_boulder(canidates.pop_back()):
			_count += 1

func __try_place_boulder(cell: PathSweeperCellInfo) -> bool:
	cell.set_wall(Utilties.PathSweeper_Alts.BOULDER)
	for each_n in cell.get_map_neighbors():
		if each_n.get_danger_count() > _danger_neighbors:
			cell.set_wall(Utilties.PathSweeper_Alts.NA)
			return false
	if !PathSweeperCellInfo.has_valid_path():
		cell.set_wall(Utilties.PathSweeper_Alts.NA)
		return false
	return true

func _populate_danger() -> void:
	var canidates : Array[PathSweeperCellInfo]
	for row : Array in get_cells_grid():
		for cell : PathSweeperCellInfo in row:
			if !cell.is_danger_blocked():# if cell.is_path() and !cell.is_door():
				canidates.append(cell)
				#cell._is_danger = true
	canidates.shuffle()
	var _count := 0
	while !canidates.is_empty() and _count < _danger_count:
		if __try_place_danger(canidates.pop_back()):
			_count += 1

func __try_place_danger(cell: PathSweeperCellInfo) -> bool:
	cell.set_is_danger(Utilties.PathSweeper_Alts.DANGER0)
	for each_n in cell.get_map_neighbors():
		if each_n.get_danger_count() > _danger_neighbors:
			cell.set_is_danger(Utilties.PathSweeper_Alts.NA)
			return false
	if !PathSweeperCellInfo.has_valid_path():
		cell.set_is_danger(Utilties.PathSweeper_Alts.NA)
		return false
	return true

func get_cell_from_pos(pos: Vector2i) -> PuzzleCellInfo:
	if Rect2(Vector2i.ZERO, get_grid_size()).has_point(pos):
		return get_cells_grid()[pos.y][pos.x]
	return null
