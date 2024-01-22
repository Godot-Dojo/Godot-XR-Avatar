@tool
class_name XRAvatarHumanBase
extends XRAvatarBase


## XR-Avatar Human Avatar Script
##
## This script extends the [XRAvatarBase] script to include code for managing
## a human avatar with IK driven spine/neck and limbs.
##
## Additionally when the avatar is being worn by a player the script tweaks
## visility and layers so the hands are replaced by the XR hands, and the face
## does not occlude the players vision.


@export var height_pelvis : float = 1.0

@export var height_head : float = 1.6

@export var hand_meshes : Array[MeshInstance3D] = []

@export var rig : Node3D

@export var left_foot_target : Marker3D

@export var right_foot_target : Marker3D


func _process(_delta : float) -> void:
	if not rig:
		return

	# Solve the back angle (law of cosines)
	var head : float = min(height_head, _head_target.position.y)
	var p2h := height_head - height_pelvis
	var back_angle := acos((head**2 + p2h**2 - height_pelvis**2) / (2*head*p2h))
	back_angle = min(back_angle, 0.4)

	# Position the armature to handle bending
	rig.position = \
		(Vector3.UP * head) + \
		(Vector3.DOWN * p2h).rotated(Vector3.LEFT, back_angle) + \
		(Vector3.DOWN * height_pelvis)


# Override _update_worn to hide hand meshes
func _update_worn(p_worn : bool) -> void:
	super(p_worn)

	# Switch hand meshes invisible when worn
	for m in hand_meshes:
		m.visible = false if p_worn else true
