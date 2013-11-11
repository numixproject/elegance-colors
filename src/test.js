#!/usr/bin/gjs
const Gio = imports.gi.Gio;
const GLib = imports.gi.GLib;
const Gtk = imports.gi.Gtk;
const Lang = imports.lang;

const Storage = new Lang.Class({
	Name: 'Storage',

	_init: function(){
		this.directoryPresets = "./../presets";
		this.presets=[];

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
					if (presetFileInfo.get_file_type() === Gio.FileType.DIRECTORY){
						let preset = new Preset(presetPath);
						//preset.print();
						this.presets.push(preset);
					}
				}
			}
		} catch (error){
			print(error);
		}

	}	
	
});

const Preset = new Lang.Class({
	Name: 'Preset',

	_init: function(location){
		//location
		this.presetPath = location;
		
		//properties
		this.readKeyFile();
		this.readImage();
		
		//state
		this.modified = false;
		
	},

	readKeyFile: function(){
		this.keyFile = null;
		try {
			this.keyFile = new GLib.KeyFile();
			this.keyFile.load_from_file(this.presetPath+"/config.ini", GLib.KeyFileFlags.NONE);
		}catch (error){
			print(error+" | path: " + this.presetPath+"/config.ini" +" -> fallback to default KeyFile");
			this.readDefaultKeyFile();
		}
	},

	readImage: function(){
		try {
			this.image = new Gtk.Image.set_from_file(this.presetPath+"/screenshot.png");
		} catch(error){
			print(error+" | path: " + this.presetPath+"/screenshot.png" +" -> fallback to default Image");
			this.readDefaultImage();
			this.image = null;
		}
	},

	readDefaultKeyFile: function(){
		this.keyFile = null;
		try {
			let file = Gio.File.new_for_path(this.presetPath);
			this.keyFile = new GLib.KeyFile();
			this.keyFile.load_from_file(file.get_parent().get_child("default").get_path()+"/config.ini", GLib.KeyFileFlags.NONE);
		}catch (error){
			print(error+" | path: " + this.presetPath+"/config.ini"+" No default keyFile!!!");
			this.keyFile = null;
		}

	},

	readDefaultImage: function(){
		try {
			let file = Gio.File.new_for_path(this.presetPath);
			this.image = new Gtk.Image ({ file: file.get_parent().get_child("default").get_path()+"/screenshot.png" });
		} catch(error){
			print(error+" | path: " + this.presetPath+"/screenshot.png"+" No default Image!!!");
			this.image = null;
		}
	},

	print: function(){
		print("path: "+ this.presetPath+"/config.ini");
		print(this.keyFile.to_data());
	}

});

var storage = new Storage();
