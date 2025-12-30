class_name Clickable extends MarginContainer

# operator (+,-,*,/)
# value, chance to metamorphosize clicks/value (maybe log instead)

var _click_count : int = 0

func _gui_input(event) -> void:
	if event.is_action_pressed("click"):
		self._click_count += 1
		print("self: %x: event: %x: count: %d" % [self.get_instance_id(), event.get_instance_id(), self._click_count])
