const Storage = new Lang.Class({
	Name: 'Storage',

	_init: function(){
		this.directoryPresets = "./../presets";
		this.currentPresetFile = "./../current.ini";

		this.presets = [];
		this.currentPresetNumber = 0;
		
		this.loadPresetsFromDirectory(this.directoryPresets);



		Signals.addSignalMethods(this);
		
		this.connect("UpdateCurrentPresetNumber",  Lang.bind(this, function() {
        	
        }));
		
				
	},


	printPresets: function(){
		for (let i=0; i<this.presets.length; i++){
			print("-> path: \n"+this.presets[i].path+"\n"+
				"-> keyFileData: \n"+this.presets[i].keyFile.to_data()+"\n");
		}
	},

	setCurrentPresetNumber: function(number){
		this.currentPresetNumber = number;
		this.emit("UpdateCurrentPresetNumber");
	},

	getCurrentPresetNumber: function(){
		return this.currentPresetNumber;
	},

	getCurrentPreset: function(){
		return this.presets[this.currentPresetNumber];
	},

	createPreset: function(name){
		let fileName = name;
		let k = 0;
		for (let i=0; i<this.presets.length; i++){
			if (this.presets[i].path === (directoryPresets+"/"+fileName+".ini")){
				if (k == 0){
					fileName = fileName + "_";
				} else {
					fileName = srt.substring(0,(fileName.length-2));
				}
				fileName = fileName + k;
				k = k + 1;
			}

		}

		let newKeyFile = new GLib.KeyFile.load_from_data("");

		this.presets.push({
			path: (this.directoryPresets+"/"+fileName+".ini"),
			keyFile: newKeyFile,
			modified: true
		});

		return this.presets.length-1;
	
	},

	loadPresetsFromDirectory: function(location){
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
					
					this.presets.push({
						path: presetPath,
						keyFile: this.loadKeysFromFile(presetPath),
						modified: false
					});
				}
			}
		} catch (error){
			print(error);
		}
	},

	loadKeysFromFile: function(location){
		let keyFile = new GLib.KeyFile();
		try {
			keyFile.load_from_file(location, GLib.KeyFileFlags.NONE);
		}catch (error){
			print(error);
		}
		return keyFile;
	},

	writeKeysToDirectory: function(location){
		for (let i = 0; i<this.presets.lengsth; i++){
			if (this.presets[i].modified === true){
				writeKeysToFile(this.presets[i].path, this.presets[i].data);
			}

		}

	},

	writeKeysToFile: function(location, data){
		let file;
		let fileOutputStream;
		let dataOutputStream;
		try {
			file = new Gio.File.new_for_path(location);
			fileOutputStream = file.replace(null, false, Gio.FileCreateFlags.REPLACE_DESTINATION, null);
			dataOutputStream = new Gio.DataOutputStream({ base_stream: fileOutputStream});
			dataOutputStream.put_string(data,null);
		} catch (error){
			print(error);
		} finally {
			dataOutputStream.close(null);
			fileOutputStream.close(null);
		}

	},

	writeKeysToCurrent: function(number){
		if (this.presets[number].modified === true){
			writeKeysToFile(this.currentPresetFile, this.presets[number].data);
		}
	}
});

const Preset = new Lang.Class({
	Name: 'Preset',

	_init: function(keyFilePath, imagePath)
		//configuration
		this.keyFilePath = keyFilePath;
		this.keyFile = null;
		
		//image
		this.imagePath = imagePath;
		this.image = null;
		
		//state
		this.modified = false;
		this.current = false;

		//load data to preset
		this.keyFile = this.loadKeyFile(this.keyFilePath);
		this.image = this.loadImage(this.imagePath);
	},

	loadKeyFile: function(location){
		let keyFile = new GLib.KeyFile();
		try {
			keyFile.load_from_file(location, GLib.KeyFileFlags.NONE);
		}catch (error){
			print(error);
		}
		return keyFile;
	},

	loadImage: function(location){
		let image = null;
		try {
			image = new Gtk.Image ({ file: location });
		} catch(error){
			print(error);
		}
		return image;
	},

	writeKeyFile: function(){
		let file;
		let fileOutputStream;
		let dataOutputStream;
		try {
			file = new Gio.File.new_for_path(this.keyFilePath);
			fileOutputStream = file.replace(null, false, Gio.FileCreateFlags.REPLACE_DESTINATION, null);
			dataOutputStream = new Gio.DataOutputStream({ base_stream: fileOutputStream});
			dataOutputStream.put_string(this.keyFile.to_data(),null);
		} catch (error){
			print(error);
		} finally {
			dataOutputStream.close(null);
			fileOutputStream.close(null);
		}
	}
});