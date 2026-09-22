extends Node2D
@export var leaf_scene : PackedScene
@export var acorn_scene : PackedScene

var spawn_x = 800.0
var spawn_y = -150.0
var score = 0
var target = 10
var current_level = 1

@onready var score_label = $ScoreLabel
@onready var spawn_timer = $SpawnTimer

func _on_spawn_timer_timeout():
	var item
	
	if current_level == 1:
		item = leaf_scene.instantiate()
	else:
		item = acorn_scene.instantiate()
	item.position = Vector2(
		spawn_x + randf_range(-1000, 75), spawn_y
	)
	add_child(item)
	item.area_entered.connect(_on_leaf_caught.bind(item))

func _on_leaf_caught(area, caught_item):
	if area.name == "CatchArea":
		if current_level == 2 and caught_item.is_rotten:
			caught_item.queue_free()
			score_label.text = "🌰 Yuck! Rotten acorn!"
			await get_tree().create_timer(1.0).timeout
			score_label.text = "🌰 Acorns: %d / 8" % score
			return
		caught_item.queue_free()
		score += 1
		if current_level == 1:
			score_label.text = "🍁 Leaves: %d / 10" % score
		else:
			score_label.text = "🌰 Acorns: %d / 8" % score
		if score >= target:
			level_complete()

func level_complete():
	get_node("SpawnTimer").stop()
	if current_level == 1:
		score_label.text = "🍁 You collected the leaves! 🎉 Time for acorns."
		await get_tree().create_timer(2.0).timeout
		start_level2()
	else:
		show_ending()

func show_ending():
	var tween = create_tween()
	tween.tween_property(
		$ColorRect, "color", Color("#2C1810"), 2.0
	)
	await tween.finished
	$EndingLabel.visible = true
	$EndingLabel.text = "🐿️ Acorn Haven is warm\nand ready for winter!\n\n🍂 Well done! 🍂"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func start_level2():
	current_level = 2
	score = 0
	target = 8
	$ColorRect.color = Color("#4A6FA5")
	score_label.text = "🌰 Acorns: 0/8"
	$SpawnTimer.wait_time = 0.9
	$SpawnTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
