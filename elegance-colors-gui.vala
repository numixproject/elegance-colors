using Gtk;

class EleganceColorsWindow : ApplicationWindow {

	// General
	ComboBox combobox;

	RadioButton match_wallpaper;
	RadioButton match_theme;
	RadioButton custom_color;

	ColorButton color_button;

	Switch monitor_switch;

	FontButton fontchooser;

	SpinButton selgradient_size;
	SpinButton corner_roundness;
	SpinButton transition_duration;

	string color_value;

	string[] presets = { "" };
	string[] titles = { "None" };

	// Panel
	ColorButton panel_bg_color;
	ColorButton panel_fg_color;
	ColorButton panel_border_color;

	Switch panel_shadow_switch;
	Switch panel_icon_switch;

	SpinButton panel_tint_value;
	SpinButton panel_gradient_value;
	SpinButton panel_corner_value;

	string panel_bg_value;
	string panel_fg_value;
	string panel_border_value;

	// Panel in overview
	ColorButton paneloverview_bg_color;
	ColorButton paneloverview_fg_color;
	ColorButton paneloverview_border_color;

	Switch paneloverview_shadow_switch;

	SpinButton paneloverview_tint_value;
	SpinButton paneloverview_gradient_value;

	string paneloverview_bg_value;
	string paneloverview_fg_value;
	string paneloverview_border_value;

	// Overview
	ColorButton overview_bg_color;
	ColorButton overview_msgbg_color;
	ColorButton overview_msgborder_color;

	SpinButton overview_tint_value;
	SpinButton overview_gradient_value;
	SpinButton overview_iconsize_value;
	SpinButton overview_iconspacing_value;

	string overview_bg_value;
	string overview_msgbg_value;
	string overview_msgborder_value;

	// Dash
	ColorButton dash_bg_color;
	ColorButton dash_fg_color;
	ColorButton dash_border_color;

	Switch dash_shadow_switch;

	SpinButton dash_tint_value;
	SpinButton dash_gradient_value;

	string dash_bg_value;
	string dash_fg_value;
	string dash_border_value;

	// Buttons
	ColorButton button_bg_color;
	ColorButton button_hoverbg_color;
	ColorButton button_activebg_color;
	ColorButton button_fg_color;
	ColorButton button_hoverfg_color;
	ColorButton button_activefg_color;
	ColorButton button_border_color;
	ColorButton button_hoverborder_color;
	ColorButton button_activeborder_color;

	Switch button_bold_switch;

	SpinButton button_gradient_value;

	string button_bg_value;
	string button_hoverbg_value;
	string button_activebg_value;
	string button_fg_value;
	string button_hoverfg_value;
	string button_activefg_value;
	string button_border_value;
	string button_hoverborder_value;
	string button_activeborder_value;

	// Entry
	ColorButton entry_bg_color;
	ColorButton entry_hoverbg_color;
	ColorButton entry_fg_color;
	ColorButton entry_hoverfg_color;
	ColorButton entry_border_color;
	ColorButton entry_hoverborder_color;

	Switch entry_shadow_switch;

	SpinButton entry_gradient_value;

	string entry_bg_value;
	string entry_hoverbg_value;
	string entry_fg_value;
	string entry_hoverfg_value;
	string entry_border_value;
	string entry_hoverborder_value;

	// Menu
	ColorButton menu_bg_color;
	ColorButton menu_fg_color;
	ColorButton menu_border_color;

	Switch menu_shadow_switch;
	Switch menu_arrow_switch;

	SpinButton menu_tint_value;
	SpinButton menu_gradient_value;

	string menu_bg_value;
	string menu_fg_value;
	string menu_border_value;

	// Dialogs
	ColorButton dialog_bg_color;
	ColorButton dialog_fg_color;
	ColorButton dialog_heading_color;
	ColorButton dialog_border_color;

	Switch dialog_shadow_switch;

	SpinButton dialog_tint_value;
	SpinButton dialog_gradient_value;

	string dialog_bg_value;
	string dialog_fg_value;
	string dialog_heading_value;
	string dialog_border_value;

	// Others
	Notebook notebook;

	Button apply_button;

	File config_file;
	File presets_dir_sys;

	KeyFile key_file;

	internal EleganceColorsWindow (EleganceColorsPref app) {
		Object (application: app, title: "Elegance Colors Preferences");

		// Set window properties
		this.window_position = WindowPosition.CENTER;
		this.resizable = false;
		this.border_width = 12;

		// Set window icon
		try {
			this.icon = IconTheme.get_default ().load_icon ("elegance-colors", 48, 0);
		} catch (Error e) {
			stderr.printf ("Failed to load application icon: %s\n", e.message);
		}

		// Prefer dark theme
		// Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;

		// GMenu
		var export_action = new SimpleAction ("export", null);
		export_action.activate.connect (this.export_theme);
		this.add_action (export_action);

		var exsettings_action = new SimpleAction ("exsettings", null);
		exsettings_action.activate.connect (this.export_settings);
		this.add_action (exsettings_action);

		var impsettings_action = new SimpleAction ("impsettings", null);
		impsettings_action.activate.connect (this.import_settings);
		this.add_action (impsettings_action);

		var about_action = new SimpleAction ("about", null);
		about_action.activate.connect (this.show_about);
		this.add_action (about_action);

		var quit_action = new SimpleAction ("quit", null);
		quit_action.activate.connect (this.quit_window);
		this.add_action (quit_action);

		// Set variables
		var config_dir = File.new_for_path (Environment.get_user_config_dir ());
		config_file = config_dir.get_child ("elegance-colors").get_child ("elegance-colors.ini");
		presets_dir_sys = File.parse_name ("/usr/share/elegance-colors/presets");

		key_file = new KeyFile ();

		// Methods
		init_process ();
		create_widgets ();
	}

	void init_process () {

		var home_dir = File.new_for_path (Environment.get_home_dir ());

		if (!home_dir.get_child (".themes/elegance-colors/gnome-shell/gnome-shell.css").query_exists () || !config_file.query_exists ()) {
			try {
				Process.spawn_command_line_async("elegance-colors");
			} catch (Error e) {
				stderr.printf ("Failed to run process: %s\n", e.message);
			}
			try {
				key_file.load_from_file (presets_dir_sys.get_child ("default.ini").get_path (), KeyFileFlags.NONE);
			} catch (Error e) {
				stderr.printf ("Failed to load preset: %s\n", e.message);
			}
		}
	}


	void export_theme () {

		var exportdialog = new FileChooserDialog ("Export theme", this,
								FileChooserAction.SAVE,
								Stock.CANCEL, ResponseType.CANCEL,
								Stock.SAVE, ResponseType.ACCEPT, null);

		var filter = new FileFilter ();
		filter.add_pattern ("*.zip");

		exportdialog.set_filter (filter);
		exportdialog.set_current_name ("Elegance Colors Custom.zip");
		exportdialog.set_do_overwrite_confirmation(true);

		if (exportdialog.run () == ResponseType.ACCEPT) {
			string theme_path = exportdialog.get_file ().get_path ();

			try {
				Process.spawn_command_line_sync("elegance-colors export \"%s\"".printf (theme_path));
			} catch (Error e) {
				stderr.printf ("Failed to export theme: %s\n", e.message);
			}
		}

		exportdialog.close ();
	}

	void export_settings () {

		var exportsettings = new FileChooserDialog ("Export settings", this,
								FileChooserAction.SAVE,
								Stock.CANCEL, ResponseType.CANCEL,
								Stock.SAVE, ResponseType.ACCEPT, null);

		var filter = new FileFilter ();
		filter.add_pattern ("*.ini");

		exportsettings.set_filter (filter);
		exportsettings.set_current_name ("elegance-colors-exported.ini");
		exportsettings.set_do_overwrite_confirmation(true);

		if (exportsettings.run () == ResponseType.ACCEPT) {
			try {
				var exportpath = File.new_for_path (exportsettings.get_file ().get_path ());

				config_file.copy (exportpath, FileCopyFlags.OVERWRITE);
				
			} catch (Error e) {
				stderr.printf ("Failed to export settings: %s\n", e.message);
			}
		}

		exportsettings.close ();
	}

	void import_settings () {

		var importsettings = new FileChooserDialog ("Import settings", this,
								FileChooserAction.OPEN,
								Stock.CANCEL, ResponseType.CANCEL,
								Stock.OPEN, ResponseType.ACCEPT, null);

		var filter = new FileFilter ();
		filter.add_pattern ("*.ini");

		importsettings.set_filter (filter);

		if (importsettings.run () == ResponseType.ACCEPT) {
			try {
				var importpath = File.new_for_path (importsettings.get_file ().get_path ());

				if (importpath.query_exists ()) {
					key_file.load_from_file (importpath.get_path (), KeyFileFlags.NONE);
				}
			} catch (Error e) {
				stderr.printf ("Failed to import settings: %s\n", e.message);
			}

			on_load_keyfile ();
		}

		importsettings.close ();
	}

