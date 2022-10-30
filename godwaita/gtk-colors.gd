extends Control


var colors = {
	'window_bg_color': [
		['Panel', 'panel', ['bg_color']],
		['TabContainer', 'panel', ['bg_color']],
		['WindowDialog', 'panel', ['bg_color']]
	],
	'card_bg_color': [
		['PanelContainer', 'panel', ['bg_color']],
		['VSeparator', 'separator', ['color']],
		['HSeparator', 'separator', ['color']],
	],
	'view_bg_color': [
		['LineEdit', 'normal', ['bg_color']],
		['TextEdit', 'normal', ['bg_color']]
	]
}


# sets multiple color props of type->box to value
func set_box_props(type: String, box: String, props: Array, value: Color):
	var stylebox = theme.get_stylebox(box, type)
	for prop in props:
		stylebox.set(prop, value)

	theme.set_stylebox(box, type, stylebox)


func _ready():
	# try to read gtk.css
	var file = File.new()
	var path = OS.get_environment('XDG_CONFIG_HOME') + '/gtk-3.0/gtk.css'
	var ret_code = file.open(path, File.READ)
	if ret_code != OK:
		push_warning('Failed to read gtk.css: ERROR ' + str(ret_code))
		return

	# parse gtk.css
	for line in file.get_as_text().split('\n'):
		if not line.begins_with('@define-color '):
			continue

		# find the color definitions we want
		line = line.replace('@define-color ', '')
		for c in colors:
			if line.begins_with(c):
				# convert rgb(); or rgba(); to csv
				line = line.rstrip(');').lstrip(c + ' rgba(').replace(' ', '')

				# get rgb from csv (ignore possible alpha)
				var values = line.split(',')
				var r = int(values[0])
				var g = int(values[1])
				var b = int(values[2])

				for item in colors[c]:
					set_box_props(item[0], item[1], item[2], Color8(r, g, b))

				break
