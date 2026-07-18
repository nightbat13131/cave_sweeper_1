class_name PressTypeButtonPathSwpeeper extends ButtonEnhanced

signal selected(self_ : PressTypeButtonPathSwpeeper, mouse_mask: int )

@export var _press_type := Utilties.PathSweeper_Alts.MOVE

func _ready() -> void:
	super._ready()
	if button_group:
		set_toggle_mode(true)
	set_pressed_no_signal(get_press_type() == Utilties.PathSweeper_Alts.MOVE)

func set_press_type(press_type : Utilties.PathSweeper_Alts) -> void:
	_press_type = press_type
	match _press_type:
		Utilties.PathSweeper_Alts.MOVE:
			set_tooltip_text("Move")
		Utilties.PathSweeper_Alts.REPELL:
			set_tooltip_text("Anti-Monster Spray")
		Utilties.PathSweeper_Alts.FLAG_DANGER:
			set_tooltip_text("Mark Dangerous")
		Utilties.PathSweeper_Alts.FLAG_SAFE:
			set_tooltip_text("Mark Safe")

func get_press_type() -> Utilties.PathSweeper_Alts: return _press_type

func _on_pressed() -> void: 
	SoundManager.request_sfx_via_enum(Utilties.SFX.BUTTON_PRESS_GAME_CONTROL)
	selected.emit(self, _pressed_button_mask)

func _on_mouse_entered() -> void:
	SoundManager.request_sfx_via_enum(Utilties.SFX.BUTTON_MOUSE_OVER_GAME_CONTROL)
