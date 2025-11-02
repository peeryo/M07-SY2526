extends Control
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression

var expressions := {
	"happy": preload("res://assets/emotion_happy.png"),
	"sad": preload("res://assets/emotion_sad.png"),
	"regular": preload("res://assets/emotion_regular.png")
}

var bodies := {
	"sophia": preload("res://assets/sophia.png"),
	"pink": preload("res://assets/pink.png"),
}

var dialogue_items : Array[Dictionary] = [
	{	"expression": expressions["regular"],
		"text": "I'm learning about [wave]arrays and dictionaries[/wave]. . .",
		"character": bodies["pink"],
	},

	{
		"expression": expressions["sad"],
		"text":". . . it's a little [shake]complicated[/shake]",
		"character": bodies["sophia"]
	},	
	
	{
		"expression": expressions["happy"],
		"text": "Let's see if I got it [b]right:[/b] an array is a [i]list of values[/i]!",
		"character": bodies["pink"],
	},	
	
	{
		"expression": expressions["regular"],
		"text": "Did I get it right? [b][i]Did I?[/i][/b]",
		"character": bodies["sophia"]
	},

	{	
		"expression": expressions["happy"],
		"text": "Hehe! Bye bye~! time for more [tornado freq= 3.0][rainbow val=1.0]learning[/rainbow][/tornado]",
		"character": bodies["pink"]
	}
]

var current_item_index := 0

func show_text() -> void:
	var current_item := dialogue_items[current_item_index]
	rich_text_label.text = current_item["text"]
	expression.texture = current_item["expression"]
	body.texture = current_item["character"]
	
	rich_text_label.visible_ratio = 0.0
	var tween := create_tween()
	var text_appearing_duration : float = current_item["text"].length() / 30.0
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_offset
	audio_stream_player.play(sound_start_position)
	tween.finished.connect(audio_stream_player.stop)
	slide_in()
	next_button.disabled = true
	tween.finished.connect(func() -> void:
		next_button.disabled = false
		)
	
func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)
	
func advance():
	current_item_index += 1
	if current_item_index == dialogue_items.size():
		get_tree().quit()
	else:
		show_text()
		
func slide_in() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	body.position.x = 200.0
	tween.tween_property(body, "position:x", 0.0, 0.3)
	body.modulate.a = 0.0
	tween.parallel().tween_property(body, "modulate:a", 1.0, 0.2)
	
