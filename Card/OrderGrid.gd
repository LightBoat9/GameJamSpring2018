extends Node

var order_amount = Vector2(1,3)
var Order = preload("res://Card/Order.tscn")
var offset = Vector2(0, 250.0/2.0)

func _ready():
	for x in order_amount.x:
		for y in order_amount.y:
			var inst = Order.instance()
			add_child(inst)
			inst.position = Vector2(x,y) * offset