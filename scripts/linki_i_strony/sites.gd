extends Control

func _ready() -> void:
	#self.vbox = $SitesList/SitesVBox
	sites_generator.regenerate.connect(generate_new_record)
	generate_new_record()

func generate_new_record() -> void:
	#for child in self.vbox.get_children():
		#self.vbox.remove_child(child)
	print("teraz generowanie")
	sites_generator.load_and_generate_records()
	print("po generowaniu")
	sites_generator.load_and_generate_records()
