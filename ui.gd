extends CanvasLayer

@export var level2X := 11300.0
@export var level3X := 26800.0
@export var finishX := 46498.0

@onready var player: CharacterBody2D = $"../player"
@onready var progress: ProgressBar = $Progress
@onready var timeLabel: Label = $TimeLabel
@onready var levelLabel: Label = $LevelLabel
@onready var levelBanner: Label = $LevelBanner
@onready var burgerLabel: Label = $BurgerLabel
@onready var startScreen: Control = $StartScreen
@onready var finishScreen: Control = $FinishScreen
@onready var finishTime: Label = $FinishScreen/Center/Box/FinishTime

var startX := 0.0
var elapsed := 0.0
var running := false
var currentLevel := 0
var burgers := 0
var burgerTotal := 0

func _ready() -> void:
	visible = true
	startX = player.global_position.x
	finishScreen.hide()
	startScreen.show()
	get_tree().paused = true
	$StartScreen/Center/Box/PlayButton.pressed.connect(_on_play)
	$FinishScreen/Center/Box/RestartButton.pressed.connect(_on_restart)
	$StartScreen/Center/Box/PlayButton.grab_focus()
	_connect_burgers.call_deferred()

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
	var level := 1
	if player.global_position.x >= level3X:
		level = 3
	elif player.global_position.x >= level2X:
		level = 2
	if level != currentLevel:
		currentLevel = level
		levelLabel.text = "LEVEL %d" % level
		levelBanner.text = "LEVEL %d" % level
		var tween := create_tween()
		tween.tween_property(levelBanner, "modulate:a", 1.0, 0.25)
		tween.tween_interval(1.2)
		tween.tween_property(levelBanner, "modulate:a", 0.0, 0.6)
	progress.value = clampf((player.global_position.x - startX) / (finishX - startX), 0.0, 1.0) * 100.0
	if player.global_position.x >= finishX:
		running = false
		finishTime.text = "Time: %.1f s   Burgers: %d/%d" % [elapsed, burgers, burgerTotal]
		finishScreen.show()
		get_tree().paused = true
		$FinishScreen/Center/Box/RestartButton.grab_focus()

func _connect_burgers() -> void:
	for b in get_tree().get_nodes_in_group("burger"):
		b.collect_signal.connect(_on_burger)
		burgerTotal += 1
	_update_burgers()

func _on_burger() -> void:
	burgers += 1
	_update_burgers()

func _update_burgers() -> void:
	burgerLabel.text = "BURGERS %d/%d" % [burgers, burgerTotal]
