@tool
extends XRAvatarBase


@onready var wheel : Node3D = $Wheel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	# Roll the wheel
	if _ground_control.length_squared() > 0.01:
		# Calculate rotation axis (orthogonal to control direction)
		var axis := Vector3(
			-_ground_control.y,
			0,
			-_ground_control.x).normalized()

		# Rotate the wheel
		wheel.rotate(axis, _ground_control.length() * delta * (2 * PI * 0.3))
