extends Node2D

var drag_slot

func _ready():
	self.drag_slot = load("res://Field/Slot/DragSlot.tscn").instance()
	add_child(drag_slot)