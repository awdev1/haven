extends CanvasLayer

@export var finishX := 11300.0

@onready var player: CharacterBody2D = $"../player"
@onready var progress: ProgressBar = $Progress
@onready var timeLabel: Label = $TimeLabel
@onready var startScreen: Control = $StartScreen
@onready var finishScreen: Control = $FinishScreen
@onready var finishTime: Label = $FinishScreen/Center/Box/FinishTime

var startX := 0.0
var elapsed := 0.0
var running := false

func _ready() -> void:
	visible = true
	startX = player.global_position.x
	finishScreen.hide()
	startScreen.show()
	get_tree().paused = true
	$StartScreen/Center/Box/PlayButton.pressed.connect(_on_play)
	$FinishScreen/Center/Box/RestartButton.pressed.connect(_on_restart)
	$StartScreen/Center/Box/PlayButton.grab_focus()

func _on_play() -> void:
	startScreen.hide()
	elapsed = 0.0
	running = true
	get_tree().paused = false

func _on_restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _process(delta: float) -> void: 
	if not running:
		return
	elapsed += delta
	timeLabel.text = "%.1f s" % elapsed
	progress.value = clampf((player.global_position.x - startX) / (finishX - startX), 0.0, 1.0) * 100.0
	if player.global_position.x >= finishX:
		running = false
		finishTime.text = "Time: %.1f s" % elapsed
		finishScreen.show()
		get_tree().paused = true
		$FinishScreen/Center/Box/RestartButton.grab_focus()
