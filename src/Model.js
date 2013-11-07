const Storage = new Lang.Class({
	Name: 'Storage',

	_init: function(){
		this.directoryPresets = "./../data/presets";
		this.presets = [];

		this.loadKeysFromDirectory(this.directoryPresets);
		this.printPresets();
	},

	printPresets: function(){
		for (let i=0; i<this.presets.length; i++){
			print("-> path: \n"+this.presets[i].path+"\n"+
				"-> content: \n"+this.presets[i].content.to_data()+"\n");
		}
	},

	loadKeysFromDirectory: function(location){
		try {
			let directory = Gio.File.new_for_path(location);
			let directoryEnum = directory.enumerate_children("standard::*",
					Gio.FileQueryInfoFlags.NONE,null);
			
			let hasMore = true;
			while (hasMore){
				let presetFileInfo = directoryEnum.next_file(null);
				if (presetFileInfo == null){
					hasMore = false;
				} else {
					let presetPath = directoryEnum.get_container().get_path()+"/"+presetFileInfo.get_name();
					this.presets.push({
						"path": presetPath,
						"content": this.loadKeyFromFile(presetPath),
						"modified": false
					});
				}
			}
		} catch (error){
			print(error);
		}
	},

	loadKeyFromFile: function(location){
		let keyFile = new GLib.KeyFile();
		try {
			keyFile.load_from_file(location, GLib.KeyFileFlags.NONE);
		}catch (error){
			print(error);
		}
		return keyFile;
	},

	writeKeysToDirectory: function(location){

	},

	writeKeyToFile: function(location){

	}
});

var storage = new Storage();
