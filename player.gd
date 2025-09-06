extends CharacterBody2D

var speed = 200.0  # Normal walking speed
var run_speed = 350.0  # Running speed
var player_state = "idle"

func _physics_process(delta: float) -> void:
	# Get input direction (this gives smooth continuous input)
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		# Check if running (holding Shift)
		if Input.is_action_pressed("ui_select"):  # Shift key
			velocity = direction * run_speed
			player_state = "run"
		else:
			velocity = direction * speed
			player_state = "walk"
		
		# Flip sprite based on movement direction
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		elif direction.x > 0:
			$AnimatedSprite2D.flip_h = false
	else:
		# No input - stop and idle
		velocity = Vector2.ZERO
		player_state = "idle"
	
	# Move the character
	move_and_slide()
	play_anim()

func play_anim():
	match player_state:
		"idle":
			$AnimatedSprite2D.play("idle")
		"walk":
			$AnimatedSprite2D.play("walk")
		"run":
			$AnimatedSprite2D.play("run")
