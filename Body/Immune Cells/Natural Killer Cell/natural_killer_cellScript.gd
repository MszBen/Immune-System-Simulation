extends CharacterBody2D
@export var target: RigidBody2D
@export var speed: int

var bodyCells: Array
var bodyCellsNode: Node2D


func randBodyCell():
	bodyCells = bodyCellsNode.get_children()
	var newTarget = bodyCells.pick_random()
	if newTarget != target:
		return newTarget
	else:
		randBodyCell()

# Called when the node enters the scene tree for the first time.
func _ready():
	bodyCellsNode = $"..".get_child(2)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target == null or target.global_position == null or is_instance_valid(target) == false:
		target = randBodyCell()
		return
	velocity = global_position.direction_to(target.global_position) * speed
	move_and_slide()
	


func _on_area_2d_area_entered(area: Area2D):
	if target in bodyCellsNode.get_children():
		if area.get_parent() == target:
			if area.get_parent().infected == true:
				area.get_parent().order_death()
			target = randBodyCell()
			print(target)
			return
	else:
		target = randBodyCell()
		return
