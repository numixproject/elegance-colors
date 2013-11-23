const TopToolBar = new Lang.Class({
        Name: 'TopToolBar',

        _init: function() {
            this.topToolBar = this.createBox();
            
        },

        createBox: function(){
        	let box = new Gtk.Box({
                orientation: Gtk.Orientation.HORIZONTAL
            });

             let image = new Gtk.Image({
                "icon-name": "list-add-symbolic",
                "icon-size": Gtk.IconSize.SMALL_TOOLBAR
            })
            let addPresetButton = new Gtk.Button({
                image: image,
                margin: 5
            });
            let image = new Gtk.Image({
                "icon-name": "document-save-symbolic",
                "icon-size": Gtk.IconSize.SMALL_TOOLBAR
            });
            let savePresetButton = new Gtk.Button({
                image: image,
                margin: 5
            });

            let toolBarLabel = new Gtk.Label({
                label: "Themes",
            });

            box.pack_start(addPresetButton, false, false, 0);
            box.pack_start(toolBarLabel, true, true, 0);
            box.pack_end(savePresetButton, false, false, 0);

            return box;

        },

        getFrame: function(){
        	return this.topToolBar;
        }
 
});