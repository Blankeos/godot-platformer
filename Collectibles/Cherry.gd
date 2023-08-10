extends Area2D



func _on_body_entered(body):
	if body.name == "Player":
		Game.cherries += 5
		Game.playerHP + 4
		var tween = get_tree().create_tween()
		var tween2 = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "position", position - Vector2(0, 50), 0.4)
		tween2.tween_property(self, "modulate:a", 0, 0.4)
		tween.tween_callback(queue_free)
