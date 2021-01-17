extends RigidBody2D

export var min_speed = 150
export var max_speed = 250

onready var size = .7 * randf() + .3


func _ready():
	$CollisionShape2D.set_scale(Vector2(size, size))
	$AnimatedSprite.set_scale(Vector2(size*.75, size*.75))
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
