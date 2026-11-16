extends Area2D


signal collect_signal

func _on_body_entered(body):
	if body.has_method("is_player"):
		# Remove the collectible
		queue_free()
		# Emit a signal to the main scene
		emit_signal("collect_signal")