	void show_about (SimpleAction simple, Variant? parameter) {
		string license = "This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.\n\nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License along with This program; if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA";

		show_about_dialog (this,
			"program-name", "Elegance Colors",
			"logo_icon_name", "elegance-colors",
			"copyright", "Copyright \xc2\xa9 Satyajit Sahoo",
			"comments", "A tint theme for Gnome Shell",
			"license", license,
			"wrap-license", true,
			"website", "https://github.com/satya164/elegance-colors",
			"website-label", "Elegance Colors on GitHub",
			null);
	}

	void quit_window () {
		destroy ();
	}

	void read_keys () {

		// Read the config file
		try {
			key_file.load_from_file (config_file.get_path(), KeyFileFlags.NONE);
		} catch (Error e) {
			stderr.printf ("Failed to read configuration: %s\n", e.message);
		}

		try {
			var mode = key_file.get_string ("Settings", "mode");

			if (mode == "wallpaper") {
				match_wallpaper.set_active (true);
				color_button.set_sensitive (false);
			} else if (mode == "gtk") {
				match_theme.set_active (true);
				color_button.set_sensitive (false);
			} else if ("#" in mode || "rgb" in mode) {
				color_value = mode;
				custom_color.set_active (true);
				color_button.set_sensitive (true);
			}

			monitor_switch.set_active (key_file.get_boolean ("Settings", "monitor"));

			fontchooser.set_font_name (key_file.get_string ("Settings", "fontname"));

			selgradient_size.adjustment.value = key_file.get_double ("Settings", "selgradient");
			corner_roundness.adjustment.value = key_file.get_double ("Settings", "roundness");
			transition_duration.adjustment.value = key_file.get_double ("Settings", "transition");

			panel_bg_value = key_file.get_string ("Panel", "panel_bg");
			panel_fg_value = key_file.get_string ("Panel", "panel_fg");
			panel_border_value = key_file.get_string ("Panel", "panel_border");

			panel_shadow_switch.set_active (key_file.get_boolean ("Panel", "panel_shadow"));
			panel_icon_switch.set_active (key_file.get_boolean ("Panel", "panel_icon"));

			panel_tint_value.adjustment.value = key_file.get_double ("Panel", "panel_tint");
			panel_gradient_value.adjustment.value = key_file.get_double ("Panel", "panel_gradient");
			panel_corner_value.adjustment.value = key_file.get_double ("Panel", "panel_corner");

			paneloverview_bg_value = key_file.get_string ("PanelOverview", "paneloverview_bg");
			paneloverview_fg_value = key_file.get_string ("PanelOverview", "paneloverview_fg");
			paneloverview_border_value = key_file.get_string ("PanelOverview", "paneloverview_border");

			paneloverview_shadow_switch.set_active (key_file.get_boolean ("PanelOverview", "paneloverview_shadow"));

			paneloverview_tint_value.adjustment.value = key_file.get_double ("PanelOverview", "paneloverview_tint");
			paneloverview_gradient_value.adjustment.value = key_file.get_double ("PanelOverview", "paneloverview_gradient");

			overview_bg_value = key_file.get_string ("Overview", "overview_bg");
			overview_msgbg_value = key_file.get_string ("Overview", "overview_msgbg");
			overview_msgborder_value = key_file.get_string ("Overview", "overview_msgborder");

			overview_tint_value.adjustment.value = key_file.get_double ("Overview", "overview_tint");
			overview_gradient_value.adjustment.value = key_file.get_double ("Overview", "overview_gradient");
			overview_iconsize_value.adjustment.value = key_file.get_double ("Overview", "overview_iconsize");
			overview_iconspacing_value.adjustment.value = key_file.get_double ("Overview", "overview_iconspacing");

			dash_bg_value = key_file.get_string ("Dash", "dash_bg");
			dash_fg_value = key_file.get_string ("Dash", "dash_fg");
			dash_border_value = key_file.get_string ("Dash", "dash_border");

			dash_shadow_switch.set_active (key_file.get_boolean ("Dash", "dash_shadow"));

			dash_tint_value.adjustment.value = key_file.get_double ("Dash", "dash_tint");
			dash_gradient_value.adjustment.value = key_file.get_double ("Dash", "dash_gradient");

			button_bg_value = key_file.get_string ("Buttons", "button_bg");
			button_hoverbg_value = key_file.get_string ("Buttons", "button_hoverbg");
			button_activebg_value = key_file.get_string ("Buttons", "button_activebg");
			button_fg_value = key_file.get_string ("Buttons", "button_fg");
			button_hoverfg_value = key_file.get_string ("Buttons", "button_hoverfg");
			button_activefg_value = key_file.get_string ("Buttons", "button_activefg");
			button_border_value = key_file.get_string ("Buttons", "button_border");
			button_border_value = key_file.get_string ("Buttons", "button_hoverborder");
			button_border_value = key_file.get_string ("Buttons", "button_activeborder");

			button_bold_switch.set_active (key_file.get_boolean ("Buttons", "button_bold"));

			button_gradient_value.adjustment.value = key_file.get_double ("Buttons", "button_gradient");

			entry_bg_value = key_file.get_string ("Entry", "entry_bg");
			entry_hoverbg_value = key_file.get_string ("Entry", "entry_hoverbg");
			entry_fg_value = key_file.get_string ("Entry", "entry_fg");
			entry_hoverfg_value = key_file.get_string ("Entry", "entry_hoverfg");
			entry_border_value = key_file.get_string ("Entry", "entry_border");
			entry_border_value = key_file.get_string ("Entry", "entry_hoverborder");

			entry_shadow_switch.set_active (key_file.get_boolean ("Entry", "entry_shadow"));

			entry_gradient_value.adjustment.value = key_file.get_double ("Entry", "entry_gradient");

			menu_bg_value = key_file.get_string ("Menu", "menu_bg");
			menu_fg_value = key_file.get_string ("Menu", "menu_fg");
			menu_border_value = key_file.get_string ("Menu", "menu_border");

			menu_shadow_switch.set_active (key_file.get_boolean ("Menu", "menu_shadow"));
			menu_arrow_switch.set_active (key_file.get_boolean ("Menu", "menu_arrow"));

			menu_tint_value.adjustment.value = key_file.get_double ("Menu", "menu_tint");
			menu_gradient_value.adjustment.value = key_file.get_double ("Menu", "menu_gradient");

			dialog_bg_value = key_file.get_string ("Dialogs", "dialog_bg");
			dialog_fg_value = key_file.get_string ("Dialogs", "dialog_fg");
			dialog_border_value = key_file.get_string ("Dialogs", "dialog_border");
			dialog_heading_value = key_file.get_string ("Dialogs", "dialog_heading");

			dialog_shadow_switch.set_active (key_file.get_boolean ("Dialogs", "dialog_shadow"));

			dialog_tint_value.adjustment.value = key_file.get_double ("Dialogs", "dialog_tint");
			dialog_gradient_value.adjustment.value = key_file.get_double ("Dialogs", "dialog_gradient");
		} catch (Error e) {
			stderr.printf ("Failed to set properties: %s\n", e.message);
		}

		// Set colors
		var color = Gdk.RGBA ();

		color.parse ("%s".printf (color_value));
		color_button.set_rgba (color);

		color.parse ("%s".printf (panel_bg_value));
		panel_bg_color.set_rgba (color);

		color.parse ("%s".printf (panel_fg_value));
		panel_fg_color.set_rgba (color);

		color.parse ("%s".printf (panel_border_value));
		panel_border_color.set_rgba (color);

		color.parse ("%s".printf (paneloverview_bg_value));
		paneloverview_bg_color.set_rgba (color);

		color.parse ("%s".printf (paneloverview_fg_value));
		paneloverview_fg_color.set_rgba (color);

		color.parse ("%s".printf (paneloverview_border_value));
		paneloverview_border_color.set_rgba (color);

		color.parse ("%s".printf (overview_bg_value));
		overview_bg_color.set_rgba (color);

		color.parse ("%s".printf (overview_msgbg_value));
		overview_msgbg_color.set_rgba (color);

		color.parse ("%s".printf (overview_msgborder_value));
		overview_msgborder_color.set_rgba (color);

		color.parse ("%s".printf (dash_bg_value));
		dash_bg_color.set_rgba (color);

		color.parse ("%s".printf (dash_fg_value));
		dash_fg_color.set_rgba (color);

		color.parse ("%s".printf (dash_border_value));
		dash_border_color.set_rgba (color);

		color.parse ("%s".printf (button_bg_value));
		button_bg_color.set_rgba (color);

		color.parse ("%s".printf (button_hoverbg_value));
		button_hoverbg_color.set_rgba (color);

		color.parse ("%s".printf (button_activebg_value));
		button_activebg_color.set_rgba (color);

		color.parse ("%s".printf (button_fg_value));
		button_fg_color.set_rgba (color);

		color.parse ("%s".printf (button_hoverfg_value));
		button_hoverfg_color.set_rgba (color);

		color.parse ("%s".printf (button_activefg_value));
		button_activefg_color.set_rgba (color);

		color.parse ("%s".printf (button_border_value));
		button_border_color.set_rgba (color);

		color.parse ("%s".printf (button_hoverborder_value));
		button_hoverborder_color.set_rgba (color);

		color.parse ("%s".printf (button_activeborder_value));
		button_activeborder_color.set_rgba (color);

		color.parse ("%s".printf (entry_bg_value));
		entry_bg_color.set_rgba (color);

		color.parse ("%s".printf (entry_hoverbg_value));
		entry_hoverbg_color.set_rgba (color);

		color.parse ("%s".printf (entry_fg_value));
		entry_fg_color.set_rgba (color);

		color.parse ("%s".printf (entry_hoverfg_value));
		entry_hoverfg_color.set_rgba (color);

		color.parse ("%s".printf (entry_border_value));
		entry_border_color.set_rgba (color);

		color.parse ("%s".printf (entry_hoverborder_value));
		entry_hoverborder_color.set_rgba (color);

		color.parse ("%s".printf (menu_bg_value));
		menu_bg_color.set_rgba (color);

		color.parse ("%s".printf (menu_fg_value));
		menu_fg_color.set_rgba (color);

		color.parse ("%s".printf (menu_border_value));
		menu_border_color.set_rgba (color);

		color.parse ("%s".printf (dialog_bg_value));
		dialog_bg_color.set_rgba (color);

		color.parse ("%s".printf (dialog_fg_value));
		dialog_fg_color.set_rgba (color);

		color.parse ("%s".printf (dialog_heading_value));
		dialog_heading_color.set_rgba (color);

		color.parse ("%s".printf (dialog_border_value));
		dialog_border_color.set_rgba (color);
	}

