extends ButtonEnhanced

func _on_pressed() -> void:
	prints("press", _left, _right, _pressed_button_bits, 1<<_pressed_button_bits)
	pass
