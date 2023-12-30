extends MultiplayerSceneBase


const AVATAR := preload("res://addons/godot-xr-avatar/avatars/human/female_avatar.tscn")


func _ready():
	super()

	# Subscribe to network events
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func _on_server_disconnected() -> void:
	# On server disconnect switch back to the lobby
	load_scene("res://scenes/network/lobby/network_lobby.tscn")


func _create_avatar(_peer : int) -> XRAvatarBase:
	return AVATAR.instantiate()
