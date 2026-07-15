class_name PathSweeperManager extends Node

@onready var button_new: Button = %ButtonNew
@onready var label_status: Label = %LabelStatus
@onready var tile_manager: PathSweeper_TileManager = %TileManager
@onready var score_holder: ScoreHolder_PathSweeper = %ScoreHolder
@onready var path_sweeper_control_manager: PathSweeperControlManager = $HBoxContainer/HBoxContainer2/PathSweeperControlManager


@export var _puzzle: PathSweeper

@export_category("G.U.I.D.E.")
@export var _context : GUIDEMappingContext
@export var _primary_action: GUIDEAction
@export var _secondary_action: GUIDEAction
@export var _tertiary_action: GUIDEAction

@warning_ignore("unused_private_class_variable")
@export var _theme : Variant

static var _instance : PathSweeperManager

func _ready() -> void:
	_instance = self
	assert(_puzzle)
	tile_manager.set_puzzle(_puzzle)
	_puzzle.puzzle_generated.connect(_on_puzzle_change)
	_puzzle.changed.connect(_on_puzzle_change)
	score_holder.set_puzzle_info(_puzzle)
	button_new.pressed.connect(_on_new)
	_on_new.call_deferred()
	#prints(1<<1, 1<<2, 1<<3)
	if _context:
		GUIDE.enable_mapping_context(_context)
		if _primary_action:
			_primary_action.triggered.connect(_on_press_action.bind( MOUSE_BUTTON_LEFT))
		if _secondary_action:
			_secondary_action.triggered.connect(_on_press_action.bind(MOUSE_BUTTON_RIGHT))
		if _tertiary_action:
			_tertiary_action.triggered.connect(_on_press_action.bind( MOUSE_BUTTON_MIDDLE))

func _on_new() -> void: if _puzzle: 
	SoundManager.request_music(Utilties.MUSIC.GAME_ACTIVE)
	_puzzle.new_game() #new_puzzle()

func _on_undo() -> void: if _puzzle: _puzzle.request_undo()

func _on_redo() -> void: if _puzzle: _puzzle.request_redo()

#func _on_puzzle_generated() -> void: _on_puzzle_change()

func _on_press_action(mouse_mask: int) -> void:
	var pos = tile_manager.get_mouse_cell()
	_instance._puzzle.send_press(pos, _instance._get_press_type(mouse_mask))

func _get_press_type(mouse_mask: int) -> Utilties.PathSweeper_Alts:
	if path_sweeper_control_manager:
		return path_sweeper_control_manager.get_press_type(mouse_mask)
	return Utilties.PathSweeper_Alts.NA

func _on_puzzle_change() -> void:
	label_status.set_text(_puzzle.get_status_text())
