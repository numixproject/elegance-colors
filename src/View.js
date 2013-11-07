const Paned = new Lang.Class({
        Name: 'Paned',
        
        _init: function(storage) {
            
            this.paned = new Gtk.Paned({
                orientation: Gtk.Orientation.HORIZONTAL,
                position: 200
            });
            
            this.boxLeft = new BoxLeft(storage);
            this.boxRight = new BoxRight();

            this.paned.add1(this.boxLeft.getFrame());
            this.paned.add2(this.boxRight.getFrame());

        },

        getPaned: function(){
            return this.paned;
        }
});

const BoxLeft = new Lang.Class({
        Name: 'BoxLeft',
       
        _init: function(storage) {
	       	this.box = new Gtk.Box();

        	this.createListStore(storage);
            this.createTreeView();
            
            this.scrolledWindow = new Gtk.ScrolledWindow({
                "vscrollbar-policy": Gtk.PolicyType.ALWAYS
            });
                            
            this.scrolledWindow.add(this.treeView);                            
            this.box.add(this.scrolledWindow);
        },

        createListStore: function(storage){
            this.listStore = new Gtk.ListStore();
            this.listStore.set_column_types ([
                GObject.TYPE_STRING
            ]);

            for (let i=0; i<storage.presets.length; i++){
               let title = storage.presets[i].content.get_string("Preset","title");
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


        },

        getFrame: function(){
	       	return this.box;
	    }
});

const BoxRight = new Lang.Class({
        Name: 'BoxRight',
               
        _init: function() {
        	this.box = new Gtk.Box({
                orientation: Gtk.Orientation.VERTICAL
            });

            this.centralBox = new Gtk.Box();
            this.label = new Gtk.Label({label: "Test Test Test"});

            this.bottomBox = new Gtk.Box();
            this.applyButton = new Gtk.Button({label: "Apply"});
            
            let image = new Gtk.Image({stock: Gtk.STOCK_PROPERTIES});
            this.configButton = new Gtk.Button({image: image});
            
            let image = new Gtk.Image({stock: Gtk.STOCK_DELETE});
            this.deleteButton = new Gtk.Button({image: image});


            this.bottomBox.pack_start(this.deleteButton, false, false, 10);
            this.bottomBox.pack_end(this.applyButton, false, false, 10);
            this.bottomBox.pack_end(this.configButton, false, false, 10);
            this.centralBox.add(this.label);

            this.box.pack_start(this.centralBox, true, true, 10);
            this.box.pack_end(this.bottomBox, false, false, 10);

	        	        
        },

        getFrame: function(){
	       	return this.box;
	    }
});