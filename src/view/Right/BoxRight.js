const BoxRight = new Lang.Class({
        Name: 'BoxRight',

        _init: function(storage) {
            this.box = new Gtk.Frame();

            this.box1 = new Gtk.Box({
               orientation: Gtk.Orientation.VERTICAL
            });

            this.topLabelBar = new TopLabelBar().getFrame();
            this.boxInfo = new BoxRightInfo(storage).getBoxInfo();
            this.boxControls = new BoxRightControls().getBoxControls();

            this.box1.pack_start(this.topLabelBar, false, false, 0);
            this.box1.pack_start(new Gtk.Separator(), false, false, 0);
            this.box1.pack_start(this.boxInfo, true, true, 10);
            this.box1.pack_end(this.boxControls, false, false, 0);

            this.box.add(this.box1);

        },

        getFrame: function(){
            return this.box;
        }


});