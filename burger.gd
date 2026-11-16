extends Area2D

signal collect_signal

func _ready() -> void:
	add_to_group("burger")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("is_player"):
		collect_signal.emit()
		get_parent().get_parent().queue_free()
