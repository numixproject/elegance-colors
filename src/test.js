#!/usr/bin/gjs
const Lang = imports.lang;
const GLib = imports.gi.GLib;
const Gio = imports.gi.Gio;

const Storage = new Lang.Class({
	Name: 'Storage',

	_init: function(){
		this.directoryPresets = "./../data/presets";
		this.presets = [];

		this.loadKeysFromDirectory(this.directoryPresets);
		this.printPresets();

		this.writeKeyToFile("./test.ini");
	},

	printPresets: function(){
		for (let i=0; i<this.presets.length; i++){
			print("-> path: \n"+this.presets[i].path+"\n"+
				"-> content: \n"+this.presets[i].content.to_data()+"\n"+
				"-> modified: \n"+this.presets[i].modified+"\n");
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
		try {
			let file = Gio.File.new_for_path(location);
			file.replace_contents("Hello, World!")
			/*var fileStream = file.replace(null, false, Gio.FileCreateFlags.NONE, null);
			fileStream.write("gigi are mere");
*/
		} catch (error){
			print(error);
		} finally {
//			fileStream.close();
		}

	}
});

var storage = new Storage();
