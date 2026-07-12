@abstract class_name ButtonEnhanced extends Button

@export var _left := true
@export var _middle := false
@export var _right := false

var _pressed_button_mask := 0

func _ready() -> void:
	pressed.connect(_on_pressed)
	var bits = 0
	if _left:
		bits = bits | MOUSE_BUTTON_MASK_LEFT
		_pressed_button_mask = MOUSE_BUTTON_MASK_LEFT
	if _middle:
		bits = bits | MOUSE_BUTTON_MASK_MIDDLE
		_pressed_button_mask = MOUSE_BUTTON_MASK_MIDDLE
	if _right:
		bits = bits | MOUSE_BUTTON_MASK_RIGHT
		_pressed_button_mask = MOUSE_BUTTON_MASK_RIGHT
	set_button_mask(bits)
	if (_left as int) + (_right as int) + (_middle as int) > 1:
		gui_input.connect(_on_gui_input)
		_pressed_button_mask = 0

@abstract func _on_pressed() -> void

func _on_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		if event is InputEventMouseButton:
			match event.button_mask:
				MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT:
					_pressed_button_mask = event.button_mask
				_: ## middle press was registring as a middle scoll mask instead of the expected mask
					_pressed_button_mask = MOUSE_BUTTON_MIDDLE
