using Gtk;

class EleganceColorsWindow : ApplicationWindow {

	// General
	Label presets_label;
	Label mode_label;
	Label monitor_label;
	Label newbutton_label;
	Label entry_label;
	Label font_label;
	Label selgradient_label;
	Label dashgradient_label;
	Label roundness_label;
	Label transition_label;

	ComboBox combobox;

	RadioButton match_wallpaper;
	RadioButton match_theme;
	RadioButton custom_color;

	ColorButton color_button;

	Switch monitor_switch;
	Switch newbutton_switch;
	Switch entry_switch;

	SpinButton font_size;
	SpinButton selgradient_size;
	SpinButton dashgradient_size;
	SpinButton corner_roundness;
	SpinButton transition_duration;

	Gdk.RGBA selcolor;

	string[] presets = { "Current" };

	string color_value;

	// Panel
	Label panel_bg_label;
	Label panel_fg_label;
	Label panel_bordercol_label;
	Label panel_gradient_label;
	Label panel_opacity_label;
	Label panel_borderop_label;
	Label panel_corner_label;
	Label panel_shadow_label;
	Label panel_icon_label;

	ColorButton panel_bg_color;
	ColorButton panel_fg_color;
	ColorButton panel_bordercol_color;

	Switch panel_shadow_switch;
	Switch panel_icon_switch;

	SpinButton panel_gradient_value;
	SpinButton panel_opacity_value;
	SpinButton panel_borderop_value;
	SpinButton panel_corner_value;

	Gdk.RGBA pbcolor;
	Gdk.RGBA pfcolor;
	Gdk.RGBA bocolor;

	string panel_bg_value;
	string panel_fg_value;
	string panel_bordercol_value;

	// Menu
	Label menu_bg_label;
	Label menu_fg_label;
	Label menu_bordercol_label;
	Label menu_gradient_label;
	Label menu_opacity_label;
	Label menu_borderop_label;
	Label menu_shadow_label;
	Label menu_arrow_label;

	ColorButton menu_bg_color;
	ColorButton menu_fg_color;
	ColorButton menu_bordercol_color;

	Switch menu_shadow_switch;
	Switch menu_arrow_switch;

	SpinButton menu_gradient_value;
	SpinButton menu_opacity_value;
	SpinButton menu_borderop_value;

	Gdk.RGBA mbcolor;
	Gdk.RGBA mfcolor;
	Gdk.RGBA mocolor;

	string menu_bg_value;
	string menu_fg_value;
	string menu_bordercol_value;

	// Dialogs
	Label dialog_bg_label;
	Label dialog_fg_label;
	Label dialog_heading_label;
	Label dialog_bordercol_label;
	Label dialog_gradient_label;
	Label dialog_shadow_label;
	Label dialog_opacity_label;
	Label dialog_borderop_label;

	ColorButton dialog_bg_color;
	ColorButton dialog_fg_color;
	ColorButton dialog_heading_color;
	ColorButton dialog_bordercol_color;

	Switch dialog_shadow_switch;

	SpinButton dialog_gradient_value;
	SpinButton dialog_opacity_value;
	SpinButton dialog_borderop_value;

	Gdk.RGBA dbcolor;
	Gdk.RGBA dfcolor;
	Gdk.RGBA dhcolor;
	Gdk.RGBA docolor;

	string dialog_bg_value;
	string dialog_fg_value;
	string dialog_heading_value;
	string dialog_bordercol_value;

	// Others
	Notebook notebook;

	Button apply_button;
	Button revert_button;
	Button close_button;

	ToggleButton general_tab;
	ToggleButton panel_tab;
	ToggleButton menu_tab;
	ToggleButton dialog_tab;

	File config_dir;
	File config_file;
	File presets_dir_usr;
	File presets_dir_sys;

	KeyFile key_file;

