extends Control

#@define-color accent_color rgb(140, 170, 238);
#@define-color accent_bg_color rgb(140, 170, 238);
#@define-color accent_fg_color rgb(255, 255, 255);
#@define-color destructive_color rgb(231, 130, 132);
#@define-color destructive_bg_color rgb(231, 130, 132);
#@define-color destructive_fg_color rgb(255, 255, 255);
#@define-color success_color rgb(166, 209, 137);
#@define-color success_bg_color rgb(166, 209, 137);
#@define-color success_fg_color rgb(255, 255, 255);
#@define-color warning_color rgb(229, 200, 144);
#@define-color warning_bg_color rgb(229, 200, 144);
#@define-color warning_fg_color rgb(255, 255, 255);
#@define-color error_color rgb(231, 130, 132);
#@define-color error_bg_color rgb(231, 130, 132);
#@define-color error_fg_color rgb(255, 255, 255);
#@define-color window_bg_color rgb(35, 38, 52);
#@define-color window_fg_color rgb(198, 208, 245);
#@define-color view_bg_color rgb(48, 52, 70);
#@define-color view_fg_color rgb(198, 208, 245);
#@define-color headerbar_bg_color rgb(41, 44, 60);
#@define-color headerbar_fg_color rgb(198, 208, 245);
#@define-color headerbar_border_color rgb(255, 255, 255);
#@define-color headerbar_shade_color rgba(0, 0, 0, 0.36);
#@define-color card_bg_color rgb(48, 52, 70);
#@define-color card_fg_color rgb(198, 208, 245);
#@define-color card_shade_color rgba(0, 0, 0, 0.36);
#@define-color dialog_bg_color rgb(48, 52, 70);
#@define-color dialog_fg_color rgb(198, 208, 245);
#@define-color popover_bg_color rgb(48, 52, 70);
#@define-color popover_fg_color rgb(198, 208, 245);
#@define-color shade_color rgb(0, 0, 0);
#@define-color scrollbar_outline_color rgba(0, 0, 0, 0.36);

var colors = {
	'view_bg_color': [
		['Panel', 'panel', ['bg_color']],
		['TabContainer', 'panel', ['bg_color']]
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
		line = line.lstrip('@define-color ')
		for col in colors:
			if line.begins_with(col):
				# convert rgb(); or rgba(); to csv
				line = line.rstrip(');')
				line = line.replace(', ', ',')
				for s in [col + ' rgb', 'a', '(']:
					line = line.lstrip(s)

				# get rgb from csv (ignore possible alpha)
				var values = line.split(',')
				var r = int(values[0])
				var g = int(values[1])
				var b = int(values[2])

				for item in colors[col]:
					set_box_props(item[0], item[1], item[2], Color8(r, g, b))
