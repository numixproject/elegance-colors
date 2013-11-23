const TopLabelBar = new Lang.Class({
        Name: 'TopLabelBar',

        _init: function() {
            this.topLabelBar = this.createBox();
            
        },

        createBox: function(){
            let detailsBox = new Gtk.Box({
                orientation: Gtk.Orientation.VERTICAL
            });
            let detailsLabel = new Gtk.Label({
                label: "Details",
                margin: 10,
                halign: Gtk.Align.CENTER
            });
            detailsBox.add(detailsLabel);

            return detailsBox;
        	
        },

        getFrame: function(){
        	return this.topLabelBar;
        }
 
});