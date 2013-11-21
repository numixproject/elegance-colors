const Storage = new Lang.Class({
	Name: 'Storage',

	_init: function(){
		//directory and files location
		this.directoryPresets = "./../data/presets";
		
		this.currentPresetFile = "./../data/config/current.ini";

		//Storage Data
		this.presets = [];
		this.currentPresetNumber = 0;
		this.readPresetsFromDirectory(this.directoryPresets);
		
		//signals
		Signals.addSignalMethods(this);
		this.connect("UpdateCurrentPresetNumber",  Lang.bind(this, function(){
			//to be added
		}));


		
				
	},

	readPresetsFromDirectory: function(location){
		try {
			let directory = Gio.File.new_for_path(location);
			let directoryEnum = directory.enumerate_children("standard::*", Gio.FileQueryInfoFlags.NONE, null);
			
			let hasMore = true;
			while (hasMore){
				let presetFileInfo = directoryEnum.next_file(null);
				if (presetFileInfo == null){
					hasMore = false;
				} else {
					let presetPath = directoryEnum.get_container().get_path()+"/"+presetFileInfo.get_name();
					if (presetFileInfo.get_file_type() === Gio.FileType.DIRECTORY){
						let preset = new Preset(presetPath);
						this.presets.push(preset);
					}
				}
			}
		} catch (error){
			print(error);
		}

	},

	setCurrentPresetNumber: function(number){
		this.currentPresetNumber = number;
		this.emit("UpdateCurrentPresetNumber");
	},

	getCurrentPreset: function(){
		return this.presets[this.currentPresetNumber];
	},

	printPresets: function(){
		for (let i=0; i<this.presets.length; i++){
			this.presets[i].print();
		}
	}


});
