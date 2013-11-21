const BoxRight = new Lang.Class({
        Name: 'BoxRight',

        _init: function(storage) {
            this.box = new Gtk.Box({
                orientation: Gtk.Orientation.VERTICAL
            });

            this.boxInfo = new BoxRightInfo(storage).getBoxInfo();
            this.boxControls = new BoxRightControls().getBoxControls();

            this.box.pack_start(this.boxInfo, false, false, 10);
            this.box.pack_end(this.boxControls, false, false, 10);

        },

        getFrame: function(){
            return this.box;
        }


});