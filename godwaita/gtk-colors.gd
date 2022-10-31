extends Control


const IMG_RECOLOR_KEY = 'accent_color'
const IMAGES = {
	'CheckBox': [
		'checked', 'checked_disabled', 'radio_checked',
		'radio_checked_disabled'
	],
	'CheckButton': [
		'on', 'on_disabled'
	]
}
const BOX_PROPS = {
	'window_bg_color': [
		['Panel', 'panel', ['bg_color']],
		['TabContainer', 'panel', ['bg_color']],
		['WindowDialog', 'panel', ['bg_color']]
	],
	'accent_color': [
		['ProgressBar', 'fg', ['bg_color']],
		['VSlider', 'slider', ['bg_color']],
		['HSlider', 'slider', ['bg_color']]
	],
	'card_bg_color': [
		['PanelContainer', 'panel', ['bg_color']],
		['VSeparator', 'separator', ['color']],
		['HSeparator', 'separator', ['color']]
	],
	'view_bg_color': [
		['LineEdit', 'normal', ['bg_color']],
		['TextEdit', 'normal', ['bg_color']],
		['ProgressBar', 'bg', ['bg_color']]
	]
}


# colorizes pixels of tex with color
func colorize_texture(type: String, img: String, col: Color):
	var tex = theme.get_icon(img, type)
	var data = tex.get_data()

	data.lock()
	for x in range(data.get_width()):
		for y in range(data.get_height()):
			# recolor non-grayscale pixels
			var pix = data.get_pixel(x, y)
			if pix.s == 0:
				continue

			# keep value, change hue & sat
			pix.h = col.h
			pix.s = col.s * pix.s
			data.set_pixel(x, y, pix)

	data.unlock()
	tex = ImageTexture.new()
	tex.create_from_image(data)
	theme.set_icon(img, type, tex)


# sets multiple color props of type->box to value
func set_box_props(type: String, box: String, props: Array, value: Color):
	var stylebox = theme.get_stylebox(box, type)
	for prop in props:
		stylebox.set(prop, value)

	theme.set_stylebox(box, type, stylebox)


# changes theme colors based on user's gtk.css
func update_theme_colors():
	# try to read gtk.css
	var file = File.new()
	var path = OS.get_environment('XDG_CONFIG_HOME') + '/gtk-3.0/gtk.css'
	var ret_code = file.open(path, File.READ)
	if ret_code != OK:
		push_warning('Failed to read gtk.css: ERROR ' + str(ret_code))
		return

	# parse gtk.css
	for line in file.get_as_text().split('\n'):
		if not (line.begins_with('@define-color ') and 'rgb' in line):
			continue

		# convert rgb(); or rgba(); to csv
		var parts = line.replace('@define-color ', '').split(' rgb')
		var key = parts[0]
		var csv = parts[1].rstrip(');').lstrip('a(').replace(' ', '')

		# get rgb from csv (ignore possible alpha)
		var values = csv.split(',')
		var r = int(values[0])
		var g = int(values[1])
		var b = int(values[2])

		# recolor images
		if key == IMG_RECOLOR_KEY:
			for type in IMAGES:
				for img in IMAGES[type]:
					colorize_texture(type, img, Color8(r, g, b))

		# recolor appropriate boxes
		for c in BOX_PROPS:
			if c == key:
				for item in BOX_PROPS[c]:
					set_box_props(item[0], item[1], item[2], Color8(r, g, b))

				break


func _ready():
	update_theme_colors()
