#!/usr/bin/gjs
const Gio = imports.gi.Gio;
const GLib = imports.gi.GLib;
const Lang = imports.lang;

const Storage = new Lang.Class({
	Name: 'Storage',

	_init: function(){
		this.directoryPresets = "./../presets";


		this.test(this.directoryPresets);
	},

	test: function(location){
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
					if (presetFileInfo.get_file_type() === 2){
						print("directory is comming");
					} else {
						print("file is comming");
					}
				
					print(presetPath);

				}
			}
		} catch (error){
			print(error);
		}

	}	
	
});

var storage = new Storage();
