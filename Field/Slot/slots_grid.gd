extends Node2D

var slots_amount = Vector2(5,2)
var offset = Vector2(150, 200)

var Slot = preload("res://Field/Slot/Slot.tscn")

func _ready():
	for x in slots_amount.x:
		for y in slots_amount.y:
			var inst = Slot.instance()
			add_child(inst)
			inst.position = Vector2(x,y) * offset
			
