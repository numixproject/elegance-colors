const BoxRightControls = new Lang.Class({
        Name: 'BoxRightControls',

        _init: function() {
            this.bottomToolBar = this.createBottomToolBar();
        
        },

        createBottomToolBar: function(){
            let bottomBox = new Gtk.Box();
            let applyButton = new Gtk.Button({
                label: "Apply",
                margin: 5,
                "width-request": 70 

            });

            let image = new Gtk.Image({
                "icon-name": "document-properties-symbolic",
                "icon-size": Gtk.IconSize.SMALL_TOOLBAR
            });
            let configButton = new Gtk.Button({
                image: image,
                margin: 5
            });
            
            let image = new Gtk.Image({
                "icon-name": "edit-delete-symbolic",
                "icon-size": Gtk.IconSize.SMALL_TOOLBAR
            })
            let deleteButton = new Gtk.Button({
                image: image,
                margin: 5
            });


            bottomBox.pack_start(deleteButton, false, false, 0);
            bottomBox.pack_end(applyButton, false, false, 0);
            bottomBox.pack_end(configButton, false, false, 0);


            return bottomBox;
        },

        getBoxControls: function(){
            return this.bottomToolBar;
        }


});