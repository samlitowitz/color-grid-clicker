class_name GameGrid extends Control

const CLICKABLE = preload("res://Game/clickable.tscn")

@onready var _grid_container = %GridContainer

func _ready() -> void:
	for i in range(0, 25):
		self._grid_container.add_child(CLICKABLE.instantiate())
