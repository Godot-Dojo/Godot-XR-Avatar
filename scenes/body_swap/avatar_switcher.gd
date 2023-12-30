extends Node


@export var input_action : String = "ax_button"

@export var avatars : Array[XRAvatarBase]


# The player body
var _body : XRToolsPlayerBody

# The player body avatar driver
var _body_avatar : XRToolsPlayerBodyAvatar

# Current avatar index
var _current_avatar : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	_body = XRToolsPlayerBody.find_instance(self)
	_body_avatar = XRToolsPlayerBodyAvatar.find_instance(self)
	var controller := XRHelpers.get_xr_controller(self)
	if controller:
		controller.button_pressed.connect(_on_button_pressed)


func _on_button_pressed(p_name : String) -> void:
	if p_name == input_action:
		_switch_avatar()


func _switch_avatar() -> void:
	_current_avatar = (_current_avatar + 1) % avatars.size()
	
	var avatar := avatars[_current_avatar]
	_body.teleport(avatar.global_transform)
	_body_avatar.avatar = avatar
