@icon("res://Sunny-land-files/Sunny-land-assets-files/PNG/sprites/player/idle/player-idle-1.png")
class_name Player

extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var current_direction: float = 1
var damaged_cooldown: float = 0
var is_attacking: bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim: AnimationPlayer = get_node("AnimationPlayer")
@onready var sprite2D: AnimatedSprite2D = get_node("AnimatedSprite2D")

func _ready():
	anim.play("Idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == -1:
		sprite2D.flip_h = true
		current_direction = -1
	elif direction == 1:
		sprite2D.flip_h = false
		current_direction = 1
		
	if direction and !is_attacking:
		velocity.x = direction * SPEED
		if (velocity.y == 0):
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if (velocity.y == 0 and !is_attacking): anim.play("Idle")
	if (velocity.y > 0) and !is_attacking:
		anim.play("Fall")

	move_and_slide()
	
	if Game.playerHP <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://main.tscn")
	
	if damaged_cooldown > 0:
		damaged_cooldown -= delta

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Z:
			attack(1)
			

func attack(damage=1):
	is_attacking = true
	anim.play("Attack")
	var attack_duration = 0.4
	
	var xTween = get_tree().create_tween()
	var yTween = get_tree().create_tween()
	xTween.set_trans(Tween.TRANS_CUBIC)
	xTween.tween_property(self, "position:x", position.x + current_direction * 20, attack_duration - 0.2)
	yTween.tween_property(self, "position:y", position.y - 10, attack_duration / 2)
	yTween.chain().tween_property(self, "position:y", position.y + 10, attack_duration / 2)
	xTween.chain().chain().tween_property(self, "position:x", position.x - current_direction * 10, 0.2)
	xTween.tween_callback(__on_attack_finish)

func __on_attack_finish():
	is_attacking = false
	
func hit(damage=1):
	if (damaged_cooldown <= 0):
		damaged_cooldown = 0.7
		Game.playerHP -= damage
		shake_camera(0.2)
		$"HitBlink".play("Hurt")
	
func shake_camera(trauma=0.4):
	get_node("Camera2D").add_trauma(trauma)
