class_name Game extends Node

const UUID = preload("res://addons/uuid/uuid.gd")

const CLICKABLE = preload("res://Game/clickable.tscn")
const MAX_INIT_VALUE = 10
const RESET_CLICKABLE_WAIT_TIME_SEC = 5.0

@onready var _grid_container = %GridContainer
@onready var _timer = %Timer
@onready var _total_label = %Score
@onready var _timer_label = %TimerLabel

var _score: int = 0
var _rnd: RandomNumberGenerator

var _grid_clickables: Dictionary[String, Clickable] = {}
var _grid_cells: Dictionary[String, GridCell] = {}

var _grid_last_click: Dictionary[String,int] = {}

func _ready() -> void:
	self._rnd = RandomNumberGenerator.new()
	self._rnd.randomize()
	
	self._total_label.text = "%d" % self._score
	
	for i in range(0, 25):
		var uuid = UUID.v4()
		
		var cell = GridCell.new()
		cell.uuid = uuid
		
		var clickable = CLICKABLE.instantiate()
		clickable.with_uuid(uuid)
		clickable.click.connect(self._handle_clickable_click_event)
		
		self._grid_clickables[uuid] = clickable
		self._grid_cells[uuid] = cell
		self._grid_last_click[uuid] = -1
		
		self._reset_cell_clickable(uuid)
		
		self._grid_container.add_child(clickable)
	
	self._timer.timeout.connect(self._handle_timeout)
	self._timer.start(self.RESET_CLICKABLE_WAIT_TIME_SEC)

func _process(_delta: float) -> void:
	var dur_sec = Time.get_ticks_msec() / 1000.0
	var m = int(dur_sec / 60.0)
	var s = dur_sec - m * 60
	self._timer_label.text = '%02d:%02d' % [m, s]

func _handle_clickable_click_event(event: ClickEvent) -> void:
	var source = event.source_uuid
	if not self._grid_clickables.has(source):
		return
	if not self._grid_cells.has(source):
		return
	
	var oper = self._grid_cells[source].oper
	var val = self._grid_cells[source].value
	
	var should_gen_new_oper = self._rnd.randi_range(0, 100) < 50
	if oper == Operator.OperType.ADD:
		self._score += val
	elif oper == Operator.OperType.MULT:
		@warning_ignore("integer_division")
		self._score *= (100 + 10 * val) / 100
		should_gen_new_oper = self._rnd.randi_range(0, 100) < 80
	
	self._total_label.text = "%d" % self._score
	
	if not should_gen_new_oper:
		self._grid_cells[source].value = val + 1
		self._grid_clickables[source] \
			.with_color(self._color_from_value(val + 1))
		return
	
	self._reset_cell_clickable(source)

func _handle_timeout() -> void:
	var now_msec = Time.get_ticks_msec()
	for uuid in self._grid_last_click.keys():
		if now_msec - self._grid_last_click[uuid] < self.RESET_CLICKABLE_WAIT_TIME_SEC:
			continue
		self._reset_cell_clickable(uuid)

func _reset_cell_clickable(uuid: String) -> void:
	if not self._grid_clickables.has(uuid):
		return
	if not self._grid_cells.has(uuid):
		return
	var next_oper = self._random_oper_type()
	var next_val = self._rnd.randi_range(1, self.MAX_INIT_VALUE)
	self._grid_cells[uuid].oper = next_oper
	self._grid_cells[uuid].value = next_val
	self._grid_clickables[uuid] \
		.with_color(self._color_from_value(next_val)) \
		.with_oper(next_oper)

func _color_from_value(value: int) -> Color:
	if value >= 8:
		return Color(0xff4646ff)
	if value >= 6:
		return Color(0xd73535ff)
	if value >= 4:
		return Color(0xffa240ff) 
	return Color(0xffd41dff)

func _random_oper_type() -> Operator.OperType:
	var v = self._rnd.randi_range(1, 100)
	if v <= 10:
		return Operator.OperType.MULT
	return Operator.OperType.ADD
