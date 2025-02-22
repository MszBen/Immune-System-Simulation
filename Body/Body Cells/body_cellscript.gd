extends RigidBody2D

var infected = false
var dead = false
var alarmins = false
var virusDeath = false

@export var scene_to_instantiate: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Alarmins.emitting = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alarmins == true:
		$Alarmins.emitting = true
		alarmins = false


func new_virus():
	var new_scene = scene_to_instantiate.instantiate()
	$"..".add_sibling(new_scene)
	new_scene.position = global_position

func order_death():
	virusDeath = false
	$AnimationPlayer.stop()
	$GPUParticles2D.emitting = true
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("virus death")
	$Area2D.monitorable = false
	$Area2D.monitoring = false
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(2).timeout
	queue_free()

func virus_death():
	virusDeath = true
	while virusDeath == true:
		$GPUParticles2D.emitting = true
		alarmins = true
		await get_tree().create_timer(0.5).timeout
		$AnimationPlayer.play("virus death")
		$Area2D.monitorable = false
		$Area2D.monitoring = false
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		if virusDeath == true:
			for i in 10:
				new_virus()
				await get_tree().create_timer(0.1).timeout
		virusDeath = false

func _on_area_2d_area_entered(area):
	if infected == false:
		await get_tree().create_timer(0.1).timeout
		$CollisionShape2D.set_deferred("disabled", true)
		infected = true
		await get_tree().create_timer(15).timeout
		virus_death()


func _on_animation_player_animation_finished(anim_name):
	$Alarmins.emitting = false
	await get_tree().create_timer(5).timeout
	queue_free()
