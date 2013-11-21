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