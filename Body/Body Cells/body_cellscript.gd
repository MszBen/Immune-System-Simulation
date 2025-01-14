extends RigidBody2D

var infected = false
var dead = false

@export var scene_to_instantiate: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func new_virus():
	var new_scene = scene_to_instantiate.instantiate()
	add_sibling(new_scene)
	new_scene.position = global_position

func virus_death():
	$GPUParticles2D.emitting = true
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("virus death")
	$Area2D.monitorable = false
	$Area2D.monitoring = false
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	new_virus()
	new_virus()
	new_virus()

func _on_area_2d_area_entered(area):
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.set_deferred("disabled", true)
	infected = true
	await get_tree().create_timer(5).timeout
	virus_death()


func _on_animation_player_animation_finished(anim_name):
	queue_free()
