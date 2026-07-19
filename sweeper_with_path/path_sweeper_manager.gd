class_name PathSweeperManager extends Node

@onready var button_new: Button = %ButtonNew
@onready var label_status: Label = %LabelStatus
@onready var tile_manager: PathSweeper_TileManager = %TileManager
@onready var score_holder: ScoreHolder_PathSweeper = %ScoreHolder
@onready var path_sweeper_control_manager: PathSweeperControlManager = %PathSweeperControlManager
@onready var game_over_screen: PanelContainer = %GameOverScreen
@onready var label_score: Label = %LabelScore

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
	_puzzle.puzzle_complete.connect(_on_game_over)
	score_holder.set_puzzle_info(_puzzle)
	button_new.pressed.connect(_on_new_press)
	button_new.mouse_entered.connect(_on_new_hover)
	_on_new.call_deferred()
	if _context:
		GUIDE.enable_mapping_context(_context)
		if _primary_action:
			_primary_action.triggered.connect(_on_press_action.bind( MOUSE_BUTTON_LEFT))
		if _secondary_action:
			_secondary_action.triggered.connect(_on_press_action.bind(MOUSE_BUTTON_RIGHT))
		if _tertiary_action:
			_tertiary_action.triggered.connect(_on_press_action.bind( MOUSE_BUTTON_MIDDLE))

func _on_new_hover() -> void: SoundManager.request_sfx_via_enum(Utilties.SFX.BUTTON_MOUSE_OVER_SETTINGS)

func _on_new_press() -> void:
	SoundManager.request_sfx_via_enum(Utilties.SFX.BUTTON_PRESS_SETTINGS)
	_on_new()

func _on_new() -> void: if _puzzle: 
	game_over_screen.hide()
	SoundManager.request_music(Utilties.MUSIC.GAME_ACTIVE)
	_puzzle.new_game() 

func _on_game_over(_value: int) -> void: 
	label_score.set_text("Score: {}".format([_puzzle.get_score()], '{}'))
	game_over_screen.show()

func _on_press_action(mouse_mask: int) -> void:
	var pos = tile_manager.get_mouse_cell()
	_instance._puzzle.send_press(pos, _instance._get_press_type(mouse_mask))

func _get_press_type(mouse_mask: int) -> Utilties.PathSweeper_Alts:
	if path_sweeper_control_manager:
		return path_sweeper_control_manager.get_press_type(mouse_mask)
	return Utilties.PathSweeper_Alts.NA

func _on_puzzle_change() -> void: label_status.set_text(_puzzle.get_status_text())

static func get_game_results() -> String:
	return "not connected"
