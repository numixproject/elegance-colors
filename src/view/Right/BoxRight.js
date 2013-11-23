const BoxRight = new Lang.Class({
        Name: 'BoxRight',

        _init: function(storage) {
            this.box = new Gtk.Box({
                orientation: Gtk.Orientation.VERTICAL
            });

            this.topLabelBar = new TopLabelBar().getFrame();
            this.boxInfo = new BoxRightInfo(storage).getBoxInfo();
            this.boxControls = new BoxRightControls().getBoxControls();

            this.box.pack_start(this.topLabelBar, false, false, 0);
            this.box.pack_start(this.boxInfo, true, true, 0);
            this.box.pack_end(this.boxControls, false, false, 0);

        },

        getFrame: function(){
            return this.box;
        }


});