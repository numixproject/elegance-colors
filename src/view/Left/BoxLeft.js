const BoxLeft = new Lang.Class({
        Name: 'BoxLeft',
       
        _init: function(storage) {
            this.box = new Gtk.Frame();

            this.box1 = new Gtk.Box({
               orientation: Gtk.Orientation.VERTICAL
            });
            
            this.topToolBar = new TopToolBar().getFrame();
            this.presetsView = new PresetsView(storage).getFrame();

            this.box1.pack_start(this.topToolBar, false, false, 0);
            this.box1.pack_start(new Gtk.Separator(), false, false, 0);
            this.box1.pack_start(this.presetsView, true, true, 0);
         
            this.box.add(this.box1);
        },

       

        getFrame: function(){
            return this.box;
        }
});