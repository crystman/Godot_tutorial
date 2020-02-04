extends Area2D
signal hit

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.
var target = Vector2()
var velocity = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite.play()

func start(pos):
	target = pos
	show()
	$CollisionShape2D.disabled = false

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position

func _process(delta):
	# Move towards the target and stop when close.
	if position.distance_to(target) > 10:
		velocity = (target - position).normalized() * speed
	else:
		velocity = Vector2()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
	else:
		$AnimatedSprite.animation = "none"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = false

func _on_Player_body_entered(body):
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
