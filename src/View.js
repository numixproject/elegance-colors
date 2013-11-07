const Paned = new Lang.Class({
        Name: 'Paned',
        
        _init: function(storage) {
            
            this.paned = new Gtk.Paned({orientation: Gtk.Orientation.HORIZONTAL});
            this.paned.position = 200;
            
            this.boxLeft = new BoxLeft(storage);
            this.frameRight = new FrameRight();

            this.paned.add1(this.boxLeft.getFrame());
            this.paned.add2(this.frameRight.getFrame());

        },

        getPaned: function(){
            return this.paned;
        }
});

const BoxLeft = new Lang.Class({
        Name: 'BoxLeft',
       
        _init: function(storage) {
	       	this._frame = new Gtk.Box();

        	this.createListStore(storage);
            this.createTreeView();

            this.createScrollWindow();
		        	        
        },

        createListStore: function(storage){
            this.listStore = new Gtk.ListStore();
            this.listStore.set_column_types ([
                GObject.TYPE_STRING
            ]);

            for (let i=0; i<storage.presets.length; i++){
               let title = storage.presets[i].get_string("Preset","title");
               this.listStore.set(this.listStore.append(), [0], [title]);
            }
        },

        createTreeView: function(){
            this.treeView = new Gtk.TreeView();
            this.treeView.set_model(this.listStore);
            this.treeView.set_headers_visible(false);
            this.treeView.set_hexpand(true);


            let columnName = new Gtk.TreeViewColumn ({ title: "Themes" });

            let normal = new Gtk.CellRendererText();

            columnName.pack_start(normal, true);

            columnName.add_attribute (normal, "text", 0);
            this.treeView.insert_column (columnName, 0);

            this._frame.add(this.treeView);

        },

        createScrollWindow: function(){
            //this.scrolledWindow = new Gtk.ScrolledWindow(null,null);

        },

        getFrame: function(){
	       	return this._frame;
	    }
});

const FrameRight = new Lang.Class({
        Name: 'FrameRight',
               
        _init: function() {
        	this._frame = new Gtk.Frame({label: "Details"});
	        	        
        },

        getFrame: function(){
	       	return this._frame;
	    }
});