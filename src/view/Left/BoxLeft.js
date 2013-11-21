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
                            
            //this.scrolledWindow.add(this.treeView);                            
            this.box.pack_start(this.toolBar, false, false, 0)
            this.box.pack_start(new Gtk.Separator(), false, false, 0);
            this.box.pack_start(this.treeView, false, false, 0);
        },

        createListStore: function(){
            let listStore = new Gtk.ListStore();
            listStore.set_column_types ([
                GObject.TYPE_STRING,
                
            ]);

            for (let i=0; i<this.storage.presets.length; i++){
               let title = this.storage.presets[i].keyFile.get_string("Preset","title");
               let description = this.storage.presets[i].keyFile.get_string("Preset","description");
               listStore.set(listStore.append(), [0], ["<b>"+title+"</b>"+"\n"+description]);
            }
            return listStore;
        },

        createTreeView: function(listStore){
            let treeView = new Gtk.TreeView({
                "headers-visible": false,
                "model": listStore,

            });

            treeView.set_model(listStore);
            treeView.set_grid_lines(Gtk.TreeViewGridLines.HORIZONTAL);


            let columnName = new Gtk.TreeViewColumn ({ title: "Themes" });
            let normal = new Gtk.CellRendererText({
                "height": 52,
                "xpad": 5,
                "ellipsize": Pango.EllipsizeMode.END


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
            let image = new Gtk.Image({
                "icon-name": "list-add-symbolic",
                "icon-size": Gtk.IconSize.SMALL_TOOLBAR
            })
            let addPresetButton = new Gtk.Button({
                image: image,
                margin: 5
            });
            let image = new Gtk.Image({
                "icon-name": "document-save-symbolic",
                "icon-size": Gtk.IconSize.SMALL_TOOLBAR
            });
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