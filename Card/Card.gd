extends "res://BaseScripts/state_machine.gd"

signal mouse_entered
signal mouse_exited

var mouse_over
var _mouse_relative = Vector2()  # Relative position of mouse for dragging relative

onready var tex_faceUp = preload("res://Card/textures/card_faceUp.png")
onready var tex_faceDown = preload("res://Card/textures/card_faceDown.png")

var reset_position = Vector2()

var container
var draggable = false

onready var world_parent = get_tree().root.get_child(get_tree().root.get_child_count() - 1)

var init = true

enum ingredient{
	bread,
	lettuce,
	tomato,
	pork,
	butter,
	cheese
}

func _ready():
	if init:
		var area = Area2D.new()
		var col_area = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.extents = self.texture.get_size() * self.scale
		col_area.position = shape.extents + self.offset
		col_area.shape = shape
		
		
		#area.rotation = self.rotation
		area.add_child(col_area)
		add_child(area)
		area.connect("mouse_entered", self, "mouse_entered")
		area.connect("mouse_exited", self, "mouse_exited")
		
		add_to_group("draggables")
		add_to_group("cards")
		set_current_state("face_down")
		init = false

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if GlobalVars.card_holding == self and not event.pressed:
			_drop()
		elif draggable and event.pressed and mouse_over and not GlobalVars.card_holding:
			_mouse_relative = self.global_position - get_global_mouse_position()
			GlobalVars.card_holding = self
			for x in get_tree().get_nodes_in_group("draggables"):
				self.z_index = max(self.z_index, x.z_index)
			self.z_index += 1
			
func mouse_entered():
	mouse_over = true
	emit_signal("mouse_entered")
	GlobalVars.cards_mouse_over.append(self)
	
func mouse_exited():
	mouse_over = false
	emit_signal("mouse_exited")
	if GlobalVars.cards_mouse_over.has(self):
		GlobalVars.cards_mouse_over.remove(GlobalVars.cards_mouse_over.find(self))

func _process(delta):
	if GlobalVars.card_holding == self:
		self.global_position = get_global_mouse_position() + _mouse_relative

func _mouse_in_rect(mouse_pos, rect_pos, size, scale=Vector2(1,1), is_centered=false):
	var ofs = Vector2()
	if is_centered:
		ofs = size*scale/2
	return (
		mouse_pos.x >= rect_pos.x - ofs.x and 
		mouse_pos.x <= rect_pos.x - ofs.x + size.x * scale.x and
		mouse_pos.y >= rect_pos.y - ofs.y and 
		mouse_pos.y <= rect_pos.y - ofs.y + size.y * scale.y
		)

func face_up_enter():
	self.texture = tex_faceUp
	draggable = true

func face_down_enter():
	self.texture = tex_faceDown
	draggable = false

func _drop():
	for inst in get_tree().get_nodes_in_group("drag_slots"):
		if inst.mouse_over:
			inst.add_card(self)
	self.position = reset_position
	GlobalVars.card_holding = null