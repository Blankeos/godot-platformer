extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var SPEED = 50
var chase = false
var dead = false
var health = 2
var current_direction = 1

@onready var player: Player = get_node("../../Player")
@onready var sprite2D: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var anim: AnimationPlayer = get_node("AnimationPlayer")

func _ready():
	sprite2D.play("Idle")

func _physics_process(delta):
	# Gravity for Frog
	if (!dead):
		velocity.y += gravity * delta
	
	# Check player position
	if chase == true and !dead:
		var direction = (player.position - self.position).normalized()
		current_direction = direction
		if direction.x > 0:
			sprite2D.flip_h = true
		else:
			sprite2D.flip_h = false
		velocity.x = direction.x * SPEED
		move_and_slide()
	else:
		velocity.x = 0
		move_and_slide()

func _on_player_detection_body_entered(body: Node2D):
	if body.name == "Player" and !dead:
		anim.play("Jump")
		chase = true

func wow():
	pass

func _on_player_detection_body_exited(body):
	if body.name == "Player" and !dead:
		anim.play("Idle")
		chase = false


func _on_frog_weakpoint_body_entered(body):
	if body.name == "Player" and !dead:
		death(1)

func _on_frog_attack_range_body_entered(body):
	if body.name == "Player":
		hurt()

func hurt():
	if (health <= 0):
		death()
	else:
		health -= 1
		$HitBlink.play("Hit")
		player.hit(3)
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(self, "position", position - Vector2(current_direction.x * 20, 0), 0.3)

func death(cherryPoint: int = 0):
	Game.cherries += cherryPoint
	Utils.saveGame() if cherryPoint > 0 else 0
	chase = false
	dead = true
	anim.play("Death")
	player.shake_camera()
	velocity.x = 0
	($"FrogAttackRange" as Area2D).monitoring = false
	$"MainCollider".call_deferred("set_disabled", true)
	await anim.animation_finished
	self.queue_free()

