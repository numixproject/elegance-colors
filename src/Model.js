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

const Preset = new Lang.Class({
	Name: 'Preset',

	_init: function(location){
		//Default
		this.defaultKeyFile = "./../data/config/defaultPreset/config.ini";
		this.defaultImageFile = "./../data/config/defaultPreset/screenshot.png";
		
		//keyfile
		this.keyFilePath = location+"/config.ini";
		this.keyFile = null;
		
		//image
		this.imagePath = location+"/screenshot.png";
		this.image = null;
		
		//state
		this.modified = false;

		//load data to preset
		this.readKeyFile();
		this.readImage();
	},

	readKeyFile: function(){
		try {
			this.keyFile = new GLib.KeyFile();
			this.keyFile.load_from_file(this.keyFilePath, GLib.KeyFileFlags.NONE);
		}catch (error){
			print(error+" | path: " + this.keyFilePath +" -> fallback to default KeyFile");
			this.readDefaultKeyFile();
		}
	},

	readImage: function(){
		// image should be for: 16:9, size: 640×360
		try {
			this.image = new Gtk.Image({file: this.imagePath});
			if (this.image.pixbuf == null){
				this.readDefaultImageFile();
			}
		} catch(error){
			print(error+" | path: " + this.imagePath +" -> fallback to default Image");
		}
	},

	readDefaultKeyFile: function(){
		try {
			this.keyFile = new GLib.KeyFile();
			this.keyFile.load_from_file(this.defaultKeyFile, GLib.KeyFileFlags.NONE);
		}catch (error){
			print(error+" | path: " + this.defaultKeyFile);
		}
	},

	readDefaultImageFile: function(){
		try {
			this.image = new Gtk.Image({file: this.defaultImageFile});
		} catch(error){
			print(error+" | path: " + this.imagePath +" -> fallback to default Image");
		}
	},


	print: function(){
		print(this.keyFilePath);
		print(this.keyFile);
		print(this.imagePath);
		print(this.image);
		print();
	}

});