	internal EleganceColorsWindow (EleganceColorsPref app) {
		Object (application: app, title: "Elegance Colors Preferences");

		// Set window properties
		this.window_position = WindowPosition.CENTER;
		this.resizable = false;
		this.border_width = 10;

		// Set window icon
		try {
			this.icon = IconTheme.get_default ().load_icon ("preferences-desktop-theme", 48, 0);
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
		config_dir = File.new_for_path (Environment.get_user_config_dir ());
		config_file = config_dir.get_child ("elegance-colors").get_child ("elegance-colors.ini");
		presets_dir_usr = config_dir.get_child ("elegance-colors").get_child ("presets");
		presets_dir_sys = File.parse_name ("/usr/share/elegance-colors/presets");

		// Methods
		create_widgets ();
		connect_signals ();
	}

	void export_theme () {

		if (apply_button.get_sensitive ()) {
			var dialog = new Dialog.with_buttons ("Apply changes?", this,
									DialogFlags.MODAL,
									Stock.APPLY, ResponseType.APPLY,
									Stock.CANCEL, ResponseType.CANCEL, null);

			var content_area = dialog.get_content_area ();
			var label = new Label ("You need to apply the changes first to export the theme!");

			content_area.border_width = 5;
			content_area.spacing = 10;
			content_area.add (label);

			dialog.response.connect (on_response);

			dialog.show_all ();
		} else {
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
	}

	void import_settings () {

		var importsettings = new FileChooserDialog ("Import preset", this,
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
		}

		importsettings.close ();

		set_states ();
	}

	void export_settings () {

		var exportsettings = new FileChooserDialog ("Export settings", this,
								FileChooserAction.SAVE,
								Stock.CANCEL, ResponseType.CANCEL,
								Stock.SAVE, ResponseType.ACCEPT, null);

		var filter = new FileFilter ();
		filter.add_pattern ("*.ini");

		exportsettings.set_filter (filter);
		exportsettings.set_current_name ("elegance-colors-custom.ini");
		exportsettings.set_do_overwrite_confirmation(true);

		if (exportsettings.run () == ResponseType.ACCEPT) {
			try {
				var exportpath = File.new_for_path (exportsettings.get_file ().get_path ());

				config_file.copy (exportpath, FileCopyFlags.NONE);
				
			} catch (Error e) {
				stderr.printf ("Failed to export settings: %s\n", e.message);
			}
		}

		exportsettings.close ();
	}

	void on_response (Dialog dialog, int response_id) {

		switch (response_id) {
		case ResponseType.OK:
			dialog.destroy ();
			break;
		case ResponseType.APPLY:
			write_config ();
			apply_button.set_sensitive (false);
			dialog.destroy ();
			export_theme ();
			break;
		case ResponseType.CANCEL:
			dialog.destroy ();
			break;
		}
	}

	void show_about (SimpleAction simple, Variant? parameter) {
		string license = "This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.\n\nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License along with This program; if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA";

		show_about_dialog (this,
			"program-name", ("Elegance Colors"),
			"copyright", ("Copyright \xc2\xa9 2012 Satyajit Sahoo"),
			"comments", ("A chameleon theme for Gnome Shell"),
			"license", license,
			"wrap-license", true,
			"website", "http://satya164.deviantart.com/art/Gnome-Shell-Elegance-Colors-305966388",
			"website-label", ("Elegance Colors on deviantArt"),
			null);
	}

	void quit_window () {
		destroy ();
	}

	void set_config () {

		// Read the config file
		key_file = new KeyFile ();

		try {
			key_file.load_from_file (config_file.get_path(), KeyFileFlags.NONE);
		} catch (Error e) {
			stderr.printf ("Failed to read configuration: %s\n", e.message);
		}

		set_states ();
	}

	void set_states () {

		try {
			var mode = key_file.get_string ("Settings", "mode");

			color_value = "rgba(74,144,217,0.9)";

			if (mode == "wallpaper") {
				match_wallpaper.set_active (true);
				match_theme.set_active (false);
				custom_color.set_active (false);
			} else if (mode == "gtk") {
				match_theme.set_active (true);
				match_wallpaper.set_active (false);
				custom_color.set_active (false);
			} else if ("mode=#" in mode || "mode=rgb" in mode) {
				color_value = mode;
				custom_color.set_active (true);
				match_theme.set_active (false);
				match_wallpaper.set_active (false);
				color_button.set_sensitive (true);
			}

			monitor_switch.set_active (key_file.get_boolean ("Settings", "monitor"));
			newbutton_switch.set_active (key_file.get_boolean ("Settings", "newbutton"));
			entry_switch.set_active (key_file.get_boolean ("Settings", "entry"));

			font_size.adjustment.value = key_file.get_double ("Settings", "fontsize");
			selgradient_size.adjustment.value = key_file.get_double ("Settings", "selgradient");
			dashgradient_size.adjustment.value = key_file.get_double ("Settings", "dashgradient");
			corner_roundness.adjustment.value = key_file.get_double ("Settings", "roundness");
			transition_duration.adjustment.value = key_file.get_double ("Settings", "transition");

			panel_bg_value = key_file.get_string ("Panel", "panel_bg");
			panel_fg_value = key_file.get_string ("Panel", "panel_fg");
			panel_bordercol_value = key_file.get_string ("Panel", "panel_bordercol");

			panel_shadow_switch.set_active (key_file.get_boolean ("Panel", "panel_shadow"));
			panel_icon_switch.set_active (key_file.get_boolean ("Panel", "panel_icon"));

			panel_gradient_value.adjustment.value = key_file.get_double ("Panel", "panel_gradient");
			panel_opacity_value.adjustment.value = key_file.get_double ("Panel", "panel_opacity");
			panel_borderop_value.adjustment.value = key_file.get_double ("Panel", "panel_borderop");
			panel_corner_value.adjustment.value = key_file.get_double ("Panel", "panel_corner");

			menu_bg_value = key_file.get_string ("Menu", "menu_bg");
			menu_fg_value = key_file.get_string ("Menu", "menu_fg");
			menu_bordercol_value = key_file.get_string ("Menu", "menu_bordercol");

			menu_shadow_switch.set_active (key_file.get_boolean ("Menu", "menu_shadow"));
			menu_arrow_switch.set_active (key_file.get_boolean ("Menu", "menu_arrow"));

			menu_gradient_value.adjustment.value = key_file.get_double ("Menu", "menu_gradient");
			menu_opacity_value.adjustment.value = key_file.get_double ("Menu", "menu_opacity");
			menu_borderop_value.adjustment.value = key_file.get_double ("Menu", "menu_borderop");

			dialog_bg_value = key_file.get_string ("Dialogs", "dialog_bg");
			dialog_fg_value = key_file.get_string ("Dialogs", "dialog_fg");
			dialog_bordercol_value = key_file.get_string ("Dialogs", "dialog_bordercol");
			dialog_heading_value = key_file.get_string ("Dialogs", "dialog_heading");

			dialog_shadow_switch.set_active (key_file.get_boolean ("Dialogs", "dialog_shadow"));

			dialog_gradient_value.adjustment.value = key_file.get_double ("Dialogs", "dialog_gradient");
			dialog_opacity_value.adjustment.value = key_file.get_double ("Dialogs", "dialog_opacity");
			dialog_borderop_value.adjustment.value = key_file.get_double ("Dialogs", "dialog_borderop");
		} catch (Error e) {
			stderr.printf ("Failed to set properties: %s\n", e.message);
		}
	}

	void set_colors () {

		// Set colors
		selcolor = Gdk.RGBA ();
		selcolor.parse ("%s".printf (color_value));
		color_button.set_rgba (selcolor);

		pbcolor = Gdk.RGBA ();
		pbcolor.parse ("%s".printf (panel_bg_value));
		panel_bg_color.set_rgba (pbcolor);

		pfcolor = Gdk.RGBA ();
		pfcolor.parse ("%s".printf (panel_fg_value));
		panel_fg_color.set_rgba (pfcolor);

		bocolor = Gdk.RGBA ();
		bocolor.parse ("%s".printf (panel_bordercol_value));
		panel_bordercol_color.set_rgba (bocolor);

		mbcolor = Gdk.RGBA ();
		mbcolor.parse ("%s".printf (menu_bg_value));
		menu_bg_color.set_rgba (mbcolor);

		mfcolor = Gdk.RGBA ();
		mfcolor.parse ("%s".printf (menu_fg_value));
		menu_fg_color.set_rgba (mfcolor);

		mocolor = Gdk.RGBA ();
		mocolor.parse ("%s".printf (menu_bordercol_value));
		menu_bordercol_color.set_rgba (mocolor);

		dbcolor = Gdk.RGBA ();
		dbcolor.parse ("%s".printf (dialog_bg_value));
		dialog_bg_color.set_rgba (dbcolor);

		dfcolor = Gdk.RGBA ();
		dfcolor.parse ("%s".printf (dialog_fg_value));
		dialog_fg_color.set_rgba (dfcolor);

		dhcolor = Gdk.RGBA ();
		dhcolor.parse ("%s".printf (dialog_heading_value));
		dialog_heading_color.set_rgba (dhcolor);

		docolor = Gdk.RGBA ();
		docolor.parse ("%s".printf (dialog_bordercol_value));
		dialog_bordercol_color.set_rgba (docolor);
	}

	void create_widgets () {

		// Create and setup widgets

		// General
		presets_label = new Label.with_mnemonic ("Load from preset");
		presets_label.set_halign (Align.START);
		mode_label = new Label.with_mnemonic ("Derive color from");
		mode_label.set_halign (Align.START);
		match_wallpaper = new RadioButton (null);
		match_wallpaper.set_label ("Wallpaper");
		match_theme = new RadioButton.with_label (match_wallpaper.get_group(),"GTK theme");
		custom_color = new RadioButton.with_label (match_theme.get_group(),"Custom");
		color_button = new ColorButton ();
		monitor_label = new Label.with_mnemonic ("Monitor changes");
		monitor_label.set_halign (Align.START);
		monitor_switch = new Switch ();
		monitor_switch.set_halign (Align.END);
		newbutton_label = new Label.with_mnemonic ("New button style");
		newbutton_label.set_halign (Align.START);
		newbutton_switch = new Switch ();
		newbutton_switch.set_halign (Align.END);
		entry_label = new Label.with_mnemonic ("Light entry style");
		entry_label.set_halign (Align.START);
		entry_switch = new Switch ();
		entry_switch.set_halign (Align.END);
		font_label = new Label.with_mnemonic ("Font size");
		font_label.set_halign (Align.START);
		font_size = new SpinButton.with_range (6, 72, 1);
		font_size.set_halign (Align.END);
		selgradient_label = new Label.with_mnemonic ("Selection gradient size");
		selgradient_label.set_halign (Align.START);
		selgradient_size = new SpinButton.with_range (0, 255, 1);
		selgradient_size.set_halign (Align.END);
		dashgradient_label = new Label.with_mnemonic ("Dash gradient size");
		dashgradient_label.set_halign (Align.START);
		dashgradient_size = new SpinButton.with_range (0, 255, 1);
		dashgradient_size.set_halign (Align.END);
		roundness_label = new Label.with_mnemonic ("Roundness");
		roundness_label.set_halign (Align.START);
		corner_roundness = new SpinButton.with_range (0, 100, 1);
		corner_roundness.set_halign (Align.END);
		transition_label = new Label.with_mnemonic ("Transition duration");
		transition_label.set_halign (Align.START);
		transition_duration = new SpinButton.with_range (0, 1000, 1);
		transition_duration.set_halign (Align.END);

		// Panel
		panel_bg_label = new Label.with_mnemonic ("Background color");
		panel_bg_label.set_halign (Align.START);
		panel_bg_color = new ColorButton ();
		panel_fg_label = new Label.with_mnemonic ("Text color");
		panel_fg_label.set_halign (Align.START);
		panel_fg_color = new ColorButton ();
		panel_bordercol_label = new Label.with_mnemonic ("Border color");
		panel_bordercol_label.set_halign (Align.START);
		panel_bordercol_color = new ColorButton ();
		panel_shadow_label = new Label.with_mnemonic ("Drop shadow");
		panel_shadow_label.set_halign (Align.START);
		panel_shadow_switch = new Switch ();
		panel_shadow_switch.set_halign (Align.END);
		panel_icon_label = new Label.with_mnemonic ("App icon");
		panel_icon_label.set_halign (Align.START);
		panel_icon_switch = new Switch ();
		panel_icon_switch.set_halign (Align.END);
		panel_gradient_label = new Label.with_mnemonic ("Gradient size");
		panel_gradient_label.set_halign (Align.START);
		panel_gradient_value = new SpinButton.with_range (0, 255, 1);
		panel_gradient_value.set_halign (Align.END);
		panel_opacity_label = new Label.with_mnemonic ("Background opacity");
		panel_opacity_label.set_halign (Align.START);
		panel_opacity_value = new SpinButton.with_range (0.0, 1.0, 0.1);
		panel_opacity_value.set_halign (Align.END);
		panel_borderop_label = new Label.with_mnemonic ("Border opacity");
		panel_borderop_label.set_halign (Align.START);
		panel_borderop_value = new SpinButton.with_range (0.0, 1.0, 0.1);
		panel_borderop_value.set_halign (Align.END);
		panel_corner_label = new Label.with_mnemonic ("Corner radius");
		panel_corner_label.set_halign (Align.START);
		panel_corner_value = new SpinButton.with_range (0, 100, 1);
		panel_corner_value.set_halign (Align.END);

		// Menu
		menu_bg_label = new Label.with_mnemonic ("Background color");
		menu_bg_label.set_halign (Align.START);
		menu_bg_color = new ColorButton ();
		menu_fg_label = new Label.with_mnemonic ("Text color");
		menu_fg_label.set_halign (Align.START);
		menu_fg_color = new ColorButton ();
		menu_bordercol_label = new Label.with_mnemonic ("Border color");
		menu_bordercol_label.set_halign (Align.START);
		menu_bordercol_color = new ColorButton ();
		menu_shadow_label = new Label.with_mnemonic ("Drop shadow");
		menu_shadow_label.set_halign (Align.START);
		menu_shadow_switch = new Switch ();
		menu_shadow_switch.set_halign (Align.END);
		menu_arrow_label = new Label.with_mnemonic ("Arrow pointer");
		menu_arrow_label.set_halign (Align.START);
		menu_arrow_switch = new Switch ();
		menu_arrow_switch.set_halign (Align.END);
		menu_gradient_label = new Label.with_mnemonic ("Gradient size");
		menu_gradient_label.set_halign (Align.START);
		menu_gradient_value = new SpinButton.with_range (0, 255, 1);
		menu_gradient_value.set_halign (Align.END);
		menu_opacity_label = new Label.with_mnemonic ("Background opacity");
		menu_opacity_label.set_halign (Align.START);
		menu_opacity_value = new SpinButton.with_range (0.0, 1.0, 0.1);
		menu_opacity_value.set_halign (Align.END);
		menu_borderop_label = new Label.with_mnemonic ("Border opacity");
		menu_borderop_label.set_halign (Align.START);
		menu_borderop_value = new SpinButton.with_range (0.0, 1.0, 0.1);
		menu_borderop_value.set_halign (Align.END);

		// Dialogs
		dialog_bg_label = new Label.with_mnemonic ("Background color");
		dialog_bg_label.set_halign (Align.START);
		dialog_bg_color = new ColorButton ();
		dialog_fg_label = new Label.with_mnemonic ("Text color");
		dialog_fg_label.set_halign (Align.START);
		dialog_fg_color = new ColorButton ();
		dialog_heading_label = new Label.with_mnemonic ("Heading color");
		dialog_heading_label.set_halign (Align.START);
		dialog_heading_color = new ColorButton ();
		dialog_bordercol_label = new Label.with_mnemonic ("Border color");
		dialog_bordercol_label.set_halign (Align.START);
		dialog_bordercol_color = new ColorButton ();
		dialog_shadow_label = new Label.with_mnemonic ("Drop shadow");
		dialog_shadow_label.set_halign (Align.START);
		dialog_shadow_switch = new Switch ();
		dialog_shadow_switch.set_halign (Align.END);
		dialog_gradient_label = new Label.with_mnemonic ("Gradient size");
		dialog_gradient_label.set_halign (Align.START);
		dialog_gradient_value = new SpinButton.with_range (0, 255, 1);
		dialog_gradient_value.set_halign (Align.END);
		dialog_opacity_label = new Label.with_mnemonic ("Background opacity");
		dialog_opacity_label.set_halign (Align.START);
		dialog_opacity_value = new SpinButton.with_range (0.0, 1.0, 0.1);
		dialog_opacity_value.set_halign (Align.END);
		dialog_borderop_label = new Label.with_mnemonic ("Border opacity");
		dialog_borderop_label.set_halign (Align.START);
		dialog_borderop_value = new SpinButton.with_range (0.0, 1.0, 0.1);
		dialog_borderop_value.set_halign (Align.END);

		apply_button = new Button.from_stock (Stock.APPLY);
		revert_button = new Button.from_stock(Stock.REVERT_TO_SAVED);
		close_button = new Button.from_stock(Stock.CLOSE);

		general_tab = new ToggleButton.with_label ("General");
		panel_tab = new ToggleButton.with_label ("Panel");
		menu_tab = new ToggleButton.with_label ("Menu");
		dialog_tab = new ToggleButton.with_label ("Dialogs");

		// Read presets
		try {
			var dir = Dir.open(presets_dir_sys.get_path());

			string preset = "";
			while ((preset = dir.read_name()) != null) {
				this.presets += preset;
			}
		} catch (Error e) {
			stderr.printf ("Failed to open presets directory: %s\n", e.message);
		}

		var liststore = new ListStore (1, typeof (string));

		for (int i = 0; i < presets.length; i++){
			TreeIter iter;
			liststore.append (out iter);
			liststore.set (iter, 0, presets[i]);
		}

		var cell = new CellRendererText ();

		combobox = new ComboBox.with_model (liststore);
		combobox.pack_start (cell, false);
		combobox.set_attributes (cell, "text", 0);
		combobox.set_active (0);
		combobox.set_halign (Align.END);

		// Layout widgets

		// General
		var grid0 = new Grid ();
		grid0.set_column_homogeneous (true);
		grid0.set_column_spacing (10);
		grid0.set_row_spacing (10);
		grid0.attach (presets_label, 0, 0, 1, 1);
		grid0.attach_next_to (combobox, presets_label, PositionType.RIGHT, 2, 1);
		grid0.attach (mode_label, 0, 1, 1, 1);
		grid0.attach_next_to (match_wallpaper, mode_label, PositionType.RIGHT, 1, 1);
		grid0.attach_next_to (match_theme, match_wallpaper, PositionType.RIGHT, 1, 1);
		grid0.attach_next_to (custom_color, match_wallpaper, PositionType.BOTTOM, 1, 1);
		grid0.attach_next_to (color_button, custom_color, PositionType.RIGHT, 1, 1);
		grid0.attach (monitor_label, 0, 4, 2, 1);
		grid0.attach_next_to (monitor_switch, monitor_label, PositionType.RIGHT, 1, 1);
		grid0.attach (newbutton_label, 0, 5, 2, 1);
		grid0.attach_next_to (newbutton_switch, newbutton_label, PositionType.RIGHT, 1, 1);
		grid0.attach (entry_label, 0, 6, 2, 1);
		grid0.attach_next_to (entry_switch, entry_label, PositionType.RIGHT, 1, 1);
		grid0.attach (font_label, 0, 7, 2, 1);
		grid0.attach_next_to (font_size, font_label, PositionType.RIGHT, 1, 1);
		grid0.attach (selgradient_label, 0, 8, 2, 1);
		grid0.attach_next_to (selgradient_size, selgradient_label, PositionType.RIGHT, 1, 1);
		grid0.attach (dashgradient_label, 0, 9, 2, 1);
		grid0.attach_next_to (dashgradient_size, dashgradient_label, PositionType.RIGHT, 1, 1);
		grid0.attach (roundness_label, 0, 10, 2, 1);
		grid0.attach_next_to (corner_roundness, roundness_label, PositionType.RIGHT, 1, 1);
		grid0.attach (transition_label, 0, 11, 2, 1);
		grid0.attach_next_to (transition_duration, transition_label, PositionType.RIGHT, 1, 1);

		// Panel
		var grid1 = new Grid ();
		grid1.set_column_homogeneous (true);
		grid1.set_column_spacing (10);
		grid1.set_row_spacing (10);
		grid1.attach (panel_bg_label, 0, 0, 2, 1);
		grid1.attach_next_to (panel_bg_color, panel_bg_label, PositionType.RIGHT, 1, 1);
		grid1.attach (panel_fg_label, 0, 1, 2, 1);
		grid1.attach_next_to (panel_fg_color, panel_fg_label, PositionType.RIGHT, 1, 1);
		grid1.attach (panel_bordercol_label, 0, 2, 2, 1);
		grid1.attach_next_to (panel_bordercol_color, panel_bordercol_label, PositionType.RIGHT, 1, 1);
		grid1.attach (panel_shadow_label, 0, 3, 2, 1);
		grid1.attach_next_to (panel_shadow_switch, panel_shadow_label, PositionType.RIGHT, 1, 1);
		grid1.attach (panel_icon_label, 0, 4, 2, 1);
		grid1.attach_next_to (panel_icon_switch, panel_icon_label, PositionType.RIGHT, 1, 1);
		grid1.attach (panel_gradient_label, 0, 5, 2, 1);
		grid1.attach_next_to (panel_gradient_value, panel_gradient_label, PositionType.RIGHT, 1, 1);
		grid1.attach (panel_opacity_label, 0, 6, 2, 1);
		grid1.attach_next_to (panel_opacity_value, panel_opacity_label, PositionType.RIGHT, 1, 1);
		grid1.attach (panel_borderop_label, 0, 7, 2, 1);
		grid1.attach_next_to (panel_borderop_value, panel_borderop_label, PositionType.RIGHT, 1, 1);
		grid1.attach (panel_corner_label, 0, 8, 2, 1);
		grid1.attach_next_to (panel_corner_value, panel_corner_label, PositionType.RIGHT, 1, 1);

		// Menu
		var grid2 = new Grid ();
		grid2.set_column_homogeneous (true);
		grid2.set_column_spacing (10);
		grid2.set_row_spacing (10);
		grid2.attach (menu_bg_label, 0, 0, 2, 1);
		grid2.attach_next_to (menu_bg_color, menu_bg_label, PositionType.RIGHT, 1, 1);
		grid2.attach (menu_fg_label, 0, 1, 2, 1);
		grid2.attach_next_to (menu_fg_color, menu_fg_label, PositionType.RIGHT, 1, 1);
		grid2.attach (menu_bordercol_label, 0, 2, 2, 1);
		grid2.attach_next_to (menu_bordercol_color, menu_bordercol_label, PositionType.RIGHT, 1, 1);
		grid2.attach (menu_shadow_label, 0, 3, 2, 1);
		grid2.attach_next_to (menu_shadow_switch, menu_shadow_label, PositionType.RIGHT, 1, 1);
		grid2.attach (menu_arrow_label, 0, 4, 2, 1);
		grid2.attach_next_to (menu_arrow_switch, menu_arrow_label, PositionType.RIGHT, 1, 1);
		grid2.attach (menu_gradient_label, 0, 5, 2, 1);
		grid2.attach_next_to (menu_gradient_value, menu_gradient_label, PositionType.RIGHT, 1, 1);
		grid2.attach (menu_opacity_label, 0, 6, 2, 1);
		grid2.attach_next_to (menu_opacity_value, menu_opacity_label, PositionType.RIGHT, 1, 1);
		grid2.attach (menu_borderop_label, 0, 7, 2, 1);
		grid2.attach_next_to (menu_borderop_value, menu_borderop_label, PositionType.RIGHT, 1, 1);

		// Dialogs
		var grid3 = new Grid ();
		grid3.set_column_homogeneous (true);
		grid3.set_column_spacing (10);
		grid3.set_row_spacing (10);
		grid3.attach (dialog_bg_label, 0, 0, 2, 1);
		grid3.attach_next_to (dialog_bg_color, dialog_bg_label, PositionType.RIGHT, 1, 1);
		grid3.attach (dialog_fg_label, 0, 1, 2, 1);
		grid3.attach_next_to (dialog_fg_color, dialog_fg_label, PositionType.RIGHT, 1, 1);
		grid3.attach (dialog_heading_label, 0, 2, 2, 1);
		grid3.attach_next_to (dialog_heading_color, dialog_heading_label, PositionType.RIGHT, 1, 1);
		grid3.attach (dialog_bordercol_label, 0, 3, 2, 1);
		grid3.attach_next_to (dialog_bordercol_color, dialog_bordercol_label, PositionType.RIGHT, 1, 1);
		grid3.attach (dialog_shadow_label, 0, 4, 2, 1);
		grid3.attach_next_to (dialog_shadow_switch, dialog_shadow_label, PositionType.RIGHT, 1, 1);
		grid3.attach (dialog_gradient_label, 0, 5, 2, 1);
		grid3.attach_next_to (dialog_gradient_value, dialog_gradient_label, PositionType.RIGHT, 1, 1);
		grid3.attach (dialog_opacity_label, 0, 6, 2, 1);
		grid3.attach_next_to (dialog_opacity_value, dialog_opacity_label, PositionType.RIGHT, 1, 1);
		grid3.attach (dialog_borderop_label, 0, 7, 2, 1);
		grid3.attach_next_to (dialog_borderop_value, dialog_borderop_label, PositionType.RIGHT, 1, 1);

		// Buttons
		var buttons = new Box (Orientation.HORIZONTAL, 10);
		buttons.pack_start (apply_button, true, true, 0);
		buttons.pack_start (revert_button, true, true, 0);
		buttons.pack_end (close_button, true, true, 0);

		// Tabs
		var tabs = new Box (Orientation.HORIZONTAL, 0);
		tabs.set_homogeneous (true);
		tabs.get_style_context().add_class("linked");
		tabs.add (general_tab);
		tabs.add (panel_tab);
		tabs.add (menu_tab);
		tabs.add (dialog_tab);

		notebook = new Notebook ();
		notebook.set_show_tabs (false);
		notebook.append_page (grid0, new Label ("General"));
		notebook.append_page (grid1, new Label ("Panel"));
		notebook.append_page (grid2, new Label ("Menu"));
		notebook.append_page (grid3, new Label ("Dialogs"));

		var vbox = new Box (Orientation.VERTICAL, 10);
		vbox.add (tabs);
		vbox.add (notebook);
		vbox.add (buttons);

		// Setup widgets
		set_config ();
		set_colors ();

		notebook.set_current_page (0);
		general_tab.set_active (true);
		apply_button.set_sensitive (false);

		this.add (vbox);
	}

	void connect_signals () {
		general_tab.toggled.connect (() => {
			if (general_tab.get_active ()) {
				notebook.set_current_page (0);
				panel_tab.set_active (false);
				menu_tab.set_active (false);
				dialog_tab.set_active (false);
			}
		});
		panel_tab.toggled.connect (() => {
			if (panel_tab.get_active ()) {
				notebook.set_current_page (1);
				general_tab.set_active (false);
				menu_tab.set_active (false);
				dialog_tab.set_active (false);
			}
		});
		menu_tab.toggled.connect (() => {
			if (menu_tab.get_active ()) {
				notebook.set_current_page (2);
				general_tab.set_active (false);
				panel_tab.set_active (false);
				dialog_tab.set_active (false);
			}
		});
		dialog_tab.toggled.connect (() => {
			if (dialog_tab.get_active ()) {
				notebook.set_current_page (3);
				general_tab.set_active (false);
				panel_tab.set_active (false);
				menu_tab.set_active (false);
			}
		});
		combobox.changed.connect (() => {
			on_preset_selected ();
		});
		match_wallpaper.toggled.connect (() => {
			apply_button.set_sensitive (true);
		});
		match_theme.toggled.connect (() => {
			apply_button.set_sensitive (true);
		});
		custom_color.toggled.connect (() => {
			if (custom_color.get_active ()) {
				color_button.set_sensitive (true);
			} else {
				color_button.set_sensitive (false);
			}
			apply_button.set_sensitive (true);
		});
		color_button.color_set.connect (() => {
			on_selected_color_set ();
			apply_button.set_sensitive (true);
		});
		monitor_switch.notify["active"].connect (() => {
			if (monitor_switch.get_active ()) {
				try {
					Process.spawn_command_line_sync("elegance-colors");
				} catch (Error e) {
					stderr.printf ("Failed to start background process: %s\n", e.message);
				}
			} else {
				try {
					Process.spawn_command_line_sync("elegance-colors stop");
				} catch (Error e) {
					stderr.printf ("Failed to stop background process: %s\n", e.message);
				}
			}
			apply_button.set_sensitive (true);
		});
		newbutton_switch.notify["active"].connect (() => {
			apply_button.set_sensitive (true);
		});
		entry_switch.notify["active"].connect (() => {
			apply_button.set_sensitive (true);
		});
		font_size.adjustment.value_changed.connect (() => {
			apply_button.set_sensitive (true);
		});
		selgradient_size.adjustment.value_changed.connect (() => {
			apply_button.set_sensitive (true);
		});
		dashgradient_size.adjustment.value_changed.connect (() => {
			apply_button.set_sensitive (true);
		});
		corner_roundness.adjustment.value_changed.connect (() => {
			apply_button.set_sensitive (true);
		});
		transition_duration.adjustment.value_changed.connect (() => {
			apply_button.set_sensitive (true);
		});
		panel_bg_color.color_set.connect (() => {
			on_panel_bg_color_set ();
			apply_button.set_sensitive (true);
		});
		panel_fg_color.color_set.connect (() => {
			on_panel_fg_color_set ();
			apply_button.set_sensitive (true);
		});
		panel_bordercol_color.color_set.connect (() => {
			on_panel_bordercol_color_set ();
			apply_button.set_sensitive (true);
		});
		panel_shadow_switch.notify["active"].connect (() => {
			apply_button.set_sensitive (true);
		});
		panel_icon_switch.notify["active"].connect (() => {
			apply_button.set_sensitive (true);
		});
		panel_gradient_value.adjustment.value_changed.connect (() => {
			apply_button.set_sensitive (true);
		});
		panel_opacity_value.adjustment.value_changed.connect (() => {
			apply_button.set_sensitive (true);
		});
		panel_borderop_value.adjustment.value_changed.connect (() => {
			apply_button.set_sensitive (true);
		});
		panel_corner_value.adjustment.value_changed.connect (() => {
			apply_button.set_sensitive (true);
		});
		menu_bg_color.color_set.connect (() => {
			on_menu_bg_color_set ();
			apply_button.set_sensitive (true);
		});
		menu_fg_color.color_set.connect (() => {
			on_menu_fg_color_set ();
			apply_button.set_sensitive (true);
		});
		menu_bordercol_color.color_set.connect (() => {
			on_menu_bordercol_color_set ();
			apply_button.set_sensitive (true);
		});
		menu_shadow_switch.notify["active"].connect (() => {
			apply_button.set_sensitive (true);
		});
		menu_arrow_switch.notify["active"].connect (() => {
			apply_button.set_sensitive (true);
		});
		menu_gradient_value.adjustment.value_changed.connect (() => {
			apply_button.set_sensitive (true);
		});
		menu_opacity_value.adjustment.value_changed.connect (() => {
			apply_button.set_sensitive (true);
		});
		menu_borderop_value.adjustment.value_changed.connect (() => {
			apply_button.set_sensitive (true);
		});
		dialog_bg_color.color_set.connect (() => {
			on_dialog_bg_color_set ();
			apply_button.set_sensitive (true);
		});
		dialog_fg_color.color_set.connect (() => {
			on_dialog_fg_color_set ();
			apply_button.set_sensitive (true);
		});
		dialog_heading_color.color_set.connect (() => {
			on_dialog_heading_color_set ();
			apply_button.set_sensitive (true);
		});
		dialog_bordercol_color.color_set.connect (() => {
			on_dialog_bordercol_color_set ();
			apply_button.set_sensitive (true);
		});
		dialog_shadow_switch.notify["active"].connect (() => {
			apply_button.set_sensitive (true);
		});
		dialog_gradient_value.adjustment.value_changed.connect (() => {
			apply_button.set_sensitive (true);
		});
		dialog_opacity_value.adjustment.value_changed.connect (() => {
			apply_button.set_sensitive (true);
		});
		dialog_borderop_value.adjustment.value_changed.connect (() => {
			apply_button.set_sensitive (true);
		});
		apply_button.clicked.connect (() => {
			write_config ();
			apply_button.set_sensitive (false);
		});
		revert_button.clicked.connect (() => {
			set_config ();
			apply_button.set_sensitive (false);
			revert_button.set_sensitive (false);
		});
		close_button.clicked.connect (() => {
			quit_window ();
		});
	}

	void on_selected_color_set () {
		selcolor =  color_button.get_rgba ();
		color_value = "%s".printf (selcolor.to_string());
	}

	void on_panel_bg_color_set () {
		pbcolor =  panel_bg_color.get_rgba ();
		panel_bg_value = "%s".printf (pbcolor.to_string());
	}

	void on_panel_fg_color_set () {
		pfcolor =  panel_fg_color.get_rgba ();
		panel_fg_value = "%s".printf (pfcolor.to_string());
	}

	void on_panel_bordercol_color_set () {
		bocolor =  panel_bordercol_color.get_rgba ();
		panel_bordercol_value = "%s".printf (bocolor.to_string());
	}

	void on_menu_bg_color_set () {
		mbcolor =  menu_bg_color.get_rgba ();
		menu_bg_value = "%s".printf (mbcolor.to_string());
	}

	void on_menu_fg_color_set () {
		mfcolor =  menu_fg_color.get_rgba ();
		menu_fg_value = "%s".printf (mfcolor.to_string());
	}

	void on_menu_bordercol_color_set () {
		mocolor =  menu_bordercol_color.get_rgba ();
		menu_bordercol_value = "%s".printf (mocolor.to_string());
	}

	void on_dialog_bg_color_set () {
		dbcolor =  dialog_bg_color.get_rgba ();
		dialog_bg_value = "%s".printf (dbcolor.to_string());
	}

	void on_dialog_fg_color_set () {
		dfcolor =  dialog_fg_color.get_rgba ();
		dialog_fg_value = "%s".printf (dfcolor.to_string());
	}

	void on_dialog_heading_color_set () {
		dfcolor =  dialog_heading_color.get_rgba ();
		dialog_heading_value = "%s".printf (dfcolor.to_string());
	}

	void on_dialog_bordercol_color_set () {
		docolor =  dialog_bordercol_color.get_rgba ();
		dialog_bordercol_value = "%s".printf (docolor.to_string());
	}

	void on_preset_selected () {

		if (combobox.get_active () !=0) {
			try {
				if (presets_dir_usr.get_child (presets [combobox.get_active ()]).query_exists ()) {
					key_file.load_from_file (presets_dir_usr.get_child (presets [combobox.get_active ()]).get_path (), KeyFileFlags.NONE);
				} else if (presets_dir_sys.get_child (presets [combobox.get_active ()]).query_exists ()) {
					key_file.load_from_file (presets_dir_sys.get_child (presets [combobox.get_active ()]).get_path (), KeyFileFlags.NONE);
				}
			} catch (Error e) {
				stderr.printf ("Failed to load preset: %s\n", e.message);
			}
		}

		set_states ();
	}

	void write_config () {
		if (match_wallpaper.get_active()) {
			key_file.set_string ("Settings", "mode", "wallpaper");
		} else if (match_theme.get_active()) {
			key_file.set_string ("Settings", "mode", "gtk");
		} else if (custom_color.get_active()) {
			key_file.set_string ("Settings", "mode", color_value);
		}

		key_file.set_boolean ("Settings", "monitor", monitor_switch.get_active());
		key_file.set_boolean ("Settings", "newbutton", newbutton_switch.get_active());
		key_file.set_boolean ("Settings", "entry", entry_switch.get_active());

		key_file.set_double ("Settings", "fontsize", font_size.adjustment.value);
		key_file.set_double ("Settings", "selgradient", selgradient_size.adjustment.value);
		key_file.set_double ("Settings", "dashgradient", dashgradient_size.adjustment.value);
		key_file.set_double ("Settings", "roundness", corner_roundness.adjustment.value);
		key_file.set_double ("Settings", "transition", transition_duration.adjustment.value);

		key_file.set_string ("Panel", "panel_bg", panel_bg_value);
		key_file.set_string ("Panel", "panel_fg", panel_fg_value);
		key_file.set_string ("Panel", "panel_bordercol", panel_bordercol_value);

		key_file.set_boolean ("Panel", "panel_shadow", panel_shadow_switch.get_active());
		key_file.set_boolean ("Panel", "panel_icon", panel_icon_switch.get_active());

		key_file.set_double ("Panel", "panel_gradient", panel_gradient_value.adjustment.value);
		key_file.set_double ("Panel", "panel_opacity", panel_opacity_value.adjustment.value);
		key_file.set_double ("Panel", "panel_borderop", panel_borderop_value.adjustment.value);
		key_file.set_double ("Panel", "panel_corner", panel_corner_value.adjustment.value);

		key_file.set_string ("Menu", "menu_bg", menu_bg_value);
		key_file.set_string ("Menu", "menu_fg", menu_fg_value);
		key_file.set_string ("Menu", "menu_bordercol", menu_bordercol_value);

		key_file.set_boolean ("Menu", "menu_shadow", menu_shadow_switch.get_active());
		key_file.set_boolean ("Menu", "menu_arrow", menu_arrow_switch.get_active());

		key_file.set_double ("Menu", "menu_gradient", menu_gradient_value.adjustment.value);
		key_file.set_double ("Menu", "menu_opacity", menu_opacity_value.adjustment.value);
		key_file.set_double ("Menu", "menu_borderop", menu_borderop_value.adjustment.value);

		key_file.set_string ("Dialogs", "dialog_bg", dialog_bg_value);
		key_file.set_string ("Dialogs", "dialog_fg", dialog_fg_value);
		key_file.set_string ("Dialogs", "dialog_heading", dialog_heading_value);
		key_file.set_string ("Dialogs", "dialog_bordercol", dialog_bordercol_value);

		key_file.set_boolean ("Dialogs", "dialog_shadow", dialog_shadow_switch.get_active());

		key_file.set_double ("Dialogs", "dialog_gradient", dialog_gradient_value.adjustment.value);
		key_file.set_double ("Dialogs", "dialog_opacity", dialog_opacity_value.adjustment.value);
		key_file.set_double ("Dialogs", "dialog_borderop", dialog_borderop_value.adjustment.value);

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
