#!/usr/bin/gjs

const Gio = imports.gi.Gio;
const GLib = imports.gi.GLib; 
const GObject = imports.gi.GObject;
const Lang = imports.lang;
const Gtk = imports.gi.Gtk;
const Gdk = imports.gi.Gdk;
const Signals = imports.signals;

imports.searchPath.unshift('.');
const View = imports.View;
const Model = imports.Model;

const Application = new Lang.Class({
    //A Class requires an explicit Name parameter. This is the Class Name.
    Name: 'Application',

    //create the application
    _init: function() {
        this.application = new Gtk.Application();

       //connect to 'activate' and 'startup' signals to handlers.
       this.application.connect('activate', Lang.bind(this, this._onActivate));
       this.application.connect('startup', Lang.bind(this, this._onStartup));
    },

    //create the UI
    _buildUI: function() {
        //window
        this._window = new Gtk.ApplicationWindow({ application: this.application,
                                                   title: "Elegance-Colors Preferences" });
        this._window.set_default_size(960, 540);
        this._window.window_position = Gtk.WindowPosition.CENTER;
        
        //Model
        this.storage = new Model.Storage();
        
        //View
        this.paned = new View.Paned(this.storage);
        

        this._window.add(this.paned.getPaned());

    },

    //handler for 'activate' signal
    _onActivate: function() {
        //show the window and all child widgets
        this._window.show_all();
    },

    //handler for 'startup' signal
    _onStartup: function() {
        this._buildUI();
    }
});

//run the application
let app = new Application();
app.application.run(ARGV);