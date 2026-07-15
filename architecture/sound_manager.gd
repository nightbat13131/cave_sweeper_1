class_name SoundManager extends Node

@export_category("UI Sounds")
@export var sound_sfx_changed : AudioStream 
@export var button_pressed : AudioStream
@export var button_hovered : AudioStream
@export var screen_opening : AudioStream
@export var screen_closing : AudioStream

@export_category("GameControl Sounds")
@export var control_pressed : AudioStream
@export var control_hovered : AudioStream
@export var new_floor_sfx : AudioStream

@export_category("Player Sounds")
@export var died_sfx : AudioStream
@export var hurt_sfx : AudioStream
@export var walk_path_sfx : AudioStream
@export var walk_wall_sfx : AudioStream
@export var use_spray_useful_sfx : AudioStream
@export var use_spray_waste_sfx : AudioStream
@export var gain_loot_sfx : AudioStream

#@onready var mute_all: ButtonSelf = %MuteAll

@onready var h_slider_master_volume: HSlider = %MasterSound
@onready var h_slider_music_volume: HSlider = %MusicSound
@onready var h_slider_sfx_volume: HSlider = %SFXSound
@onready var h_sliders : Array[HSlider] = [h_slider_master_volume, h_slider_music_volume, h_slider_sfx_volume]

@onready var bg_music: AudioStreamPlayer = %AudioStreamPlayer_BGMusic_Playing
@onready var bg_music_game_over: AudioStreamPlayer = %AudioStreamPlayer_BGMusic_GameOver

@onready var sfx_players: Node = %SFXPlayers

@onready var _master_index := AudioServer.get_bus_index(&"Master")
@onready var _music_index := AudioServer.get_bus_index(&"Music")
@onready var _sfx_index := AudioServer.get_bus_index(&"Effects")

var _sfx_player_index := 0: 
	set(value): _sfx_player_index = value % sfx_players.get_child_count()

static var _current_manager : SoundManager

func _ready() -> void:
	if _current_manager == null:
		_current_manager = self
	else: 
		printerr("SoundManager mad about there already being a SoundManager, singleton idea failed. Me: " , str(self), " Current: " , str(_current_manager))
	#_set_values(null)
	#mute_all.toggled.connect(_on_mute_change)
	h_slider_master_volume.value_changed.connect(_on_master_volume_change)
	h_slider_music_volume.value_changed.connect(_on_music_volume_change)
	h_slider_sfx_volume.value_changed.connect(_on_sfx_volume_change)
	_set_values(SaveFileResource.new())

func _on_master_volume_change(new_percent: float) -> void: AudioServer.set_bus_volume_db(_master_index, linear_to_db(new_percent))

func _on_music_volume_change(new_percent: float) -> void: AudioServer.set_bus_volume_db(_music_index, linear_to_db(new_percent))

func _on_sfx_volume_change(new_percent: float) -> void: 
	AudioServer.set_bus_volume_db(_sfx_index, linear_to_db(new_percent))
	SoundManager.request_sfx.bind(sound_sfx_changed).call_deferred()

#func _on_mute_change(is_mute: bool) -> void: AudioServer.set_bus_mute(_master_index, is_mute)


static func request_sfx_via_enum(enum_: Utilties.SFX, pitch := 1.0) -> void:
	if _current_manager:
		_current_manager._request_sfx_via_enum(enum_, pitch)

