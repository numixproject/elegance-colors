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

const BoxLeft = new Lang.Class({
        Name: 'BoxLeft',
       
        _init: function(storage) {
            this.storage = storage;
            this.box = new Gtk.Box({
                orientation: Gtk.Orientation.VERTICAL
            });

            this.listStore = this.createListStore();
            this.treeView = this.createTreeView(this.listStore);
            this.connectEventChange(this.treeView);
            
            this.scrolledWindow = new Gtk.ScrolledWindow({
                "vscrollbar-policy": Gtk.PolicyType.ALWAYS
            });

            this.toolBar = this.createToolBar();
                            
            this.scrolledWindow.add(this.treeView);                            
            this.box.pack_start(this.toolBar, false, false, 0)
            this.box.pack_start(new Gtk.Separator(), false, false, 0);
            this.box.pack_start(this.scrolledWindow, true, true, 0);
        },

        createListStore: function(){
            let listStore = new Gtk.ListStore();
            listStore.set_column_types ([
                GObject.TYPE_STRING
            ]);

            for (let i=0; i<this.storage.presets.length; i++){
               let title = this.storage.presets[i].keyFile.get_string("Preset","title");
               let description = this.storage.presets[i].keyFile.get_string("Preset","description");
               listStore.set(listStore.append(), [0], ["<b>"+title+"</b>"+"\n"+description]);

            }
            return listStore;
        },

        createTreeView: function(listStore){
            let treeView = new Gtk.TreeView();
            treeView.set_model(listStore);
            treeView.set_headers_visible(false);
            treeView.set_hexpand(true);
            treeView.set_grid_lines(Gtk.TreeViewGridLines.HORIZONTAL);


            let columnName = new Gtk.TreeViewColumn ({ title: "Themes" });
            let normal = new Gtk.CellRendererText({
                "height": 52,
                "xpad": 5,

            });
            columnName.pack_start(normal, true);
            columnName.add_attribute (normal, "markup" , 0);
           

            treeView.insert_column(columnName, 0);

            return treeView;
        },

        connectEventChange: function(treeView){
            let selection = treeView.get_selection();
            selection.connect ('changed', Lang.bind (this, this.onSelectionChanged));

        },

        onSelectionChanged: function(){
            let [ isSelected, model, iter ] = this.treeView.get_selection().get_selected();
            let currentPresetNumber = this.listStore.get_path(iter).to_string();
            this.storage.setCurrentPresetNumber(currentPresetNumber)

        },

        createToolBar: function(){
            let toolBar = new Gtk.Box({
                orientation: Gtk.Orientation.HORIZONTAL
            });
            let image = new Gtk.Image({"icon-name": "gtk-add"});
            let addPresetButton = new Gtk.Button({
                image: image,
                margin: 5
            });
            let image = new Gtk.Image({"icon-name": "gtk-save"});
            let savePresetButton = new Gtk.Button({
                image: image,
                margin: 5
            });

            let toolBarLabel = new Gtk.Label({label: "Themes"});

            toolBar.pack_start(addPresetButton, false, false, 0);
            toolBar.pack_start(toolBarLabel, true, true, 0);
            toolBar.pack_end(new Gtk.Separator({orientation: Gtk.Orientation.VERTICAL}), false, false, 0);
            toolBar.pack_end(savePresetButton, false, false, 0);


            return toolBar;
        },

        getFrame: function(){
            return this.box;
        }
});

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

const BoxRightInfo = new Lang.Class({
        Name: 'BoxRightInfo',
               
        _init: function(storage) {
            this.storage = storage;
            this.storage.connect("UpdateCurrentPresetNumber",  Lang.bind(this, function() {
                this.updateInfo();
            }));

            this.boxInfo = new Gtk.Box({
                orientation: Gtk.Orientation.VERTICAL
            });
            this.boxInfo.add(this.createBoxInfo());
        },

        createBoxInfo: function(){
            let box = new Gtk.Box({
                orientation: Gtk.Orientation.VERTICAL,
                "margin-left": 20,
                "margin-right": 20
            });

            let detailsBox = new Gtk.Box({
                orientation: Gtk.Orientation.VERTICAL
            });
            let detailsLabel = new Gtk.Label({
                label: "Details",
                margin: 2,
                halign: Gtk.Align.CENTER
            });
            detailsBox.add(detailsLabel);

            let preset = this.storage.getCurrentPreset();
            let image = new Gtk.Image({
                "margin-left": 20,
                "margin-right": 20,
                pixbuf: preset.image.pixbuf,
                
                
            });
            let labelTitle = new Gtk.Label({
                label: preset.keyFile.get_string("Preset","title"),
                halign: Gtk.Align.START,
                "margin-left": 20,
                "margin-right": 20

            });
            let labelDescription = new Gtk.Label({
                label: preset.keyFile.get_string("Preset","description"),
                halign: Gtk.Align.START,
                "margin-left": 20,
                "margin-right": 20,
                "justify": Gtk.Justification.FILL,
                "wrap": true,
            });
            
            //add to box 
            box.pack_start(detailsBox, true, true, 0);
            box.pack_start(new Gtk.Separator(), false, false, 10);
            box.pack_start(image, true, true, 10);
            box.pack_start(labelTitle, false, false, 5);
            box.pack_start(labelDescription, false, false, 0);

           

        

            return box;

        },

        updateInfo: function(){
            //this.boxInfo.remove(this.boxInfo.get_children()[0]);
            this.boxInfo.get_children()[0].destroy();
            this.boxInfo.add(this.createBoxInfo());
            this.boxInfo.show_all();
          

        },

        getBoxInfo: function(){
	       	return this.boxInfo;
	    }
});

const BoxRightControls = new Lang.Class({
        Name: 'BoxRightControls',

        _init: function() {
            this.bottomToolBar = this.createBottomToolBar();
        
        },

        createBottomToolBar: function(){
            let bottomBox = new Gtk.Box();
            let applyButton = new Gtk.Button({
                label: "Apply",
                "width-request": 80 

            });

            let image = new Gtk.Image({"icon-name": "gtk-properties"});
            let configButton = new Gtk.Button({image: image});
            
            let image = new Gtk.Image({"icon-name": "gtk-delete"});
            let deleteButton = new Gtk.Button({image: image});


            bottomBox.pack_start(deleteButton, false, false, 5);
            bottomBox.pack_end(applyButton, false, false, 5);
            bottomBox.pack_end(configButton, false, false, 5);


            return bottomBox;
        },

        getBoxControls: function(){
            return this.bottomToolBar;
        }


});
