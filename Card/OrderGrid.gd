extends Node

var order_amount = Vector2(1,3)
var Order = preload("res://Card/Order.tscn")
var offset = Vector2(0, 250.0/2.0)
var orders = []

func _ready():
	new_orders()
			
func new_orders():
	for x in order_amount.x:
		for y in order_amount.y:
			var inst = Order.instance()
			add_child(inst)
			inst.random_order()
			inst.position = Vector2(x,y) * offset
			inst.reset_position = inst.position
			
func remove_all_orders():
	var dup = orders.duplicate()