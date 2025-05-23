extends Control

# Settings variables
var master_volume: float = 1.0
var music_volume: float = 1.0
var sfx_volume: float = 1.0
var fullscreen: bool = false

@onready var master_slider = $VolumeSettings/MasterVolumeContainer/MasterVolume/MasterSlider
@onready var music_slider = $VolumeSettings/MusicVolumeContainer/MusicVolume/MusicSlider
@onready var sfx_slider = $VolumeSettings/SFXVolumeContainer/SFXVolume/SFXSlider
@onready var fullscreen_toggle = $DisplaySettings/FullScreenContainer/FullScreen/FullscreenToggle

var pause_menu = null
var is_from_pause_menu = false

func _ready():
	print("Options pressed")

	call_deferred("_set_mouse_visible")  # << important
	load_settings()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	#process_mode = Node.PROCESS_MODE_ALWAYS
	
	#if master_slider: master_slider.value_changed.connect(_on_master_volume_changed)
	#if music_slider: music_slider.value_changed.connect(_on_music_volume_changed)
	#if sfx_slider: sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	#if fullscreen_toggle: fullscreen_toggle.toggled.connect(_on_fullscreen_toggled)
	if master_slider:
		master_slider.value_changed.connect(_on_master_volume_changed)
	if music_slider:
		music_slider.value_changed.connect(_on_music_volume_changed)
	if sfx_slider:
		sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	if fullscreen_toggle:
		fullscreen_toggle.toggled.connect(_on_fullscreen_toggled)

	
	$BackButton.pressed.connect(_on_back_pressed)
	
# Load saved settings
	load_settings()
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _set_mouse_visible():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func set_pause_menu(pause_menu_ref):
		pause_menu = pause_menu_ref
		is_from_pause_menu = true
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		

func _on_back_pressed():
	# Returns to the title screen
	if is_from_pause_menu:
		queue_free()
		pause_menu.set_paused(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

	call_deferred("_set_mouse_visible")

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _on_master_volume_changed(value):
	master_volume = value
	# Implement audio bus volume change like line below
	# AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_music_volume_changed(value):
	music_volume = value
	#need to implement music bus volume change
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_sfx_volume_changed(value):
	sfx_volume = value
	#need to implement SFX bus volume change
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_fullscreen_toggled(button_pressed):
	fullscreen = button_pressed
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		

func save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.set_value("video", "fullscreen", fullscreen)
	config.save("user://settings.cfg")


func load_settings():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		master_volume = config.get_value("audio", "master_volume", 1.0)
		music_volume = config.get_value("audio", "music_volume", 1.0)
		sfx_volume = config.get_value("audio", "sfx_volume", 1.0)
		fullscreen = config.get_value("video", "fullscreen", false)
		
		# Applying loaded settings
		$VolumeSettings/MasterSlider.value = master_volume
		$VolumeSettings/MusicSlider.value = music_volume
		$VolumeSettings/SFXSlider.value = sfx_volume
		$DisplaySettings/FullscreenToggle.button_pressed = fullscreen
