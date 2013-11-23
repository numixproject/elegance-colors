const PresetsView = new Lang.Class({
        Name: 'PresetsView',

       _init: function(storage) {
            this.storage = storage;
            this.box = new Gtk.Box({
                orientation: Gtk.Orientation.VERTICAL
            });

            this.listStore = this.createListStore();
            this.treeView = this.createTreeView(this.listStore);
            this.connectEventChange(this.treeView);
            
            this.scrolledWindow = new Gtk.ScrolledWindow({
                "vscrollbar-policy": Gtk.PolicyType.ALWAYS,
                "hscrollbar-policy": Gtk.PolicyType.NEVER
            });

         
                            
            this.scrolledWindow.add(this.treeView);                            
            this.box.pack_start(this.scrolledWindow, true, true, 0);
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

        getFrame: function(){
            return this.box;
        }

});