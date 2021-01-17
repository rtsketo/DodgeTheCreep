extends Area2D

signal hit

export var speed = 400
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else: $AnimatedSprite.stop()
	
	if Input.is_action_just_pressed("ui_accept"):
		if $ShieldCD.is_stopped() && is_visible():
			$ShieldBot.emitting = true
			$ShieldTop.emitting = true
			$Shielded.start()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	if $Shielded.is_stopped():
		hide()  # Player disappears after being hit.
		$ShieldCD.stop()
		emit_signal("hit")
		$CollisionShape2D.set_deferred("disabled", true)

func _shield_expired(): $ShieldCD.start()
func _shield_ready(): $"../HUD".show_message("Ασπίδα!")

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
