const BoxRightInfo = new Lang.Class({
        Name: 'BoxRightInfo',
               
        _init: function(storage) {
            this.storage = storage;
            this.storage.connect("UpdateCurrentPresetNumber",  Lang.bind(this, function() {
                this.updateInfo();
            }));

            this.boxInfo = new Gtk.Box({
                orientation: Gtk.Orientation.VERTICAL,
                "margin-left": 40,
                "margin-right": 40
            });
            this.boxInfo.add(this.createBoxInfo());
        },

        createBoxInfo: function(){
            let box = new Gtk.Box({
                orientation: Gtk.Orientation.VERTICAL,
                halign: Gtk.Align.CENTER,
            });

            let preset = this.storage.getCurrentPreset();
            let pixbuf = preset.image.pixbuf;
            // scale image to: 640×360
            pixbuf = pixbuf.scale_simple(640,360,GdkPixbuf.InterpType.BILINEAR);
            let image = new Gtk.Image({
                halign: Gtk.Align.START,
                pixbuf: pixbuf,
                
            });
            

            let labelTitle = new Gtk.Label({
                label: "<b>"+preset.keyFile.get_string("Preset","title")+"</b>",
                halign: Gtk.Align.START,
                "use-markup": true,

            });
            let labelDescription = new Gtk.Label({
                label: preset.keyFile.get_string("Preset","description"),
                halign: Gtk.Align.START,
                "justify": Gtk.Justification.FILL,
                "wrap": true,

            });
            
            //image 
            box.pack_start(image, true, true, 0);
            
            //Text
            box.pack_start(labelTitle, false, false, 0);
            box.pack_start(labelDescription, false, false, 0);

           

        

            return box;

        },

        updateInfo: function(){
            //this.boxInfo.remove(this.boxInfo.get_children()[0]);
            this.boxInfo.get_children()[0].destroy();
            this.boxInfo.add(this.createBoxInfo());
            this.boxInfo.show_all();
          

        },

        getBoxInfo: function(){
	       	return this.boxInfo;
	    }
});