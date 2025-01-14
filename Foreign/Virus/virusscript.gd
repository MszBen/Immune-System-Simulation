extends RigidBody2D

@export var speed = 100
var canInfect = true

#velocity = speed * dir


# Called when the node enters the scene tree for the first time.
func _ready():
	canInfect = true
	angular_velocity = 3
	add_constant_force(Vector2(randi_range(-350, 350), randi_range(-350, 350)))
	linear_velocity = Vector2(0, 0)
	$AnimationPlayer.stop()
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(1.5).timeout
	$CollisionShape2D.set_deferred("disabled", false)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area: Area2D):
	var parent: RigidBody2D = area.get_parent()
	if canInfect:
		if parent.infected == false:
			canInfect = false
			linear_velocity = global_position.direction_to(area.global_position) * 500
			$CollisionShape2D.set_deferred("disabled", true)
			$AnimationPlayer.play("enter_cell")
		else:
			return
	else:
		return


func _on_animation_player_animation_finished(anim_name):
	queue_free()
