const Storage = new Lang.Class({
	Name: 'Storage',

	_init: function(){
		this.directoryPresets = "./../presets";
		this.currentPreset = "./../current.ini";
		
		this.presets = [];

		this.loadKeysFromDirectory(this.directoryPresets);
		//this.printPresets();

		//this.writeKeysToDirectory();
	},

	printPresets: function(){
		for (let i=0; i<this.presets.length; i++){
			print("-> path: \n"+this.presets[i].path+"\n"+
				"-> content: \n"+this.presets[i].content.to_data()+"\n");
		}
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
			content: newKeyFile,
			modified: true
		});

		return this.presets.length-1;
	
	},

	loadKeysFromDirectory: function(location){
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
						content: this.loadKeysFromFile(presetPath),
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
			writeKeysToFile(this.currentPreset, this.presets[number].data);
		}
	}
});