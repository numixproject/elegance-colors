const BoxLeft = new Lang.Class({
        Name: 'BoxLeft',
       
        _init: function(storage) {
            this.box = new Gtk.Box({
               orientation: Gtk.Orientation.VERTICAL
            });
            
            this.topToolBar = new TopToolBar().getFrame();
            this.presetsView = new PresetsView(storage).getFrame();

            this.box.pack_start(this.topToolBar, false, false, 0);
            this.box.pack_start(this.presetsView, true, true, 0);
         
        },

       

        getFrame: function(){
            return this.box;
        }
});