## For scripts that trigger sounds 
func _request_sfx_via_enum(enum_: Utilties.SFX, pitch : float) -> void:
	var sound : AudioStream
	match enum_:
		Utilties.SFX.BUTTON_PRESS_SETTINGS:
			sound = button_pressed
		Utilties.SFX.BUTTON_MOUSE_OVER_SETTINGS:
			sound = button_hovered
		
		Utilties.SFX.BUTTON_PRESS_GAME_CONTROL:
			sound = control_pressed
		Utilties.SFX.BUTTON_MOUSE_OVER_GAME_CONTROL:
			sound = control_hovered
		
		Utilties.SFX.CLIMB_DEEPER:
			sound = new_floor_sfx
		
		Utilties.SFX.SPRAY_GOOD:
			sound = use_spray_useful_sfx
		Utilties.SFX.SPRAY_WASTED:
			sound = use_spray_waste_sfx
		
		Utilties.SFX.PICKUP_LOOT:
			sound = gain_loot_sfx
		
		Utilties.SFX.WALK_CLEAR:
			sound = walk_path_sfx
		Utilties.SFX.WALK_WALL:
			sound = walk_wall_sfx
		
		Utilties.SFX.DIED:
			sound = died_sfx
		Utilties.SFX.HURT:
			sound = hurt_sfx
		
		_:
			prints("no sound enum found", enum_)
			return
	_request_sfx(sound, pitch)

static func request_sfx(sound: AudioStream, pitch := 1.0) -> void: 
	if sound:
		if _current_manager: # may be missing while testing scenes
			_current_manager._request_sfx(sound, pitch)

func _request_sfx(sound: AudioStream, pitch: float) -> void:
	pitch += randf_range(-.15,.15)
	var target_player = sfx_players.get_child(_sfx_player_index) as AudioStreamPlayer
	_sfx_player_index += 1
	target_player.stop()
	target_player.set_stream(sound)
	target_player.set_pitch_scale(pitch)
	if target_player.is_inside_tree():
		target_player.play()

static func request_music(music_type: Utilties.MUSIC) -> void:
	if _current_manager:
		_current_manager._request_music(music_type)

func _request_music(music_type: Utilties.MUSIC) -> void:
	var current : AudioStreamPlayer
	var next : AudioStreamPlayer
	if music_type == Utilties.MUSIC.GAME_ACTIVE:
		current = bg_music_game_over
		next = bg_music
	elif music_type == Utilties.MUSIC.GAME_OVER:
		current = bg_music
		next = bg_music_game_over
	if current.is_playing(): # fade out
		var current_tween = get_tree().create_tween()
		current_tween.tween_method(
		current.set_volume_db,
		current.get_volume_db, #linear_to_db(0), 
		-80.0 ,# linear_to_db(1.0), 
		1.0
		)
		current_tween.tween_callback(current.stop)
		pass
	var next_tween := get_tree().create_tween()
	next.set_volume_db(-80.0)
	next.play()
	next_tween.tween_method(
		next.set_volume_db,
		-80.0, #linear_to_db(0), 
		0.0 ,# linear_to_db(1.0), 
		1.0
		)
	
	

#static func pitch_from_range(delta := 0.5) -> float: return randf_range(1.0- delta, 1.0 + delta)


func _set_values(data: SaveFileResource) -> void:
	if data == null:
		data = SaveFileResource.new()
	#mute_all.set_pressed(data.sound_mute_all)
	#_on_mute_change(data.sound_mute_all)
	h_slider_master_volume.set_value(data.sound_master)
	h_slider_music_volume.set_value(data.sound_music)
	## setting differetnly becuse the normal method plays a sound when the games loads
	h_slider_sfx_volume.set_value_no_signal(data.sound_sfx) 
	AudioServer.set_bus_volume_db(_sfx_index, linear_to_db(data.sound_sfx))



#region SaveLoad

static func load_from_save_data(data: SaveFileResource) -> void:
	if !_current_manager:
		push_error("No _current_manager in SoundManager")
		return
	_current_manager._set_values(data)
	_current_manager.audio_stream_player_bg_music.play(0.0)

static func save_to_data(data: SaveFileResource) -> void: 
	if !_current_manager:
		push_error("No _current_manager in SoundManager")
		return 
	if data == null:
		push_error("SoundManager: No save resource provided ")
		return
	data.sound_mute_all = _current_manager.mute_all.is_pressed()
	data.sound_master = _current_manager.h_slider_master_volume.get_value()
	data.sound_music = _current_manager.h_slider_music_volume.get_value()
	data.sound_sfx = _current_manager.h_slider_sfx_volume.get_value()

#endregion 
