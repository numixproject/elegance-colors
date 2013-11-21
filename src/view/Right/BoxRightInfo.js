const BoxRightInfo = new Lang.Class({
        Name: 'BoxRightInfo',
               
        _init: function(storage) {
            this.storage = storage;
            this.storage.connect("UpdateCurrentPresetNumber",  Lang.bind(this, function() {
                this.updateInfo();
            }));

            this.boxInfo = new Gtk.Box({
                orientation: Gtk.Orientation.VERTICAL
            });
            this.boxInfo.add(this.createBoxInfo());
        },

        createBoxInfo: function(){
            let box = new Gtk.Box({
                orientation: Gtk.Orientation.VERTICAL,
                "margin-left": 20,
                "margin-right": 20
            });

            let detailsBox = new Gtk.Box({
                orientation: Gtk.Orientation.VERTICAL
            });
            let detailsLabel = new Gtk.Label({
                label: "Details",
                margin: 2,
                halign: Gtk.Align.CENTER
            });
            detailsBox.add(detailsLabel);

            let preset = this.storage.getCurrentPreset();
            let image = new Gtk.Image({
                "margin-left": 20,
                "margin-right": 20,
                pixbuf: preset.image.pixbuf,
                
                
            });
            let labelTitle = new Gtk.Label({
                label: preset.keyFile.get_string("Preset","title"),
                halign: Gtk.Align.START,
                "margin-left": 20,
                "margin-right": 20

            });
            let labelDescription = new Gtk.Label({
                label: preset.keyFile.get_string("Preset","description"),
                halign: Gtk.Align.START,
                "margin-left": 20,
                "margin-right": 20,
                "justify": Gtk.Justification.FILL,
                "wrap": true,
            });
            
            //add to box 
            box.pack_start(detailsBox, true, true, 0);
            box.pack_start(new Gtk.Separator(), false, false, 10);
            box.pack_start(image, true, true, 10);
            box.pack_start(labelTitle, false, false, 5);
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