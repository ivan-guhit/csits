extends Control

@onready var cutscene = $"../../AnimationPlayer"
@onready var narrator = $Narrator
@onready var line_edit = $LineEdit
@onready var w_hidden = $Blank
@onready var timer_l = $Timer
@onready var guess = $Guess
@onready var sfx = $SFX

var timer : float
var rng = RandomNumberGenerator.new()
var choose : int
var finished = false

var level = 1
var max_level = 10

var start_v = "res://assets/sfx/narrator/ur word is.mp3"


var n_voice : Array[String] = [
	"res://assets/sfx/cappucino.mp3",
	"res://assets/sfx/cat.mp3",
	"res://assets/sfx/charge.mp3",
	"res://assets/sfx/entreprenuer.mp3",
	"res://assets/sfx/ettiquete.mp3",
	"res://assets/sfx/friend.mp3",
	"res://assets/sfx/game.mp3",
	"res://assets/sfx/grind.mp3",
	"res://assets/sfx/helicopter.mp3",
	"res://assets/sfx/onomatopoiea.mp3",
	"res://assets/sfx/respect.mp3",
	"res://assets/sfx/town.mp3",
]

var m_words = [
	"cappuccino",
	"cat",
	"charge",
	"entrepreneur",
	"etiquette",
	"friend",
	"game",
	"grind",
	"helicopter",
	"onomatopoeia",
	"respect",
	"Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch."
] #ohhhhhhh he cheatinn, thats bad bro!!!

func get_round_time() -> float:
	if level >= 8:
		return 4.0
	elif level >= 5:
		return 12.0
	elif level >= 4:
		return 20.0
	return 30.0

func add_level():
	if level >= max_level:
		print("you win")
		win()
		return

	level += 1
	print(level)

	line_edit.grab_focus()
	finished = false
	line_edit.clear()
	guess.text = "Your Word is"
	w_hidden.text = "..."
	line_edit.show()
	timer_l.show()

	start_voice()

func lose():
	finished = false
	narrator.stop()
	timer_l.hide()
	line_edit.hide()
	cutscene.play("lose")

func win():
	finished = false
	narrator.stop()
	timer_l.hide()
	line_edit.hide()
	cutscene.play("win")

func hide_letters(index):
	var word = m_words[index]
	w_hidden.text = "_ ".repeat(word.length())

func start_voice():
	finished = false
	timer_l.hide()
	narrator.stream = load(start_v)
	narrator.play()
	await narrator.finished
	rand_voice()

func rand_voice():
	timer = get_round_time()   
	timer_l.show()
	choose = rng.randi_range(0, n_voice.size() - 1)
	narrator.stream = load(n_voice[choose])
	narrator.play()
	hide_letters(choose)
	finished = true

func _ready():
	line_edit.grab_focus()
	start_voice()


func _process(delta):
	if not finished:
		return

	timer -= delta
	timer_l.text = str(snapped(timer, 0.1))

	if timer <= 0:
		guess.text = "Times Up!"
		lose()

func _on_line_edit_text_submitted(new_text):
	if not finished:
		return

	var word = m_words[choose]

	if new_text.strip_edges().to_lower() == word:
		sfx.stream = load("res://assets/sfx/ui/correct.mp3")
		sfx.play()
		finished = false     
		w_hidden.text = word
		guess.text = "Correct!"
		line_edit.hide()
		timer_l.hide()
		await get_tree().create_timer(2.0).timeout
		add_level()
	else:
		sfx.stream = load("res://assets/sfx/ui/wrong.mp3")
		sfx.play()
		finished = false
		w_hidden.text = word
		guess.text = "Wrong!"
		lose()


func _on_try_pressed():
	get_tree().change_scene_to_file("res://scenes/guess_the_word.tscn")


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")


func _on_try_mouse_entered():
	sfx.stream = load("res://assets/sfx/ui/ui.mp3")
	sfx.play()


func _on_exit_mouse_entered():
	sfx.stream = load("res://assets/sfx/ui/ui.mp3")
	sfx.play()
