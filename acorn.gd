extends Area2D

var speed = 160
var is_rotten = false

# Called when the node enters the scene tree for the first time.
func _ready():
	is_rotten = randf() < 0.25
	if is_rotten:
		modulate = Color(0.3, 0.15, 0.0)
	else:
		modulate = Color(1, 1, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta
	if position.y > 750:
		queue_free()
