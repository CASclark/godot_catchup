extends KinematicBody2D


export var speed = 750
var movement = Vector2()

func bulletInfo(pos,dir):
	rotation = dir
	position = pos
	movement = Vector2(speed,0).rotated(rotation)

func _physics_process(delta):
	#movement.x = speed

	var collision = move_and_collide(movement * delta)
	if collision:
		queue_free()
		
#func _on_VisibilityNotifier2D_screen_exited():
#	queue_free()
