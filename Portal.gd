extends AnimatedSprite


func _ready() -> void:
	play("default")


func _physics_process(delta: float) -> void:
	var items = get_parent().get_node('Items')
	var existing = items.get_used_cells()
	
	if len(existing) == 0:
		$Area.monitorable = true
		show()
