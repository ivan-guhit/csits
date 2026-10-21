extends Node2D

@onready var cutscene = $AnimationPlayer
@onready var sfx = $BG/SFX


func _ready():
	pass

func _on_start_pressed():
	sfx.stream = load("res://assets/sfx/ui/pressed.mp3")
	sfx.play()
	cutscene.play("start")

func _on_quit_pressed():
	sfx.stream = load("res://assets/sfx/ui/pressed.mp3")
	sfx.play()
	get_tree().quit()
	  
func change_scene():
	get_tree().change_scene_to_file("res://scenes/guess_the_word.tscn")


func _on_quit_mouse_entered():
	sfx.stream = load("res://assets/sfx/ui/ui.mp3")
	sfx.play()

func _on_start_mouse_entered():
	sfx.stream = load("res://assets/sfx/ui/ui.mp3")
	sfx.play()
