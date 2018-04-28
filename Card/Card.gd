extends "res://BaseScripts/state_machine.gd"

var dragging = false

var mouse_over
var _mouse_relative = Vector2()  # Relative position of mouse for dragging relative

onready var tex_faceUp = load("res://Card/textures/placeHolder_faceUp.png")
onready var tex_faceDown = load("res://Card/textures/placeHolder_faceDown.png")

enum ingredient{
	bread,
	lettuce,
	tomato
}

func _ready():
	set_current_state("face_down")

func _input(event):
	if event is InputEventMouseMotion and self.texture:
		mouse_over = _mouse_in_rect(event.global_position, self.global_position, self.texture.get_size(), self.scale, self.centered)
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if dragging and not event.pressed:
			dragging = false
		elif event.pressed and mouse_over:
			_mouse_relative = self.global_position - get_global_mouse_position()
			dragging = true

func _process(delta):
	if dragging:
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

func face_down_enter():
	self.texture = tex_faceDown