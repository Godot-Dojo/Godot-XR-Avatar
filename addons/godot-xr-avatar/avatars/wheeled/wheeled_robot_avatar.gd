@tool
extends XRAvatarBase


@onready var wheel : Node3D = $Wheel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	# Roll the wheel
	if ground_control.length_squared() > 0.01:
		# Calculate rotation axis (orthogonal to control direction)
		var axis := Vector3(
			-ground_control.y,
			0,
			-ground_control.x).normalized()

		# Rotate the wheel
		wheel.rotate(axis, ground_control.length() * delta * (2 * PI * 0.3))
