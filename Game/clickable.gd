class_name Clickable extends MarginContainer

signal click(event: ClickEvent)

const OPER_ADD_TEXTURE = preload("res://assets/oper-add.png")
const OPER_MULT_TEXTURE = preload("res://assets/oper-mult.png")

var _uuid: String
var _oper: Operator.OperType
var _color: Color
@onready var _color_rect: ColorRect = %ColorRect
@onready var _texture_rect: TextureRect = %TextureRect

func _ready() -> void:
	self._update_oper()
	self._update_color()

func with_uuid(uuid: String) -> Clickable:
	self._uuid = uuid
	return self

func with_oper(oper: Operator.OperType) -> Clickable:
	self._oper = oper
	if not self._texture_rect:
		return self
	self._update_oper()
	return self

func with_color(color: Color) -> Clickable:
	self._color = color
	if not self._color_rect:
		return self
	self._update_color()
	return self

func _update_oper() -> void:
	if self._oper == Operator.OperType.ADD:
		self._texture_rect.set_texture(self.OPER_ADD_TEXTURE)
	elif self._oper == Operator.OperType.MULT:
		self._texture_rect.set_texture(self.OPER_MULT_TEXTURE)

func _update_color() -> void:
	self._color_rect.color = self._color

func _gui_input(event) -> void:
	if event.is_action_pressed("click"):
		var click_event = ClickEvent.new()
		click_event.source_uuid = self._uuid
		self.click.emit(click_event)
