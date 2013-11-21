const Paned = new Lang.Class({
        Name: 'Paned',
        
        _init: function(storage) {
            
            this.paned = new Gtk.Paned({
                orientation: Gtk.Orientation.HORIZONTAL,
                position: 230
            });
            
            this.boxLeft = new BoxLeft(storage);
            this.boxRight = new BoxRight(storage);

            this.paned.add1(this.boxLeft.getFrame());
            this.paned.add2(this.boxRight.getFrame());

        },

        getPaned: function(){
            return this.paned;
        }
});