	void create_widgets () {

		// Create and setup widgets

		// General
		var presets_label = new Label.with_mnemonic ("Load config from preset");
		presets_label.set_halign (Align.START);

		// Read presets
		try {
			var dir = Dir.open(presets_dir_sys.get_path());

			var titlechanged = false;

			string preset = "";
			string title = "";
			while ((preset = dir.read_name()) != null) {
				presets += preset;

				try {
					var dis = new DataInputStream (presets_dir_sys.get_child (preset).read ());
					string line;
					while ((line = dis.read_line (null)) != null) {
						if ("# Name:" in line) {
							title = line.substring (8, line.length-8);
							titlechanged = true;
						}
					}
				} catch (Error e) {
					stderr.printf ("Could not read preset title: %s\n", e.message);
				}
				
				if (!titlechanged == true) {
					title = preset;
				}

				titles += title;
				titlechanged = false;
			}
		} catch (Error e) {
			stderr.printf ("Failed to open presets directory: %s\n", e.message);
		}

		var liststore = new ListStore (1, typeof (string));

		for (int i = 0; i < titles.length; i++){
			TreeIter iter;
			liststore.append (out iter);
			liststore.set (iter, 0, titles[i]);
		}

		var cell = new CellRendererText ();

		combobox = new ComboBox.with_model (liststore);
		combobox.pack_start (cell, false);
		combobox.set_attributes (cell, "text", 0);
		combobox.set_active (0);
		combobox.set_tooltip_text ("Load settings from a installed preset");
		combobox.set_halign (Align.END);

		var mode_label = new Label.with_mnemonic ("Derive color from");
		mode_label.set_halign (Align.START);

		match_wallpaper = new RadioButton (null);
		match_wallpaper.set_label ("Wallpaper");
		match_wallpaper.set_tooltip_text ("Derive the highlight color from the current wallpaper");
		match_theme = new RadioButton.with_label (match_wallpaper.get_group(),"GTK theme");
		match_theme.set_tooltip_text ("Derive the highlight color from the current GTK theme");
		custom_color = new RadioButton.with_label (match_theme.get_group(),"Custom");
		custom_color.set_tooltip_text ("Manually set a custom highlight color");
		color_button = new ColorButton ();
		color_button.set_use_alpha (true);
		color_button.set_tooltip_text ("Set a custom highlight color");
		var monitor_label = new Label.with_mnemonic ("Monitor changes");
		monitor_label.set_halign (Align.START);
		monitor_switch = new Switch ();
		monitor_switch.set_tooltip_text ("Run in background and reload the theme when changes are detected");
		monitor_switch.set_halign (Align.END);
		var font_label = new Label.with_mnemonic ("Display font");
		font_label.set_halign (Align.START);
		fontchooser = new FontButton ();
		fontchooser.set_title ("Choose a font");
		fontchooser.set_use_font (true);
		fontchooser.set_use_size (true);
		fontchooser.set_tooltip_text ("Choose the shell font and its size");
		fontchooser.set_halign (Align.END);
		var selgradient_label = new Label.with_mnemonic ("Selection gradient size");
		selgradient_label.set_halign (Align.START);
		selgradient_size = new SpinButton.with_range (0, 255, 1);
		selgradient_size.set_tooltip_text ("Set the gradient size for highlight color");
		selgradient_size.set_halign (Align.END);
		var roundness_label = new Label.with_mnemonic ("Roundness");
		roundness_label.set_halign (Align.START);
		corner_roundness = new SpinButton.with_range (0, 100, 1);
		corner_roundness.set_tooltip_text ("Set the border radius of different elements");
		corner_roundness.set_halign (Align.END);
		var transition_label = new Label.with_mnemonic ("Transition duration");
		transition_label.set_halign (Align.START);
		transition_duration = new SpinButton.with_range (0, 1000, 1);
		transition_duration.set_tooltip_text ("Set the duration of the transition animations");
		transition_duration.set_halign (Align.END);


		combobox.changed.connect (on_preset_selected);
		match_wallpaper.toggled.connect (() => {
			if (match_wallpaper.get_active()) {
				key_file.set_string ("Settings", "mode", "wallpaper");
			}
			on_value_changed ();
		});
		match_theme.toggled.connect (() => {
			if (match_theme.get_active()) {
				key_file.set_string ("Settings", "mode", "gtk");
			}
			on_value_changed ();
		});
		custom_color.toggled .connect (() => {
			if (custom_color.get_active ()) {
				key_file.set_string ("Settings", "mode", color_button.rgba.to_string());
				color_button.set_sensitive (true);
			} else {
				color_button.set_sensitive (false);
			}
		});
		color_button.color_set.connect (() => {
			key_file.set_string ("Settings", "mode", color_button.rgba.to_string());
			on_value_changed ();
		});
		monitor_switch.notify["active"].connect (() => {
			if (monitor_switch.get_active ()) {
				try {
					Process.spawn_command_line_async("elegance-colors");
				} catch (Error e) {
					stderr.printf ("Failed to start background process: %s\n", e.message);
				}
			} else {
				try {
					Process.spawn_command_line_async("elegance-colors stop");
				} catch (Error e) {
					stderr.printf ("Failed to stop background process: %s\n", e.message);
				}
			}
			key_file.set_boolean ("Settings", "monitor", monitor_switch.get_active());
			on_value_changed ();
		});
		fontchooser.font_set.connect (() => {
			key_file.set_string ("Settings", "fontname", fontchooser.get_font_name());
			on_value_changed ();
		});
		selgradient_size.adjustment.value_changed.connect (() => {
			key_file.set_double ("Settings", "selgradient", selgradient_size.adjustment.value);
			on_value_changed ();
		});
		corner_roundness.adjustment.value_changed.connect (() => {
			key_file.set_double ("Settings", "roundness", corner_roundness.adjustment.value);
			on_value_changed ();
		});
		transition_duration.adjustment.value_changed.connect (() => {
			key_file.set_double ("Settings", "transition", transition_duration.adjustment.value);
			on_value_changed ();
		});

		var general_grid = new Grid ();
		general_grid.set_column_homogeneous (true);
		general_grid.set_column_spacing (12);
		general_grid.set_row_spacing (12);
		general_grid.attach (presets_label, 0, 0, 1, 1);
		general_grid.attach_next_to (combobox, presets_label, PositionType.RIGHT, 2, 1);
		general_grid.attach (mode_label, 0, 1, 1, 1);
		general_grid.attach_next_to (match_wallpaper, mode_label, PositionType.RIGHT, 1, 1);
		general_grid.attach_next_to (match_theme, match_wallpaper, PositionType.RIGHT, 1, 1);
		general_grid.attach_next_to (custom_color, match_wallpaper, PositionType.BOTTOM, 1, 1);
		general_grid.attach_next_to (color_button, custom_color, PositionType.RIGHT, 1, 1);
		general_grid.attach (monitor_label, 0, 3, 2, 1);
		general_grid.attach_next_to (monitor_switch, monitor_label, PositionType.RIGHT, 1, 1);
		general_grid.attach (font_label, 0, 4, 1, 1);
		general_grid.attach_next_to (fontchooser, font_label, PositionType.RIGHT, 2, 1);
		general_grid.attach (selgradient_label, 0, 5, 2, 1);
		general_grid.attach_next_to (selgradient_size, selgradient_label, PositionType.RIGHT, 1, 1);
		general_grid.attach (roundness_label, 0, 6, 2, 1);
		general_grid.attach_next_to (corner_roundness, roundness_label, PositionType.RIGHT, 1, 1);
		general_grid.attach (transition_label, 0, 7, 2, 1);
		general_grid.attach_next_to (transition_duration, transition_label, PositionType.RIGHT, 1, 1);

		// Panel
		var panel_bg_label = new Label.with_mnemonic ("Background color");
		panel_bg_label.set_halign (Align.START);
		panel_bg_color = new ColorButton ();
		panel_bg_color.set_use_alpha (true);
		panel_bg_color.set_tooltip_text ("Set the background color of the top panel");
		var panel_fg_label = new Label.with_mnemonic ("Text color");
		panel_fg_label.set_halign (Align.START);
		panel_fg_color = new ColorButton ();
		panel_fg_color.set_use_alpha (true);
		panel_fg_color.set_tooltip_text ("Set the text color of the top panel");
		var panel_border_label = new Label.with_mnemonic ("Border color");
		panel_border_label.set_halign (Align.START);
		panel_border_color = new ColorButton ();
		panel_border_color.set_use_alpha (true);
		panel_border_color.set_tooltip_text ("Set the border color of the top panel");
		var panel_shadow_label = new Label.with_mnemonic ("Drop shadow");
		panel_shadow_label.set_halign (Align.START);
		panel_shadow_switch = new Switch ();
		panel_shadow_switch.set_tooltip_text ("Enable/disable shadow under the top panel");
		panel_shadow_switch.set_halign (Align.END);
		var panel_icon_label = new Label.with_mnemonic ("App icon");
		panel_icon_label.set_halign (Align.START);
		panel_icon_switch = new Switch ();
		panel_icon_switch.set_tooltip_text ("Enable/disable app icon in the top panel");
		panel_icon_switch.set_halign (Align.END);
		var panel_tint_label = new Label.with_mnemonic ("Background tint level");
		panel_tint_label.set_halign (Align.START);
		panel_tint_value = new SpinButton.with_range (0, 100, 1);
		panel_tint_value.set_tooltip_text ("Set the amount of highlight color to mix with the chosen background color of the top panel");
		panel_tint_value.set_halign (Align.END);
		var panel_gradient_label = new Label.with_mnemonic ("Gradient size");
		panel_gradient_label.set_halign (Align.START);
		panel_gradient_value = new SpinButton.with_range (0, 255, 1);
		panel_gradient_value.set_tooltip_text ("Set the gradient size of the background of the top panel");
		panel_gradient_value.set_halign (Align.END);
		var panel_corner_label = new Label.with_mnemonic ("Corner radius");
		panel_corner_label.set_halign (Align.START);
		panel_corner_value = new SpinButton.with_range (0, 100, 1);
		panel_corner_value.set_tooltip_text ("Set the roundness the top panel corners");
		panel_corner_value.set_halign (Align.END);

		var panel_grid = new Grid ();
		panel_grid.set_column_homogeneous (true);
		panel_grid.set_column_spacing (12);
		panel_grid.set_row_spacing (12);
		panel_grid.attach (panel_bg_label, 0, 0, 2, 1);
		panel_grid.attach_next_to (panel_bg_color, panel_bg_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_fg_label, 0, 1, 2, 1);
		panel_grid.attach_next_to (panel_fg_color, panel_fg_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_border_label, 0, 2, 2, 1);
		panel_grid.attach_next_to (panel_border_color, panel_border_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_shadow_label, 0, 3, 2, 1);
		panel_grid.attach_next_to (panel_shadow_switch, panel_shadow_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_icon_label, 0, 4, 2, 1);
		panel_grid.attach_next_to (panel_icon_switch, panel_icon_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_tint_label, 0, 5, 2, 1);
		panel_grid.attach_next_to (panel_tint_value, panel_tint_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_gradient_label, 0, 6, 2, 1);
		panel_grid.attach_next_to (panel_gradient_value, panel_gradient_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_corner_label, 0, 7, 2, 1);
		panel_grid.attach_next_to (panel_corner_value, panel_corner_label, PositionType.RIGHT, 1, 1);

		panel_bg_color.color_set.connect (() => {
			key_file.set_string ("Panel", "panel_bg", panel_bg_color.rgba.to_string());
			on_value_changed ();
		});
		panel_fg_color.color_set.connect (() => {
			key_file.set_string ("Panel", "panel_fg", panel_fg_color.rgba.to_string());
			on_value_changed ();
		});
		panel_border_color.color_set.connect (() => {
			key_file.set_string ("Panel", "panel_border", panel_border_color.rgba.to_string());
			on_value_changed ();
		});
		panel_shadow_switch.notify["active"].connect (() => {
			key_file.set_boolean ("Panel", "panel_shadow", panel_shadow_switch.get_active());
			on_value_changed ();
		});
		panel_icon_switch.notify["active"].connect (() => {
			key_file.set_boolean ("Panel", "panel_icon", panel_icon_switch.get_active());
			on_value_changed ();
		});
		panel_tint_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("Panel", "panel_tint", panel_tint_value.adjustment.value);
			on_value_changed ();
		});
		panel_gradient_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("Panel", "panel_gradient", panel_gradient_value.adjustment.value);
			on_value_changed ();
		});
		panel_corner_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("Panel", "panel_corner", panel_corner_value.adjustment.value);
			on_value_changed ();
		});

		// Panel in overview
		var paneloverview_bg_label = new Label.with_mnemonic ("Background color");
		paneloverview_bg_label.set_halign (Align.START);
		paneloverview_bg_color = new ColorButton ();
		paneloverview_bg_color.set_use_alpha (true);
		paneloverview_bg_color.set_tooltip_text ("Set the background color of the top panel in the overview");
		var paneloverview_fg_label = new Label.with_mnemonic ("Text color");
		paneloverview_fg_label.set_halign (Align.START);
		paneloverview_fg_color = new ColorButton ();
		paneloverview_fg_color.set_use_alpha (true);
		paneloverview_fg_color.set_tooltip_text ("Set the text color of the top panel in the overview");
		var paneloverview_border_label = new Label.with_mnemonic ("Border color");
		paneloverview_border_label.set_halign (Align.START);
		paneloverview_border_color = new ColorButton ();
		paneloverview_border_color.set_use_alpha (true);
		paneloverview_border_color.set_tooltip_text ("Set the border color of the top paneloverview");
		var paneloverview_shadow_label = new Label.with_mnemonic ("Drop shadow");
		paneloverview_shadow_label.set_halign (Align.START);
		paneloverview_shadow_switch = new Switch ();
		paneloverview_shadow_switch.set_tooltip_text ("Enable/disable shadow under the top panel in the overview");
		paneloverview_shadow_switch.set_halign (Align.END);
		var paneloverview_tint_label = new Label.with_mnemonic ("Background tint level");
		paneloverview_tint_label.set_halign (Align.START);
		paneloverview_tint_value = new SpinButton.with_range (0, 100, 1);
		paneloverview_tint_value.set_tooltip_text ("Set the amount of highlight color to mix with the chosen background color of the top panel in the overview");
		paneloverview_tint_value.set_halign (Align.END);
		var paneloverview_gradient_label = new Label.with_mnemonic ("Gradient size");
		paneloverview_gradient_label.set_halign (Align.START);
		paneloverview_gradient_value = new SpinButton.with_range (0, 255, 1);
		paneloverview_gradient_value.set_tooltip_text ("Set the gradient size of the background of the top panel in the overview");
		paneloverview_gradient_value.set_halign (Align.END);

		var paneloverview_grid = new Grid ();
		paneloverview_grid.set_column_homogeneous (true);
		paneloverview_grid.set_column_spacing (12);
		paneloverview_grid.set_row_spacing (12);
		paneloverview_grid.attach (paneloverview_bg_label, 0, 0, 2, 1);
		paneloverview_grid.attach_next_to (paneloverview_bg_color, paneloverview_bg_label, PositionType.RIGHT, 1, 1);
		paneloverview_grid.attach (paneloverview_fg_label, 0, 1, 2, 1);
		paneloverview_grid.attach_next_to (paneloverview_fg_color, paneloverview_fg_label, PositionType.RIGHT, 1, 1);
		paneloverview_grid.attach (paneloverview_border_label, 0, 2, 2, 1);
		paneloverview_grid.attach_next_to (paneloverview_border_color, paneloverview_border_label, PositionType.RIGHT, 1, 1);
		paneloverview_grid.attach (paneloverview_shadow_label, 0, 3, 2, 1);
		paneloverview_grid.attach_next_to (paneloverview_shadow_switch, paneloverview_shadow_label, PositionType.RIGHT, 1, 1);
		paneloverview_grid.attach (paneloverview_tint_label, 0, 4, 2, 1);
		paneloverview_grid.attach_next_to (paneloverview_tint_value, paneloverview_tint_label, PositionType.RIGHT, 1, 1);
		paneloverview_grid.attach (paneloverview_gradient_label, 0, 5, 2, 1);
		paneloverview_grid.attach_next_to (paneloverview_gradient_value, paneloverview_gradient_label, PositionType.RIGHT, 1, 1);

		paneloverview_bg_color.color_set.connect (() => {
			key_file.set_string ("PanelOverview", "paneloverview_bg", paneloverview_bg_color.rgba.to_string());
			on_value_changed ();
		});
		paneloverview_fg_color.color_set.connect (() => {
			key_file.set_string ("PanelOverview", "paneloverview_fg", paneloverview_fg_color.rgba.to_string());
			on_value_changed ();
		});
		paneloverview_border_color.color_set.connect (() => {
			key_file.set_string ("PanelOverview", "paneloverview_border", paneloverview_border_color.rgba.to_string());
			on_value_changed ();
		});
		paneloverview_shadow_switch.notify["active"].connect (() => {
			key_file.set_boolean ("PanelOverview", "paneloverview_shadow", paneloverview_shadow_switch.get_active());
			on_value_changed ();
		});
		paneloverview_tint_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("PanelOverview", "paneloverview_tint", paneloverview_tint_value.adjustment.value);
			on_value_changed ();
		});
		paneloverview_gradient_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("PanelOverview", "paneloverview_gradient", paneloverview_gradient_value.adjustment.value);
			on_value_changed ();
		});

		// Overview
		var overview_bg_label = new Label.with_mnemonic ("Overview background color");
		overview_bg_label.set_halign (Align.START);
		overview_bg_color = new ColorButton ();
		overview_bg_color.set_use_alpha (true);
		overview_bg_color.set_tooltip_text ("Set the background color of the overview");
		var overview_msgbg_label = new Label.with_mnemonic ("Message tray background color");
		overview_msgbg_label.set_halign (Align.START);
		overview_msgbg_color = new ColorButton ();
		overview_msgbg_color.set_use_alpha (true);
		overview_msgbg_color.set_tooltip_text ("Set the background color of the message tray");
		var overview_msgborder_label = new Label.with_mnemonic ("Message tray border color");
		overview_msgborder_label.set_halign (Align.START);
		overview_msgborder_color = new ColorButton ();
		overview_msgborder_color.set_use_alpha (true);
		overview_msgborder_color.set_tooltip_text ("Set the border color of the message tray");
		var overview_tint_label = new Label.with_mnemonic ("Overview background tint level");
		overview_tint_label.set_halign (Align.START);
		overview_tint_value = new SpinButton.with_range (0, 100, 1);
		overview_tint_value.set_tooltip_text ("Set the amount of highlight color to mix with the chosen background color of the overview");
		overview_tint_value.set_halign (Align.END);
		var overview_gradient_label = new Label.with_mnemonic ("Overview gradient size");
		overview_gradient_label.set_halign (Align.START);
		overview_gradient_value = new SpinButton.with_range (0, 255, 1);
		overview_gradient_value.set_tooltip_text ("Set the gradient size of the background of the overview");
		overview_gradient_value.set_halign (Align.END);
		var overview_iconsize_label = new Label.with_mnemonic ("App icon size");
		overview_iconsize_label.set_halign (Align.START);
		overview_iconsize_value = new SpinButton.with_range (0, 256, 1);
		overview_iconsize_value.set_tooltip_text ("Set the size of icons in the application grid");
		overview_iconsize_value.set_halign (Align.END);
		var overview_iconspacing_label = new Label.with_mnemonic ("App icon spacing");
		overview_iconspacing_label.set_halign (Align.START);
		overview_iconspacing_value = new SpinButton.with_range (0, 256, 1);
		overview_iconspacing_value.set_tooltip_text ("Set the spacing between icons in the application grid");
		overview_iconspacing_value.set_halign (Align.END);

		overview_bg_color.color_set.connect (() => {
			key_file.set_string ("Overview", "overview_bg", overview_bg_color.rgba.to_string());
			on_value_changed ();
		});
		overview_msgbg_color.color_set.connect (() => {
			key_file.set_string ("Overview", "overview_msgbg", overview_msgbg_color.rgba.to_string());
			on_value_changed ();
		});
		overview_msgborder_color.color_set.connect (() => {
			key_file.set_string ("Overview", "overview_msgborder", overview_msgborder_color.rgba.to_string());
			on_value_changed ();
		});
		overview_tint_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("Overview", "overview_tint", overview_tint_value.adjustment.value);
			on_value_changed ();
		});
		overview_gradient_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("Overview", "overview_gradient", overview_gradient_value.adjustment.value);
			on_value_changed ();
		});
		overview_iconsize_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("Overview", "overview_iconsize", overview_iconsize_value.adjustment.value);
			on_value_changed ();
		});
		overview_iconspacing_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("Overview", "overview_iconspacing", overview_iconspacing_value.adjustment.value);
			on_value_changed ();
		});

		var overview_grid = new Grid ();
		overview_grid.set_column_homogeneous (true);
		overview_grid.set_column_spacing (12);
		overview_grid.set_row_spacing (12);
		overview_grid.attach (overview_bg_label, 0, 0, 2, 1);
		overview_grid.attach_next_to (overview_bg_color, overview_bg_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_msgbg_label, 0, 1, 2, 1);
		overview_grid.attach_next_to (overview_msgbg_color, overview_msgbg_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_msgborder_label, 0, 2, 2, 1);
		overview_grid.attach_next_to (overview_msgborder_color, overview_msgborder_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_tint_label, 0, 3, 2, 1);
		overview_grid.attach_next_to (overview_tint_value, overview_tint_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_gradient_label, 0, 4, 2, 1);
		overview_grid.attach_next_to (overview_gradient_value, overview_gradient_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_iconsize_label, 0, 5, 2, 1);
		overview_grid.attach_next_to (overview_iconsize_value, overview_iconsize_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_iconspacing_label, 0, 6, 2, 1);
		overview_grid.attach_next_to (overview_iconspacing_value, overview_iconspacing_label, PositionType.RIGHT, 1, 1);

		// Dash
		var dash_bg_label = new Label.with_mnemonic ("Background color");
		dash_bg_label.set_halign (Align.START);
		dash_bg_color = new ColorButton ();
		dash_bg_color.set_use_alpha (true);
		dash_bg_color.set_tooltip_text ("Set the background color of the dash and workspace panel");
		var dash_fg_label = new Label.with_mnemonic ("Text color");
		dash_fg_label.set_halign (Align.START);
		dash_fg_color = new ColorButton ();
		dash_fg_color.set_use_alpha (true);
		dash_fg_color.set_tooltip_text ("Set the text color of the dash labels and window caption");
		var dash_border_label = new Label.with_mnemonic ("Border color");
		dash_border_label.set_halign (Align.START);
		dash_border_color = new ColorButton ();
		dash_border_color.set_use_alpha (true);
		dash_border_color.set_tooltip_text ("Set the border color of the dash and workspace panel");
		var dash_shadow_label = new Label.with_mnemonic ("Drop shadow");
		dash_shadow_label.set_halign (Align.START);
		dash_shadow_switch = new Switch ();
		dash_shadow_switch.set_tooltip_text ("Enable/disable shadow under the dash and workspace panel");
		dash_shadow_switch.set_halign (Align.END);
		var dash_tint_label = new Label.with_mnemonic ("Background tint level");
		dash_tint_label.set_halign (Align.START);
		dash_tint_value = new SpinButton.with_range (0, 100, 1);
		dash_tint_value.set_tooltip_text ("Set the amount of highlight color to mix with the chosen background color of the dash and workspace panel");
		dash_tint_value.set_halign (Align.END);
		var dash_gradient_label = new Label.with_mnemonic ("Gradient size");
		dash_gradient_label.set_halign (Align.START);
		dash_gradient_value = new SpinButton.with_range (0, 255, 1);
		dash_gradient_value.set_tooltip_text ("Set the gradient size of the background of the dash and workspace panel");
		dash_gradient_value.set_halign (Align.END);

		dash_bg_color.color_set.connect (() => {
			key_file.set_string ("Dash", "dash_bg", dash_bg_color.rgba.to_string());
			on_value_changed ();
		});
		dash_fg_color.color_set.connect (() => {
			key_file.set_string ("Dash", "dash_fg", dash_fg_color.rgba.to_string());
			on_value_changed ();
		});
		dash_border_color.color_set.connect (() => {
			key_file.set_string ("Dash", "dash_border", dash_border_color.rgba.to_string());
			on_value_changed ();
		});
		dash_shadow_switch.notify["active"].connect (() => {
			key_file.set_boolean ("Dash", "dash_shadow", dash_shadow_switch.get_active());
			on_value_changed ();
		});
		dash_tint_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("Dash", "dash_tint", dash_tint_value.adjustment.value);
			on_value_changed ();
		});
		dash_gradient_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("Dash", "dash_gradient", dash_gradient_value.adjustment.value);
			on_value_changed ();
		});

		var dash_grid = new Grid ();
		dash_grid.set_column_homogeneous (true);
		dash_grid.set_column_spacing (12);
		dash_grid.set_row_spacing (12);
		dash_grid.attach (dash_bg_label, 0, 0, 2, 1);
		dash_grid.attach_next_to (dash_bg_color, dash_bg_label, PositionType.RIGHT, 1, 1);
		dash_grid.attach (dash_fg_label, 0, 1, 2, 1);
		dash_grid.attach_next_to (dash_fg_color, dash_fg_label, PositionType.RIGHT, 1, 1);
		dash_grid.attach (dash_border_label, 0, 2, 2, 1);
		dash_grid.attach_next_to (dash_border_color, dash_border_label, PositionType.RIGHT, 1, 1);
		dash_grid.attach (dash_shadow_label, 0, 3, 2, 1);
		dash_grid.attach_next_to (dash_shadow_switch, dash_shadow_label, PositionType.RIGHT, 1, 1);
		dash_grid.attach (dash_tint_label, 0, 4, 2, 1);
		dash_grid.attach_next_to (dash_tint_value, dash_tint_label, PositionType.RIGHT, 1, 1);
		dash_grid.attach (dash_gradient_label, 0, 5, 2, 1);
		dash_grid.attach_next_to (dash_gradient_value, dash_gradient_label, PositionType.RIGHT, 1, 1);

		// Buttons
		var button_bg_label = new Label.with_mnemonic ("Background color");
		button_bg_label.set_halign (Align.START);
		button_bg_color = new ColorButton ();
		button_bg_color.set_use_alpha (true);
		button_bg_color.set_tooltip_text ("Set the background color of the buttons");
		var button_hoverbg_label = new Label.with_mnemonic ("Hover background color");
		button_hoverbg_label.set_halign (Align.START);
		button_hoverbg_color = new ColorButton ();
		button_hoverbg_color.set_use_alpha (true);
		button_hoverbg_color.set_tooltip_text ("Set the background color of the buttons in hover state");
		var button_activebg_label = new Label.with_mnemonic ("Active background color");
		button_activebg_label.set_halign (Align.START);
		button_activebg_color = new ColorButton ();
		button_activebg_color.set_use_alpha (true);
		button_activebg_color.set_tooltip_text ("Set the background color of the buttons in active state");
		var button_fg_label = new Label.with_mnemonic ("Text color");
		button_fg_label.set_halign (Align.START);
		button_fg_color = new ColorButton ();
		button_fg_color.set_use_alpha (true);
		button_fg_color.set_tooltip_text ("Set the text color of the buttons");
		var button_hoverfg_label = new Label.with_mnemonic ("Hover text color");
		button_hoverfg_label.set_halign (Align.START);
		button_hoverfg_color = new ColorButton ();
		button_hoverfg_color.set_use_alpha (true);
		button_hoverfg_color.set_tooltip_text ("Set the text color of the buttons in hover state");
		var button_activefg_label = new Label.with_mnemonic ("Active text color");
		button_activefg_label.set_halign (Align.START);
		button_activefg_color = new ColorButton ();
		button_activefg_color.set_use_alpha (true);
		button_activefg_color.set_tooltip_text ("Set the text color of the buttons in active state");
		var button_border_label = new Label.with_mnemonic ("Border color");
		button_border_label.set_halign (Align.START);
		button_border_color = new ColorButton ();
		button_border_color.set_use_alpha (true);
		button_border_color.set_tooltip_text ("Set the border color of the buttons");
		var button_hoverborder_label = new Label.with_mnemonic ("Hover border color");
		button_hoverborder_label.set_halign (Align.START);
		button_hoverborder_color = new ColorButton ();
		button_hoverborder_color.set_use_alpha (true);
		button_hoverborder_color.set_tooltip_text ("Set the border color of the buttons in hover state");
		var button_activeborder_label = new Label.with_mnemonic ("Active border color");
		button_activeborder_label.set_halign (Align.START);
		button_activeborder_color = new ColorButton ();
		button_activeborder_color.set_use_alpha (true);
		button_activeborder_color.set_tooltip_text ("Set the border color of the buttons in active state");
		var button_bold_label = new Label.with_mnemonic ("Bold label");
		button_bold_label.set_halign (Align.START);
		button_bold_switch = new Switch ();
		button_bold_switch.set_tooltip_text ("Enable/disable bold label in the buttons");
		button_bold_switch.set_halign (Align.END);
		var button_gradient_label = new Label.with_mnemonic ("Gradient size");
		button_gradient_label.set_halign (Align.START);
		button_gradient_value = new SpinButton.with_range (0, 255, 1);
		button_gradient_value.set_tooltip_text ("Set the gradient size of the background of the buttons");
		button_gradient_value.set_halign (Align.END);

		var button_grid = new Grid ();
		button_grid.set_column_homogeneous (true);
		button_grid.set_column_spacing (12);
		button_grid.set_row_spacing (12);
		button_grid.attach (button_bg_label, 0, 0, 2, 1);
		button_grid.attach_next_to (button_bg_color, button_bg_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_hoverbg_label, 0, 1, 2, 1);
		button_grid.attach_next_to (button_hoverbg_color, button_hoverbg_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_activebg_label, 0, 2, 2, 1);
		button_grid.attach_next_to (button_activebg_color, button_activebg_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_fg_label, 0, 3, 2, 1);
		button_grid.attach_next_to (button_fg_color, button_fg_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_hoverfg_label, 0, 4, 2, 1);
		button_grid.attach_next_to (button_hoverfg_color, button_hoverfg_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_activefg_label, 0, 5, 2, 1);
		button_grid.attach_next_to (button_activefg_color, button_activefg_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_border_label, 0, 6, 2, 1);
		button_grid.attach_next_to (button_border_color, button_border_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_hoverborder_label, 0, 7, 2, 1);
		button_grid.attach_next_to (button_hoverborder_color, button_hoverborder_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_activeborder_label, 0, 8, 2, 1);
		button_grid.attach_next_to (button_activeborder_color, button_activeborder_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_bold_label, 0, 9, 2, 1);
		button_grid.attach_next_to (button_bold_switch, button_bold_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_gradient_label, 0, 10, 2, 1);
		button_grid.attach_next_to (button_gradient_value, button_gradient_label, PositionType.RIGHT, 1, 1);

		button_bg_color.color_set.connect (() => {
			key_file.set_string ("Buttons", "button_bg", button_bg_color.rgba.to_string());
			on_value_changed ();
		});
		button_hoverbg_color.color_set.connect (() => {
			key_file.set_string ("Buttons", "button_hoverbg", button_hoverbg_color.rgba.to_string());
			on_value_changed ();
		});
		button_activebg_color.color_set.connect (() => {
			key_file.set_string ("Buttons", "button_activebg", button_activebg_color.rgba.to_string());
			on_value_changed ();
		});
		button_fg_color.color_set.connect (() => {
			key_file.set_string ("Buttons", "button_fg", button_fg_color.rgba.to_string());
			on_value_changed ();
		});
		button_hoverfg_color.color_set.connect (() => {
			key_file.set_string ("Buttons", "button_hoverfg", button_hoverfg_color.rgba.to_string());
			on_value_changed ();
		});
		button_activefg_color.color_set.connect (() => {
			key_file.set_string ("Buttons", "button_activefg", button_activefg_color.rgba.to_string());
			on_value_changed ();
		});
		button_border_color.color_set.connect (() => {
			key_file.set_string ("Buttons", "button_border", button_border_color.rgba.to_string());
			on_value_changed ();
		});
		button_hoverborder_color.color_set.connect (() => {
			key_file.set_string ("Buttons", "button_hoverborder", button_hoverborder_color.rgba.to_string());
			on_value_changed ();
		});
		button_activeborder_color.color_set.connect (() => {
			key_file.set_string ("Buttons", "button_activeborder", button_activeborder_color.rgba.to_string());
			on_value_changed ();
		});
		button_bold_switch.notify["active"].connect (() => {
			key_file.set_boolean ("Buttons", "button_bold", button_bold_switch.get_active());
			on_value_changed ();
		});
		button_gradient_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("Buttons", "button_gradient", button_gradient_value.adjustment.value);
			on_value_changed ();
		});

		// Entry
		var entry_bg_label = new Label.with_mnemonic ("Background color");
		entry_bg_label.set_halign (Align.START);
		entry_bg_color = new ColorButton ();
		entry_bg_color.set_use_alpha (true);
		entry_bg_color.set_tooltip_text ("Set the background color of the entry widget");
		var entry_hoverbg_label = new Label.with_mnemonic ("Hover background color");
		entry_hoverbg_label.set_halign (Align.START);
		entry_hoverbg_color = new ColorButton ();
		entry_hoverbg_color.set_use_alpha (true);
		entry_hoverbg_color.set_tooltip_text ("Set the background color of the entry widget in hover state");
		var entry_fg_label = new Label.with_mnemonic ("Text color");
		entry_fg_label.set_halign (Align.START);
		entry_fg_color = new ColorButton ();
		entry_fg_color.set_use_alpha (true);
		entry_fg_color.set_tooltip_text ("Set the text color of the entry widget");
		var entry_hoverfg_label = new Label.with_mnemonic ("Hover text color");
		entry_hoverfg_label.set_halign (Align.START);
		entry_hoverfg_color = new ColorButton ();
		entry_hoverfg_color.set_use_alpha (true);
		entry_hoverfg_color.set_tooltip_text ("Set the text color of the entry widget");
		var entry_border_label = new Label.with_mnemonic ("Border color");
		entry_border_label.set_halign (Align.START);
		entry_border_color = new ColorButton ();
		entry_border_color.set_use_alpha (true);
		entry_border_color.set_tooltip_text ("Set the border color of the entry widget in hover state");
		var entry_hoverborder_label = new Label.with_mnemonic ("Hover border color");
		entry_hoverborder_label.set_halign (Align.START);
		entry_hoverborder_color = new ColorButton ();
		entry_hoverborder_color.set_use_alpha (true);
		entry_hoverborder_color.set_tooltip_text ("Set the border color of the entry widget in hover state");
		var entry_shadow_label = new Label.with_mnemonic ("Inset shadow");
		entry_shadow_label.set_halign (Align.START);
		entry_shadow_switch = new Switch ();
		entry_shadow_switch.set_tooltip_text ("Enable/disable inset shadow in the entry widget");
		entry_shadow_switch.set_halign (Align.END);
		var entry_gradient_label = new Label.with_mnemonic ("Gradient size");
		entry_gradient_label.set_halign (Align.START);
		entry_gradient_value = new SpinButton.with_range (0, 255, 1);
		entry_gradient_value.set_tooltip_text ("Set the gradient size of the background of the entry widget");
		entry_gradient_value.set_halign (Align.END);

		var entry_grid = new Grid ();
		entry_grid.set_column_homogeneous (true);
		entry_grid.set_column_spacing (12);
		entry_grid.set_row_spacing (12);
		entry_grid.attach (entry_bg_label, 0, 0, 2, 1);
		entry_grid.attach_next_to (entry_bg_color, entry_bg_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_hoverbg_label, 0, 1, 2, 1);
		entry_grid.attach_next_to (entry_hoverbg_color, entry_hoverbg_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_fg_label, 0, 2, 2, 1);
		entry_grid.attach_next_to (entry_fg_color, entry_fg_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_hoverfg_label, 0, 3, 2, 1);
		entry_grid.attach_next_to (entry_hoverfg_color, entry_hoverfg_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_border_label, 0, 4, 2, 1);
		entry_grid.attach_next_to (entry_border_color, entry_border_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_hoverborder_label, 0, 5, 2, 1);
		entry_grid.attach_next_to (entry_hoverborder_color, entry_hoverborder_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_shadow_label, 0, 6, 2, 1);
		entry_grid.attach_next_to (entry_shadow_switch, entry_shadow_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_gradient_label, 0, 7, 2, 1);
		entry_grid.attach_next_to (entry_gradient_value, entry_gradient_label, PositionType.RIGHT, 1, 1);

		entry_bg_color.color_set.connect (() => {
			key_file.set_string ("Entry", "entry_bg", entry_bg_color.rgba.to_string());
			on_value_changed ();
		});
		entry_hoverbg_color.color_set.connect (() => {
			key_file.set_string ("Entry", "entry_hoverbg", entry_hoverbg_color.rgba.to_string());
			on_value_changed ();
		});
		entry_fg_color.color_set.connect (() => {
			key_file.set_string ("Entry", "entry_fg", entry_fg_color.rgba.to_string());
			on_value_changed ();
		});
		entry_hoverfg_color.color_set.connect (() => {
			key_file.set_string ("Entry", "entry_hoverfg", entry_hoverfg_color.rgba.to_string());
			on_value_changed ();
		});
		entry_border_color.color_set.connect (() => {
			key_file.set_string ("Entry", "entry_border", entry_border_color.rgba.to_string());
			on_value_changed ();
		});
		entry_hoverborder_color.color_set.connect (() => {
			key_file.set_string ("Entry", "entry_hoverborder", entry_hoverborder_color.rgba.to_string());
			on_value_changed ();
		});
		entry_shadow_switch.notify["active"].connect (() => {
			key_file.set_boolean ("Entry", "entry_shadow", entry_shadow_switch.get_active());
			on_value_changed ();
		});
		entry_gradient_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("Entry", "entry_gradient", entry_gradient_value.adjustment.value);
			on_value_changed ();
		});

		// Menu
		var menu_bg_label = new Label.with_mnemonic ("Background color");
		menu_bg_label.set_halign (Align.START);
		menu_bg_color = new ColorButton ();
		menu_bg_color.set_use_alpha (true);
		menu_bg_color.set_tooltip_text ("Set the background color of the popup menu");
		var menu_fg_label = new Label.with_mnemonic ("Text color");
		menu_fg_label.set_halign (Align.START);
		menu_fg_color = new ColorButton ();
		menu_fg_color.set_use_alpha (true);
		menu_fg_color.set_tooltip_text ("Set the text color of the popup menu");
		var menu_border_label = new Label.with_mnemonic ("Border color");
		menu_border_label.set_halign (Align.START);
		menu_border_color = new ColorButton ();
		menu_border_color.set_use_alpha (true);
		menu_border_color.set_tooltip_text ("Set the border color of the popup menu");
		var menu_shadow_label = new Label.with_mnemonic ("Drop shadow");
		menu_shadow_label.set_halign (Align.START);
		menu_shadow_switch = new Switch ();
		menu_shadow_switch.set_tooltip_text ("Enable/disable shadow under the popup menu");
		menu_shadow_switch.set_halign (Align.END);
		var menu_arrow_label = new Label.with_mnemonic ("Arrow pointer");
		menu_arrow_label.set_halign (Align.START);
		menu_arrow_switch = new Switch ();
		menu_arrow_switch.set_tooltip_text ("Enable/disable arrow pointer in the popup menu");
		menu_arrow_switch.set_halign (Align.END);
		var menu_tint_label = new Label.with_mnemonic ("Background tint level");
		menu_tint_label.set_halign (Align.START);
		menu_tint_value = new SpinButton.with_range (0, 100, 1);
		menu_tint_value.set_tooltip_text ("Set the amount of highlight color to mix with the chosen background color of the popup menu");
		menu_tint_value.set_halign (Align.END);
		var menu_gradient_label = new Label.with_mnemonic ("Gradient size");
		menu_gradient_label.set_halign (Align.START);
		menu_gradient_value = new SpinButton.with_range (0, 255, 1);
		menu_gradient_value.set_tooltip_text ("Set the gradient size of the background of the popup menu");
		menu_gradient_value.set_halign (Align.END);

		menu_bg_color.color_set.connect (() => {
			key_file.set_string ("Menu", "menu_bg", menu_bg_color.rgba.to_string());
			on_value_changed ();
		});
		menu_fg_color.color_set.connect (() => {
			key_file.set_string ("Menu", "menu_fg", menu_fg_color.rgba.to_string());
			on_value_changed ();
		});
		menu_border_color.color_set.connect (() => {
			key_file.set_string ("Menu", "menu_border", menu_border_color.rgba.to_string());
			on_value_changed ();
		});
		menu_shadow_switch.notify["active"].connect (() => {
			key_file.set_boolean ("Menu", "menu_shadow", menu_shadow_switch.get_active());
			on_value_changed ();
		});
		menu_arrow_switch.notify["active"].connect (() => {
			key_file.set_boolean ("Menu", "menu_arrow", menu_arrow_switch.get_active());
			on_value_changed ();
		});
		menu_tint_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("Menu", "menu_tint", menu_tint_value.adjustment.value);
			on_value_changed ();
		});
		menu_gradient_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("Menu", "menu_gradient", menu_gradient_value.adjustment.value);
			on_value_changed ();
		});

		var menu_grid = new Grid ();
		menu_grid.set_column_homogeneous (true);
		menu_grid.set_column_spacing (12);
		menu_grid.set_row_spacing (12);
		menu_grid.attach (menu_bg_label, 0, 0, 2, 1);
		menu_grid.attach_next_to (menu_bg_color, menu_bg_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_fg_label, 0, 1, 2, 1);
		menu_grid.attach_next_to (menu_fg_color, menu_fg_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_border_label, 0, 2, 2, 1);
		menu_grid.attach_next_to (menu_border_color, menu_border_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_shadow_label, 0, 3, 2, 1);
		menu_grid.attach_next_to (menu_shadow_switch, menu_shadow_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_arrow_label, 0, 4, 2, 1);
		menu_grid.attach_next_to (menu_arrow_switch, menu_arrow_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_tint_label, 0, 5, 2, 1);
		menu_grid.attach_next_to (menu_tint_value, menu_tint_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_gradient_label, 0, 6, 2, 1);
		menu_grid.attach_next_to (menu_gradient_value, menu_gradient_label, PositionType.RIGHT, 1, 1);

		// Dialogs
		var dialog_bg_label = new Label.with_mnemonic ("Background color");
		dialog_bg_label.set_halign (Align.START);
		dialog_bg_color = new ColorButton ();
		dialog_bg_color.set_use_alpha (true);
		dialog_bg_color.set_tooltip_text ("Set the background color of the modal dialogs");
		var dialog_fg_label = new Label.with_mnemonic ("Text color");
		dialog_fg_label.set_halign (Align.START);
		dialog_fg_color = new ColorButton ();
		dialog_fg_color.set_use_alpha (true);
		dialog_fg_color.set_tooltip_text ("Set the text color of the modal dialogs");
		var dialog_heading_label = new Label.with_mnemonic ("Heading color");
		dialog_heading_label.set_halign (Align.START);
		dialog_heading_color = new ColorButton ();
		dialog_heading_color.set_use_alpha (true);
		dialog_heading_color.set_tooltip_text ("Set the text color of headings in the modal dialogs");
		var dialog_border_label = new Label.with_mnemonic ("Border color");
		dialog_border_label.set_halign (Align.START);
		dialog_border_color = new ColorButton ();
		dialog_border_color.set_use_alpha (true);
		dialog_border_color.set_tooltip_text ("Set the border color of the modal dialogs");
		var dialog_shadow_label = new Label.with_mnemonic ("Drop shadow");
		dialog_shadow_label.set_halign (Align.START);
		dialog_shadow_switch = new Switch ();
		dialog_shadow_switch.set_tooltip_text ("Enable/disable shadow under the modal dialogs");
		dialog_shadow_switch.set_halign (Align.END);
		var dialog_tint_label = new Label.with_mnemonic ("Background tint level");
		dialog_tint_label.set_halign (Align.START);
		dialog_tint_value = new SpinButton.with_range (0, 100, 1);
		dialog_tint_value.set_tooltip_text ("Set the amount of highlight color to mix with the chosen background color of the modal dialogs");
		dialog_tint_value.set_halign (Align.END);
		var dialog_gradient_label = new Label.with_mnemonic ("Gradient size");
		dialog_gradient_label.set_halign (Align.START);
		dialog_gradient_value = new SpinButton.with_range (0, 255, 1);
		dialog_gradient_value.set_tooltip_text ("Set the gradient size of the background of the modal dialogs");
		dialog_gradient_value.set_halign (Align.END);

		dialog_bg_color.color_set.connect (() => {
			key_file.set_string ("Dialogs", "dialog_bg", dialog_bg_color.rgba.to_string());
			on_value_changed ();
		});
		dialog_fg_color.color_set.connect (() => {
			key_file.set_string ("Dialogs", "dialog_fg", dialog_fg_color.rgba.to_string());
			on_value_changed ();
		});
		dialog_heading_color.color_set.connect (() => {
			key_file.set_string ("Dialogs", "dialog_heading", dialog_heading_color.rgba.to_string());
			on_value_changed ();
		});
		dialog_border_color.color_set.connect (() => {
			key_file.set_string ("Dialogs", "dialog_border", dialog_border_color.rgba.to_string());
			on_value_changed ();
		});
		dialog_shadow_switch.notify["active"].connect (() => {
			key_file.set_boolean ("Dialogs", "dialog_shadow", dialog_shadow_switch.get_active());
			on_value_changed ();
		});
		dialog_tint_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("Dialogs", "dialog_tint", dialog_tint_value.adjustment.value);
			on_value_changed ();
		});
		dialog_gradient_value.adjustment.value_changed.connect (() => {
			key_file.set_double ("Dialogs", "dialog_gradient", dialog_gradient_value.adjustment.value);
			on_value_changed ();
		});

		var dialog_grid = new Grid ();
		dialog_grid.set_column_homogeneous (true);
		dialog_grid.set_column_spacing (12);
		dialog_grid.set_row_spacing (12);
		dialog_grid.attach (dialog_bg_label, 0, 0, 2, 1);
		dialog_grid.attach_next_to (dialog_bg_color, dialog_bg_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_fg_label, 0, 1, 2, 1);
		dialog_grid.attach_next_to (dialog_fg_color, dialog_fg_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_heading_label, 0, 2, 2, 1);
		dialog_grid.attach_next_to (dialog_heading_color, dialog_heading_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_border_label, 0, 3, 2, 1);
		dialog_grid.attach_next_to (dialog_border_color, dialog_border_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_shadow_label, 0, 4, 2, 1);
		dialog_grid.attach_next_to (dialog_shadow_switch, dialog_shadow_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_tint_label, 0, 5, 2, 1);
		dialog_grid.attach_next_to (dialog_tint_value, dialog_tint_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_gradient_label, 0, 6, 2, 1);
		dialog_grid.attach_next_to (dialog_gradient_value, dialog_gradient_label, PositionType.RIGHT, 1, 1);

		// Apply button
		apply_button = new Button.from_stock (Stock.APPLY);

		apply_button.clicked.connect (on_config_applied);

		var buttons = new ButtonBox (Orientation.HORIZONTAL);
		buttons.set_layout (ButtonBoxStyle.END);
		buttons.add (apply_button);

		notebook = new Notebook ();
		notebook.set_show_tabs (false);
		notebook.append_page (general_grid, null);
		notebook.append_page (panel_grid, null);
		notebook.append_page (paneloverview_grid, null);
		notebook.append_page (overview_grid, null);
		notebook.append_page (dash_grid, null);
		notebook.append_page (button_grid, null);
		notebook.append_page (entry_grid, null);
		notebook.append_page (menu_grid, null);
		notebook.append_page (dialog_grid, null);

		var vbox = new Box (Orientation.VERTICAL, 12);
		vbox.add (notebook);
		vbox.add (buttons);

		ListStore list_store = new ListStore (2, typeof (string), typeof (int));
		TreeIter iter;

		list_store.append (out iter);
		list_store.set (iter, 0, "General", 1, 0);
		list_store.append (out iter);
		list_store.set (iter, 0, "Panel", 1, 1);
		list_store.append (out iter);
		list_store.set (iter, 0, "Panel in overview", 1, 2);
		list_store.append (out iter);
		list_store.set (iter, 0, "Overview", 1, 3);
		list_store.append (out iter);
		list_store.set (iter, 0, "Dash", 1, 4);
		list_store.append (out iter);
		list_store.set (iter, 0, "Buttons", 1, 5);
		list_store.append (out iter);
		list_store.set (iter, 0, "Entry", 1, 6);
		list_store.append (out iter);
		list_store.set (iter, 0, "Menu", 1, 7);
		list_store.append (out iter);
		list_store.set (iter, 0, "Dialogs", 1, 8);

		var view = new TreeView.with_model (list_store);
		view.set_headers_visible (false);

		CellRendererText treecell = new CellRendererText ();
		view.insert_column_with_attributes (-1, "Component", treecell, "text", 0);

		var selection = view.get_selection ();
		selection.changed.connect (on_selection_changed);

		var frame = new Frame (null);
		frame.add (view);

		var hbox = new Box (Orientation.HORIZONTAL, 12);
		hbox.add (frame);
		hbox.add (vbox);

		// Setup widgets
		read_keys ();

		notebook.set_current_page (0);
		apply_button.set_sensitive (false);

		this.add (hbox);
	}

	void on_selection_changed (TreeSelection selection) {
		Gtk.TreeModel model;
		Gtk.TreeIter iter;

		int page;

		if (selection.get_selected (out model, out iter)) {
			model.get (iter, 1, out page);
			notebook.set_current_page (page);
		}
	}

	void on_value_changed () {
		apply_button.set_sensitive (true);
	}

	void on_preset_selected () {

		if (combobox.get_active () !=0) {
			try {
				key_file.load_from_file (presets_dir_sys.get_child (presets [combobox.get_active ()]).get_path (), KeyFileFlags.NONE);
			} catch (Error e) {
				stderr.printf ("Failed to load preset: %s\n", e.message);
			}

			on_load_keyfile ();
		}
	}

	void on_load_keyfile () {
		write_keys ();
		read_keys ();
		apply_button.set_sensitive (false);
	}

	void on_config_applied () {
		write_keys ();
		apply_button.set_sensitive (false);
	}

	void write_keys () {

		if (config_file.query_exists ()) {
			try {
				config_file.delete ();
			} catch (Error e) {
				stderr.printf ("Failed to delete old configuration: %s\n", e.message);
			}
		}

		try {
			string keyfile_str = key_file.to_data ();
			var dos = new DataOutputStream (config_file.create (FileCreateFlags.REPLACE_DESTINATION));
			dos.put_string (keyfile_str);
		} catch (Error e) {
			stderr.printf ("Failed to write configuration: %s\n", e.message);
		}

		try {
			Process.spawn_command_line_sync("elegance-colors apply");
		} catch (Error e) {
			stderr.printf ("Failed to apply changes: %s\n", e.message);
		}
	}
}

class EleganceColorsPref : Gtk.Application {

	internal EleganceColorsPref () {
		Object (application_id: "org.elegance.colors");
	}

	protected override void activate () {
		var window = new EleganceColorsWindow (this);
		window.show_all ();
	}

	protected override void startup () {
		base.startup ();

		var menu = new GLib.Menu ();
		menu.append ("Export theme", "win.export");
		menu.append ("Export settings", "win.exsettings");
		menu.append ("Import settings", "win.impsettings");
		menu.append ("About", "win.about");
		menu.append ("Quit", "win.quit");
		this.app_menu = menu;
	}
}

int main (string[] args) {
	return new EleganceColorsPref ().run (args);
}
