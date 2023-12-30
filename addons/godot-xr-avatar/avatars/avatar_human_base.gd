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

@export var face_meshes : Array[MeshInstance3D] = []

@export var hand_meshes : Array[MeshInstance3D] = []

@export var rig : Node3D

@export var spine_ik : SkeletonIK3D

@export var left_arm_ik : SkeletonIK3D

@export var right_arm_ik : SkeletonIK3D

@export var left_leg_ik : SkeletonIK3D

@export var right_leg_ik : SkeletonIK3D

@export var left_foot_target : Marker3D

@export var right_foot_target : Marker3D

## True if this avatar is being "worn"
@export var worn : bool = false : set = _set_worn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spine_ik.start()
	left_arm_ik.start()
	right_arm_ik.start()
	left_leg_ik.start()
	right_leg_ik.start()


func _process(_delta : float) -> void:
	if not rig:
		return

	# Solve the back angle (law of cosines)
	var head : float = min(height_head, head_target.position.y)
	var p2h := height_head - height_pelvis
	var back_angle := acos((head**2 + p2h**2 - height_pelvis**2) / (2*head*p2h))
	back_angle = min(back_angle, 0.4)

	# Position the armature to handle bending
	rig.position = \
		(Vector3.UP * head) + \
		(Vector3.DOWN * p2h).rotated(Vector3.LEFT, back_angle) + \
		(Vector3.DOWN * height_pelvis)


# Handle setting worn avatar
func _set_worn(p_worn : bool) -> void:
	worn = p_worn

	# Set all visual layers
	if is_inside_tree():
		# Switch face-meshes to layer 2 when worn
		for m in face_meshes:
			m.layers = 2 if p_worn else 1

		# Switch hand meshes invisible when worn
		for m in hand_meshes:
			m.visible = false if p_worn else true
