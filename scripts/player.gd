extends KinematicBody2D

onready var animated_sprite = get_node("sprite")
const GRAVITY = 700
var jump_force: int = -250
var jump_count: int = 0
var speed: int = 100
var velocity = Vector2()

func move():
	velocity.x = 0
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
	if Input.is_action_pressed("ui_right"):
		velocity.x +=  speed

func jump():
	if Input.is_action_just_pressed("ui_up") and jump_count < 1:
		velocity.y = jump_force
		jump_count += 1
	if is_on_floor():
		jump_count = 0
	

func animate(motion):
	is_character_flipped(motion)
	if motion.x != 0 and is_on_floor():
		animated_sprite.play("run")
	elif motion.y != 0 and not is_on_floor():
		if motion.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
	else:
		animated_sprite.play("idle")

func is_character_flipped(motion):
	if motion.x > 0:
		animated_sprite.flip_h = false
	elif motion.x < 0:
		animated_sprite.flip_h = true

func _physics_process(delta):
	move()
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	jump()
	animate(velocity)
