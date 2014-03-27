using Gtk;

class EleganceColorsWindow : ApplicationWindow {

	// General
	ComboBox combobox;

	RadioButton match_wallpaper;
	RadioButton match_theme;
	RadioButton custom_color;
	RadioButton text_auto;
	RadioButton text_color;

	ColorButton color_button;
	ColorButton text_button;

	FontButton font_button;

	Switch dropshadow_switch;

	SpinButton selgradient_size;
	SpinButton corner_roundness;
	SpinButton transition_duration;

	string color_value;
	string text_value;

	string[] presets = { "" };
	string[] titles = { "…" };

	// Panel
	ColorButton panel_bg1_color;
	ColorButton panel_bg2_color;
	ColorButton panel_fg_color;
	ColorButton panel_border_color;

	Switch panel_icon_switch;

	SpinButton panel_tint_value;
	SpinButton panel_bwidth_value;

	string panel_bg1_value;
	string panel_bg2_value;
	string panel_fg_value;
	string panel_border_value;

	// Overview
	ColorButton overview_searchbg1_color;
	ColorButton overview_searchbg2_color;
	ColorButton overview_searchfocusbg1_color;
	ColorButton overview_searchfocusbg2_color;
	ColorButton overview_searchfg_color;
	ColorButton overview_searchfocusfg_color;
	ColorButton overview_searchborder_color;
	ColorButton overview_searchfocusborder_color;

	string overview_searchbg1_value;
	string overview_searchbg2_value;
	string overview_searchfocusbg1_value;
	string overview_searchfocusbg2_value;
	string overview_searchfg_value;
	string overview_searchfocusfg_value;
	string overview_searchborder_value;
	string overview_searchfocusborder_value;

	// Dash
	ColorButton dash_bg1_color;
	ColorButton dash_bg2_color;
	ColorButton dash_fg_color;
	ColorButton dash_border_color;

	SpinButton dash_tint_value;
	SpinButton dash_bwidth_value;

	string dash_bg1_value;
	string dash_bg2_value;
	string dash_fg_value;
	string dash_border_value;

	// Menu
	ColorButton menu_bg1_color;
	ColorButton menu_bg2_color;
	ColorButton menu_fg_color;
	ColorButton menu_border_color;

	Switch menu_arrow_switch;

	SpinButton menu_tint_value;
	SpinButton menu_bwidth_value;

	string menu_bg1_value;
	string menu_bg2_value;
	string menu_fg_value;
	string menu_border_value;

	// Dialogs
	ColorButton dialog_bg1_color;
	ColorButton dialog_bg2_color;
	ColorButton dialog_fg_color;
	ColorButton dialog_heading_color;
	ColorButton dialog_border_color;

	SpinButton dialog_tint_value;
	SpinButton dialog_bwidth_value;

	string dialog_bg1_value;
	string dialog_bg2_value;
	string dialog_fg_value;
	string dialog_heading_value;
	string dialog_border_value;

	// Buttons
	ColorButton button_bg1_color;
	ColorButton button_bg2_color;
	ColorButton button_hoverbg1_color;
	ColorButton button_hoverbg2_color;
	ColorButton button_activebg1_color;
	ColorButton button_activebg2_color;
	ColorButton button_fg_color;
	ColorButton button_hoverfg_color;
	ColorButton button_activefg_color;
	ColorButton button_border_color;
	ColorButton button_hoverborder_color;
	ColorButton button_activeborder_color;

	Switch button_bold_switch;

	string button_bg1_value;
	string button_bg2_value;
	string button_hoverbg1_value;
	string button_hoverbg2_value;
	string button_activebg1_value;
	string button_activebg2_value;
	string button_fg_value;
	string button_hoverfg_value;
	string button_activefg_value;
	string button_border_value;
	string button_hoverborder_value;
	string button_activeborder_value;

	// Focused buttons
	ColorButton buttonfocus_bg1_color;
	ColorButton buttonfocus_bg2_color;
	ColorButton buttonfocus_hoverbg1_color;
	ColorButton buttonfocus_hoverbg2_color;
	ColorButton buttonfocus_activebg1_color;
	ColorButton buttonfocus_activebg2_color;
	ColorButton buttonfocus_fg_color;
	ColorButton buttonfocus_hoverfg_color;
	ColorButton buttonfocus_activefg_color;
	ColorButton buttonfocus_border_color;
	ColorButton buttonfocus_hoverborder_color;
	ColorButton buttonfocus_activeborder_color;

	string buttonfocus_bg1_value;
	string buttonfocus_bg2_value;
	string buttonfocus_hoverbg1_value;
	string buttonfocus_hoverbg2_value;
	string buttonfocus_activebg1_value;
	string buttonfocus_activebg2_value;
	string buttonfocus_fg_value;
	string buttonfocus_hoverfg_value;
	string buttonfocus_activefg_value;
	string buttonfocus_border_value;
	string buttonfocus_hoverborder_value;
	string buttonfocus_activeborder_value;

	// Entry
	ColorButton entry_bg1_color;
	ColorButton entry_bg2_color;
	ColorButton entry_fg_color;
	ColorButton entry_border_color;

	Switch entry_shadow_switch;

	string entry_bg1_value;
	string entry_bg2_value;
	string entry_fg_value;
	string entry_border_value;

	// Misc
	ColorButton misc_runningbg1_color;
	ColorButton misc_runningbg2_color;
	ColorButton misc_separator1_color;
	ColorButton misc_separator2_color;
	ColorButton misc_tooltipbg1_color;
	ColorButton misc_tooltipbg2_color;
	ColorButton misc_tooltipfg_color;
	ColorButton misc_tooltipborder_color;
	ColorButton misc_insensitive_color;

	string misc_runningbg1_value;
	string misc_runningbg2_value;
	string misc_separator1_value;
	string misc_separator2_value;
	string misc_tooltipbg1_value;
	string misc_tooltipbg2_value;
	string misc_tooltipfg_value;
	string misc_tooltipborder_value;
	string misc_insensitive_value;

	// Toolbar
	ToolButton undo_button;
	ToolButton redo_button;
	ToolButton clear_button;

	List<string> list_undo = new List<string> ();
	List<string> list_redo = new List<string> ();

	bool new_button_clicked = false;

	// Others
	Notebook notebook;

	Button apply_button;

	File config_file;
	File presets_dir_usr;
	File presets_dir_sys;

	string elegance_colors;

	KeyFile key_file;

	internal EleganceColorsWindow (EleganceColorsPref app) {
		Object (application: app, title: "Elegance Colors Preferences");

		// Set window properties
		this.window_position = WindowPosition.CENTER;
		this.resizable = false;
		this.border_width = 0;

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
		var script = File.new_for_path ("elegance-colors");
		var presets = File.new_for_path ("presets");

		if (script.query_exists () && script.query_file_type (0) == FileType.REGULAR && presets.query_exists () && presets.query_file_type (0) == FileType.DIRECTORY) {
			presets_dir_sys = presets;
			elegance_colors = "./elegance-colors";
		} else {
			presets_dir_sys = File.parse_name ("/usr/share/elegance-colors/presets");
			elegance_colors = "elegance-colors";
		}

		var config_dir = File.new_for_path (Environment.get_user_config_dir ()).get_child ("elegance-colors");
		config_file = config_dir.get_child ("elegance-colors.ini");
		presets_dir_usr = config_dir.get_child ("presets");

		key_file = new KeyFile ();

		// Methods
		init_process ();
		load_config ();
		create_widgets ();
	}

	void init_process () {

		var theme_file = File.new_for_path (Environment.get_home_dir ()).get_child (".themes/elegance-colors/gnome-shell/gnome-shell.css");

		if (!theme_file.query_exists () || !config_file.query_exists ()) {
			try {
				Process.spawn_command_line_async ("%s".printf (elegance_colors));
			} catch (Error e) {
				stderr.printf ("Failed to run process: %s\n", e.message);
			}
			try {
				key_file.load_from_file (presets_dir_sys.get_child ("default.ini").get_path (), KeyFileFlags.NONE);
			} catch (Error e) {
				stderr.printf ("Failed to load default preset: %s\n", e.message);
			}
		}
	}

	void export_theme () {

		var exportdialog = new FileChooserDialog ("Export theme", this,
								FileChooserAction.SAVE,
								"Cancel", ResponseType.CANCEL,
								"Export", ResponseType.ACCEPT, null);

		var filter = new FileFilter ();
		filter.add_pattern ("*.zip");

		exportdialog.set_filter (filter);
		exportdialog.set_current_name ("Elegance Colors Custom.zip");
		exportdialog.set_do_overwrite_confirmation (true);

		if (exportdialog.run () == ResponseType.ACCEPT) {
			try {
				string theme_path = exportdialog.get_file ().get_path ();
				Process.spawn_command_line_sync ("%s export \"%s\"".printf (elegance_colors, theme_path));
			} catch (Error e) {
				stderr.printf ("Failed to export theme: %s\n", e.message);
			}
		}

		exportdialog.close ();
	}

	void export_settings () {

		var exportsettings = new FileChooserDialog ("Export settings", this,
								FileChooserAction.SAVE,
								"Cancel", ResponseType.CANCEL,
								"Export", ResponseType.ACCEPT, null);

		var filter = new FileFilter ();
		filter.add_pattern ("*.ini");

		exportsettings.set_filter (filter);
		exportsettings.set_current_name ("elegance-colors-exported.ini");
		exportsettings.set_do_overwrite_confirmation (true);

		if (exportsettings.run () == ResponseType.ACCEPT) {
			try {
				string keyfile_str = key_file.to_data ();
				var exportpath = File.new_for_path (exportsettings.get_file ().get_path ());
				var dos = new DataOutputStream (exportpath.replace (null, false, FileCreateFlags.REPLACE_DESTINATION));
				dos.put_string (keyfile_str);
			} catch (Error e) {
				stderr.printf ("Failed to export settings: %s\n", e.message);
			}
		}

		exportsettings.close ();
	}

	void import_settings () {

		var importsettings = new FileChooserDialog ("Import settings", this,
								FileChooserAction.OPEN,
								"Cancel", ResponseType.CANCEL,
								"Import", ResponseType.ACCEPT, null);

		var filter = new FileFilter ();
		filter.add_pattern ("*.ini");

		importsettings.set_filter (filter);

		if (importsettings.run () == ResponseType.ACCEPT) {
			try {
				var importpath = File.new_for_path (importsettings.get_file ().get_path ());
				key_file.load_from_file (importpath.get_path (), KeyFileFlags.NONE);
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
			"comments", "Highly customizable chameleon theme for Gnome Shell",
			"license", license,
			"wrap-license", true,
			"website", "https://github.com/satya164/elegance-colors",
			"website-label", "Elegance Colors on GitHub",
			null);
	}

	void quit_window () {
		destroy ();
	}

	void load_config () {

		// Read the config file
		try {
			key_file.load_from_file (config_file.get_path (), KeyFileFlags.NONE);
		} catch (Error e) {
			stderr.printf ("Failed to read configuration: %s\n", e.message);
		}
	}

	void set_states () {

		try {
			var mode = key_file.get_string ("Settings", "mode");

			if (mode == "wallpaper") {
				match_wallpaper.set_active (true);
				color_button.set_sensitive (false);
			} else if (mode == "gtk") {
				match_theme.set_active (true);
				color_button.set_sensitive (false);
			} else {
				custom_color.set_active (true);
				color_button.set_sensitive (true);
			}

			color_value = key_file.get_string ("Settings", "highlight");

			var text = key_file.get_string ("Settings", "text");

			if (text == "auto") {
				text_auto.set_active (true);
				text_button.set_sensitive (false);
			} else {
				text_color.set_active (true);
				text_button.set_sensitive (true);
			}

			text_value = key_file.get_string ("Settings", "textcolor");

			font_button.set_font_name (key_file.get_string ("Settings", "fontname"));

			dropshadow_switch.set_active (key_file.get_boolean ("Settings", "dropshadow"));

			selgradient_size.adjustment.value = key_file.get_double ("Settings", "selgradient");
			corner_roundness.adjustment.value = key_file.get_double ("Settings", "roundness");
			transition_duration.adjustment.value = key_file.get_double ("Settings", "transition");
		} catch (Error e) {
			stderr.printf ("Failed to set properties: %s\n", e.message);
		}

		try {
			panel_bg1_value = key_file.get_string ("Panel", "panel_bg1");
			panel_bg2_value = key_file.get_string ("Panel", "panel_bg2");
			panel_fg_value = key_file.get_string ("Panel", "panel_fg");
			panel_border_value = key_file.get_string ("Panel", "panel_border");

			panel_icon_switch.set_active (key_file.get_boolean ("Panel", "panel_icon"));

			panel_tint_value.adjustment.value = key_file.get_double ("Panel", "panel_tint");
			panel_bwidth_value.adjustment.value = key_file.get_double ("Panel", "panel_bwidth");
		} catch (Error e) {
			stderr.printf ("Failed to set properties: %s\n", e.message);
		}

		try {
			overview_searchbg1_value = key_file.get_string ("Overview", "overview_searchbg1");
			overview_searchbg2_value = key_file.get_string ("Overview", "overview_searchbg2");
			overview_searchfocusbg1_value = key_file.get_string ("Overview", "overview_searchfocusbg1");
			overview_searchfocusbg2_value = key_file.get_string ("Overview", "overview_searchfocusbg2");
			overview_searchfg_value = key_file.get_string ("Overview", "overview_searchfg");
			overview_searchfocusfg_value = key_file.get_string ("Overview", "overview_searchfocusfg");
			overview_searchborder_value = key_file.get_string ("Overview", "overview_searchborder");
			overview_searchfocusborder_value = key_file.get_string ("Overview", "overview_searchfocusborder");
		} catch (Error e) {
			stderr.printf ("Failed to set properties: %s\n", e.message);
		}

		try {
			dash_bg1_value = key_file.get_string ("Dash", "dash_bg1");
			dash_bg2_value = key_file.get_string ("Dash", "dash_bg2");
			dash_fg_value = key_file.get_string ("Dash", "dash_fg");
			dash_border_value = key_file.get_string ("Dash", "dash_border");

			dash_tint_value.adjustment.value = key_file.get_double ("Dash", "dash_tint");
			dash_bwidth_value.adjustment.value = key_file.get_double ("Dash", "dash_bwidth");
		} catch (Error e) {
			stderr.printf ("Failed to set properties: %s\n", e.message);
		}

		try {
			menu_bg1_value = key_file.get_string ("Menu", "menu_bg1");
			menu_bg2_value = key_file.get_string ("Menu", "menu_bg2");
			menu_fg_value = key_file.get_string ("Menu", "menu_fg");
			menu_border_value = key_file.get_string ("Menu", "menu_border");

			menu_arrow_switch.set_active (key_file.get_boolean ("Menu", "menu_arrow"));

			menu_tint_value.adjustment.value = key_file.get_double ("Menu", "menu_tint");
			menu_bwidth_value.adjustment.value = key_file.get_double ("Menu", "menu_bwidth");
		} catch (Error e) {
			stderr.printf ("Failed to set properties: %s\n", e.message);
		}

		try {
			dialog_bg1_value = key_file.get_string ("Dialogs", "dialog_bg1");
			dialog_bg2_value = key_file.get_string ("Dialogs", "dialog_bg2");
			dialog_fg_value = key_file.get_string ("Dialogs", "dialog_fg");
			dialog_border_value = key_file.get_string ("Dialogs", "dialog_border");
			dialog_heading_value = key_file.get_string ("Dialogs", "dialog_heading");

			dialog_tint_value.adjustment.value = key_file.get_double ("Dialogs", "dialog_tint");
			dialog_bwidth_value.adjustment.value = key_file.get_double ("Dialogs", "dialog_bwidth");
		} catch (Error e) {
			stderr.printf ("Failed to set properties: %s\n", e.message);
		}

		try {
			button_bg1_value = key_file.get_string ("Buttons", "button_bg1");
			button_bg2_value = key_file.get_string ("Buttons", "button_bg2");
			button_hoverbg1_value = key_file.get_string ("Buttons", "button_hoverbg1");
			button_hoverbg2_value = key_file.get_string ("Buttons", "button_hoverbg2");
			button_activebg1_value = key_file.get_string ("Buttons", "button_activebg1");
			button_activebg2_value = key_file.get_string ("Buttons", "button_activebg2");
			button_fg_value = key_file.get_string ("Buttons", "button_fg");
			button_hoverfg_value = key_file.get_string ("Buttons", "button_hoverfg");
			button_activefg_value = key_file.get_string ("Buttons", "button_activefg");
			button_border_value = key_file.get_string ("Buttons", "button_border");
			button_hoverborder_value = key_file.get_string ("Buttons", "button_hoverborder");
			button_activeborder_value = key_file.get_string ("Buttons", "button_activeborder");

			button_bold_switch.set_active (key_file.get_boolean ("Buttons", "button_bold"));
		} catch (Error e) {
			stderr.printf ("Failed to set properties: %s\n", e.message);
		}

		try {
			buttonfocus_bg1_value = key_file.get_string ("ButtonsFocus", "buttonfocus_bg1");
			buttonfocus_bg2_value = key_file.get_string ("ButtonsFocus", "buttonfocus_bg2");
			buttonfocus_hoverbg1_value = key_file.get_string ("ButtonsFocus", "buttonfocus_hoverbg1");
			buttonfocus_hoverbg2_value = key_file.get_string ("ButtonsFocus", "buttonfocus_hoverbg2");
			buttonfocus_activebg1_value = key_file.get_string ("ButtonsFocus", "buttonfocus_activebg1");
			buttonfocus_activebg2_value = key_file.get_string ("ButtonsFocus", "buttonfocus_activebg2");
			buttonfocus_fg_value = key_file.get_string ("ButtonsFocus", "buttonfocus_fg");
			buttonfocus_hoverfg_value = key_file.get_string ("ButtonsFocus", "buttonfocus_hoverfg");
			buttonfocus_activefg_value = key_file.get_string ("ButtonsFocus", "buttonfocus_activefg");
			buttonfocus_border_value = key_file.get_string ("ButtonsFocus", "buttonfocus_border");
			buttonfocus_hoverborder_value = key_file.get_string ("ButtonsFocus", "buttonfocus_hoverborder");
			buttonfocus_activeborder_value = key_file.get_string ("ButtonsFocus", "buttonfocus_activeborder");
		} catch (Error e) {
			stderr.printf ("Failed to set properties: %s\n", e.message);
		}

		try {
			entry_bg1_value = key_file.get_string ("Entry", "entry_bg1");
			entry_bg2_value = key_file.get_string ("Entry", "entry_bg2");
			entry_fg_value = key_file.get_string ("Entry", "entry_fg");
			entry_border_value = key_file.get_string ("Entry", "entry_border");

			entry_shadow_switch.set_active (key_file.get_boolean ("Entry", "entry_shadow"));
		} catch (Error e) {
			stderr.printf ("Failed to set properties: %s\n", e.message);
		}

		try {
			misc_runningbg1_value = key_file.get_string ("Misc", "misc_runningbg1");
			misc_runningbg2_value = key_file.get_string ("Misc", "misc_runningbg2");
			misc_separator1_value = key_file.get_string ("Misc", "misc_separator1");
			misc_separator2_value = key_file.get_string ("Misc", "misc_separator2");
			misc_tooltipbg1_value = key_file.get_string ("Misc", "misc_tooltipbg1");
			misc_tooltipbg2_value = key_file.get_string ("Misc", "misc_tooltipbg2");
			misc_tooltipfg_value = key_file.get_string ("Misc", "misc_tooltipfg");
			misc_tooltipborder_value = key_file.get_string ("Misc", "misc_tooltipborder");
			misc_insensitive_value = key_file.get_string ("Misc", "misc_insensitive");
		} catch (Error e) {
			stderr.printf ("Failed to set properties: %s\n", e.message);
		}

		// Set colors
		var color = Gdk.RGBA ();

		color.parse (color_value);
		color_button.set_rgba (color);

		color.parse (text_value);
		text_button.set_rgba (color);

		color.parse (panel_bg1_value);
		panel_bg1_color.set_rgba (color);

		color.parse (panel_bg2_value);
		panel_bg2_color.set_rgba (color);

		color.parse (panel_fg_value);
		panel_fg_color.set_rgba (color);

		color.parse (panel_border_value);
		panel_border_color.set_rgba (color);

		color.parse (overview_searchbg1_value);
		overview_searchbg1_color.set_rgba (color);

		color.parse (overview_searchbg2_value);
		overview_searchbg2_color.set_rgba (color);

		color.parse (overview_searchfocusbg1_value);
		overview_searchfocusbg1_color.set_rgba (color);

		color.parse (overview_searchfocusbg2_value);
		overview_searchfocusbg2_color.set_rgba (color);

		color.parse (overview_searchfg_value);
		overview_searchfg_color.set_rgba (color);

		color.parse (overview_searchborder_value);
		overview_searchborder_color.set_rgba (color);

		color.parse (dash_bg1_value);
		dash_bg1_color.set_rgba (color);

		color.parse (dash_bg2_value);
		dash_bg2_color.set_rgba (color);

		color.parse (dash_fg_value);
		dash_fg_color.set_rgba (color);

		color.parse (dash_border_value);
		dash_border_color.set_rgba (color);

		color.parse (menu_bg1_value);
		menu_bg1_color.set_rgba (color);

		color.parse (menu_bg2_value);
		menu_bg2_color.set_rgba (color);

		color.parse (menu_fg_value);
		menu_fg_color.set_rgba (color);

		color.parse (menu_border_value);
		menu_border_color.set_rgba (color);

		color.parse (dialog_bg1_value);
		dialog_bg1_color.set_rgba (color);

		color.parse (dialog_bg2_value);
		dialog_bg2_color.set_rgba (color);

		color.parse (dialog_fg_value);
		dialog_fg_color.set_rgba (color);

		color.parse (dialog_heading_value);
		dialog_heading_color.set_rgba (color);

		color.parse (dialog_border_value);
		dialog_border_color.set_rgba (color);

		color.parse (button_bg1_value);
		button_bg1_color.set_rgba (color);

		color.parse (button_bg2_value);
		button_bg2_color.set_rgba (color);

		color.parse (button_hoverbg1_value);
		button_hoverbg1_color.set_rgba (color);

		color.parse (button_hoverbg2_value);
		button_hoverbg2_color.set_rgba (color);

		color.parse (button_activebg1_value);
		button_activebg1_color.set_rgba (color);

		color.parse (button_activebg2_value);
		button_activebg2_color.set_rgba (color);

		color.parse (button_fg_value);
		button_fg_color.set_rgba (color);

		color.parse (button_hoverfg_value);
		button_hoverfg_color.set_rgba (color);

		color.parse (button_activefg_value);
		button_activefg_color.set_rgba (color);

		color.parse (button_border_value);
		button_border_color.set_rgba (color);

		color.parse (button_hoverborder_value);
		button_hoverborder_color.set_rgba (color);

		color.parse (button_activeborder_value);
		button_activeborder_color.set_rgba (color);

		color.parse (buttonfocus_bg1_value);
		buttonfocus_bg1_color.set_rgba (color);

		color.parse (buttonfocus_bg2_value);
		buttonfocus_bg2_color.set_rgba (color);

		color.parse (buttonfocus_hoverbg1_value);
		buttonfocus_hoverbg1_color.set_rgba (color);

		color.parse (buttonfocus_hoverbg2_value);
		buttonfocus_hoverbg2_color.set_rgba (color);

		color.parse (buttonfocus_activebg1_value);
		buttonfocus_activebg1_color.set_rgba (color);

		color.parse (buttonfocus_activebg2_value);
		buttonfocus_activebg2_color.set_rgba (color);

		color.parse (buttonfocus_fg_value);
		buttonfocus_fg_color.set_rgba (color);

		color.parse (buttonfocus_hoverfg_value);
		buttonfocus_hoverfg_color.set_rgba (color);

		color.parse (buttonfocus_activefg_value);
		buttonfocus_activefg_color.set_rgba (color);

		color.parse (buttonfocus_border_value);
		buttonfocus_border_color.set_rgba (color);

		color.parse (buttonfocus_hoverborder_value);
		buttonfocus_hoverborder_color.set_rgba (color);

		color.parse (buttonfocus_activeborder_value);
		buttonfocus_activeborder_color.set_rgba (color);

		color.parse (entry_bg1_value);
		entry_bg1_color.set_rgba (color);

		color.parse (entry_bg2_value);
		entry_bg2_color.set_rgba (color);

		color.parse (entry_fg_value);
		entry_fg_color.set_rgba (color);

		color.parse (entry_border_value);
		entry_border_color.set_rgba (color);

		color.parse (misc_runningbg1_value);
		misc_runningbg1_color.set_rgba (color);

		color.parse (misc_runningbg2_value);
		misc_runningbg2_color.set_rgba (color);

		color.parse (misc_separator1_value);
		misc_separator1_color.set_rgba (color);

		color.parse (misc_separator2_value);
		misc_separator2_color.set_rgba (color);

		color.parse (misc_tooltipbg1_value);
		misc_tooltipbg1_color.set_rgba (color);

		color.parse (misc_tooltipbg2_value);
		misc_tooltipbg2_color.set_rgba (color);

		color.parse (misc_tooltipfg_value);
		misc_tooltipfg_color.set_rgba (color);

		color.parse (misc_tooltipborder_value);
		misc_tooltipborder_color.set_rgba (color);

		color.parse (misc_insensitive_value);
		misc_insensitive_color.set_rgba (color);

		// Grey out "GTK theme" button if the theme uses gresource system
		var gtk_theme = new GLib.Settings ("org.gnome.desktop.interface").get_string ("gtk-theme");

		if (File.new_for_path (Environment.get_home_dir ()).get_child (".themes/%s/gtk-3.0/gtk.gresource".printf (gtk_theme)).query_exists () || File.parse_name ("/usr/share/themes/%s/gtk-3.0/gtk.gresource".printf (gtk_theme)).query_exists ()) {
			match_theme.set_sensitive (false);
			if (match_theme.get_active ()) {
				custom_color.set_active (true);
				color_button.set_sensitive (true);
			}
		}
	}

	void create_widgets () {

		// Create and setup widgets

		// General
		var presets_label = new Label.with_mnemonic ("Load config from preset");
		presets_label.set_halign (Align.START);

		// Create user presets directory if doesn't exist
		if (!presets_dir_usr.query_exists ()) {
			try {
				presets_dir_usr.make_directory_with_parents (null);
			} catch (Error e) {
				stderr.printf ("Could not create user presets directory: %s\n", e.message);
			}
		}

		// Read presets from user dir
		try {
			var dir = Dir.open (presets_dir_usr.get_path ());

			var titlechanged = false;

			string preset = "";
			string title = "";
			while ((preset = dir.read_name ()) != null) {
				var path = Path.build_filename (presets_dir_usr.get_path (), preset);

				if (FileUtils.test (path, FileTest.IS_REGULAR)) {
					presets += preset;

					try {
						var dis = new DataInputStream (presets_dir_usr.get_child (preset).read ());
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
			}
		} catch (Error e) {
			stderr.printf ("Failed to open user presets directory: %s\n", e.message);
		}

		// Read presets from system dir
		try {
			var dir = Dir.open (presets_dir_sys.get_path ());

			var titlechanged = false;

			string preset = "";
			string title = "";
			while ((preset = dir.read_name ()) != null) {
				var path = Path.build_filename (presets_dir_sys.get_path (), preset);

				if (FileUtils.test (path, FileTest.IS_REGULAR)) {
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
			}
		} catch (Error e) {
			stderr.printf ("Failed to open systemwide presets directory: %s\n", e.message);
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
		combobox.set_tooltip_text ("Load settings from an installed preset");
		combobox.set_halign (Align.END);

		var mode_label = new Label.with_mnemonic ("Derive color from");
		mode_label.set_halign (Align.START);
		match_wallpaper = new RadioButton (null);
		match_wallpaper.set_label ("Wallpaper");
		match_wallpaper.set_mode (false);
		match_wallpaper.set_tooltip_text ("Derive the highlight color from the current wallpaper");
		match_theme = new RadioButton.with_label (match_wallpaper.get_group (), "GTK theme");
		match_theme.set_mode (false);
		match_theme.set_tooltip_text ("Derive the highlight color from the current GTK theme");
		custom_color = new RadioButton.with_label (match_theme.get_group (), "Custom");
		custom_color.set_mode (false);
		custom_color.set_tooltip_text ("Manually set a custom highlight color");
		color_button = new ColorButton ();
		((ColorChooser) color_button).set_use_alpha (true);
		color_button.set_tooltip_text ("Set a custom highlight color");
		var text_label = new Label.with_mnemonic ("Highlight text color");
		text_label.set_halign (Align.START);
		text_auto = new RadioButton (null);
		text_auto.set_label ("Automatic");
		text_auto.set_mode (false);
		text_auto.set_tooltip_text ("Automatically determine the highlight text color");
		text_color = new RadioButton.with_label (text_auto.get_group (), "Custom");
		text_color.set_mode (false);
		text_color.set_tooltip_text ("Manually set a custom highlight text color");
		text_button = new ColorButton ();
		((ColorChooser) text_button).set_use_alpha (true);
		text_button.set_tooltip_text ("Set a custom highlight text color");
		var font_label = new Label.with_mnemonic ("Display font");
		font_label.set_halign (Align.START);
		font_button = new FontButton ();
		font_button.set_title ("Choose a font");
		font_button.set_use_font (true);
		font_button.set_use_size (true);
		font_button.set_tooltip_text ("Choose the shell font family and font size");
		font_button.set_halign (Align.END);
		var dropshadow_label = new Label.with_mnemonic ("Drop shadows");
		dropshadow_label.set_halign (Align.START);
		dropshadow_switch = new Switch ();
		dropshadow_switch.set_tooltip_text ("Enable/disable drop shadows");
		dropshadow_switch.set_halign (Align.END);
		var selgradient_label = new Label.with_mnemonic ("Highlight gradient size");
		selgradient_label.set_halign (Align.START);
		selgradient_size = new SpinButton.with_range (0, 255, 1);
		selgradient_size.set_tooltip_text ("Set the gradient size for highlight color");
		selgradient_size.set_halign (Align.END);
		var roundness_label = new Label.with_mnemonic ("Roundness");
		roundness_label.set_halign (Align.START);
		corner_roundness = new SpinButton.with_range (0, 100, 1);
		corner_roundness.set_tooltip_text ("Set the border radius of various elements");
		corner_roundness.set_halign (Align.END);
		var transition_label = new Label.with_mnemonic ("Transition duration");
		transition_label.set_halign (Align.START);
		transition_duration = new SpinButton.with_range (0, 1000, 1);
		transition_duration.set_tooltip_text ("Set the duration of the transition animations");
		transition_duration.set_halign (Align.END);

		var colorbox = new Box (Orientation.HORIZONTAL, 0);
		colorbox.set_halign (Align.END);
		colorbox.set_homogeneous (true);
		colorbox.get_style_context ().add_class ("linked");
		colorbox.add (match_wallpaper);
		colorbox.add (match_theme);
		colorbox.add (custom_color);
		colorbox.add (color_button);

		var textbox = new Box (Orientation.HORIZONTAL, 0);
		textbox.set_halign (Align.END);
		textbox.set_homogeneous (true);
		textbox.get_style_context ().add_class ("linked");
		textbox.add (text_auto);
		textbox.add (text_color);
		textbox.add (text_button);

		var general_grid = new Grid ();
		general_grid.set_column_homogeneous (true);
		general_grid.set_column_spacing (10);
		general_grid.set_row_spacing (10);
		general_grid.attach (presets_label, 0, 0, 1, 1);
		general_grid.attach_next_to (combobox, presets_label, PositionType.RIGHT, 2, 1);
		general_grid.attach (mode_label, 0, 1, 1, 1);
		general_grid.attach_next_to (colorbox, mode_label, PositionType.RIGHT, 2, 1);
		general_grid.attach (text_label, 0, 2, 1, 1);
		general_grid.attach_next_to (textbox, text_label, PositionType.RIGHT, 2, 1);
		general_grid.attach (font_label, 0, 3, 1, 1);
		general_grid.attach_next_to (font_button, font_label, PositionType.RIGHT, 2, 1);
		general_grid.attach (dropshadow_label, 0, 4, 2, 1);
		general_grid.attach_next_to (dropshadow_switch, dropshadow_label, PositionType.RIGHT, 1, 1);
		general_grid.attach (selgradient_label, 0, 5, 2, 1);
		general_grid.attach_next_to (selgradient_size, selgradient_label, PositionType.RIGHT, 1, 1);
		general_grid.attach (roundness_label, 0, 6, 2, 1);
		general_grid.attach_next_to (corner_roundness, roundness_label, PositionType.RIGHT, 1, 1);
		general_grid.attach (transition_label, 0, 7, 2, 1);
		general_grid.attach_next_to (transition_duration, transition_label, PositionType.RIGHT, 1, 1);

		// Panel
		var panel_bg_label = new Label.with_mnemonic ("Background gradient");
		panel_bg_label.set_halign (Align.START);
		panel_bg1_color = new ColorButton ();
		((ColorChooser) panel_bg1_color).set_use_alpha (true);
		panel_bg1_color.set_tooltip_text ("Set the background gradient start of the top panel");
		panel_bg2_color = new ColorButton ();
		((ColorChooser) panel_bg2_color).set_use_alpha (true);
		panel_bg2_color.set_tooltip_text ("Set the background gradient end of the top panel");
		var panel_fg_label = new Label.with_mnemonic ("Text color");
		panel_fg_label.set_halign (Align.START);
		panel_fg_color = new ColorButton ();
		((ColorChooser) panel_fg_color).set_use_alpha (true);
		panel_fg_color.set_tooltip_text ("Set the text color of the top panel");
		var panel_border_label = new Label.with_mnemonic ("Border color");
		panel_border_label.set_halign (Align.START);
		panel_border_color = new ColorButton ();
		((ColorChooser) panel_border_color).set_use_alpha (true);
		panel_border_color.set_tooltip_text ("Set the border color of the top panel");
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
		var panel_bwidth_label = new Label.with_mnemonic ("Border width");
		panel_bwidth_label.set_halign (Align.START);
		panel_bwidth_value = new SpinButton.with_range (0, 100, 1);
		panel_bwidth_value.set_tooltip_text ("Set the width of the border of the top panel");
		panel_bwidth_value.set_halign (Align.END);

		var panel_bg_box = new Box (Orientation.HORIZONTAL, 0);
		panel_bg_box.set_homogeneous (true);
		panel_bg_box.get_style_context ().add_class ("linked");
		panel_bg_box.add (panel_bg1_color);
		panel_bg_box.add (panel_bg2_color);

		var panel_grid = new Grid ();
		panel_grid.set_column_homogeneous (true);
		panel_grid.set_column_spacing (10);
		panel_grid.set_row_spacing (10);
		panel_grid.attach (panel_bg_label, 0, 0, 2, 1);
		panel_grid.attach_next_to (panel_bg_box, panel_bg_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_fg_label, 0, 1, 2, 1);
		panel_grid.attach_next_to (panel_fg_color, panel_fg_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_border_label, 0, 2, 2, 1);
		panel_grid.attach_next_to (panel_border_color, panel_border_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_icon_label, 0, 3, 2, 1);
		panel_grid.attach_next_to (panel_icon_switch, panel_icon_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_tint_label, 0, 4, 2, 1);
		panel_grid.attach_next_to (panel_tint_value, panel_tint_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_bwidth_label, 0, 5, 2, 1);
		panel_grid.attach_next_to (panel_bwidth_value, panel_bwidth_label, PositionType.RIGHT, 1, 1);

		// Overview
		var overview_searchbg_label = new Label.with_mnemonic ("Search entry gradient");
		overview_searchbg_label.set_halign (Align.START);
		overview_searchbg1_color = new ColorButton ();
		((ColorChooser) overview_searchbg1_color).set_use_alpha (true);
		overview_searchbg1_color.set_tooltip_text ("Set the background gradient start of the search entry");
		overview_searchbg2_color = new ColorButton ();
		((ColorChooser) overview_searchbg2_color).set_use_alpha (true);
		overview_searchbg2_color.set_tooltip_text ("Set the background gradient end of the search entry");
		var overview_searchfocusbg_label = new Label.with_mnemonic ("Focused search entry gradient");
		overview_searchfocusbg_label.set_halign (Align.START);
		overview_searchfocusbg1_color = new ColorButton ();
		((ColorChooser) overview_searchfocusbg1_color).set_use_alpha (true);
		overview_searchfocusbg1_color.set_tooltip_text ("Set the background gradient start of the search entry in focus state");
		overview_searchfocusbg2_color = new ColorButton ();
		((ColorChooser) overview_searchfocusbg2_color).set_use_alpha (true);
		overview_searchfocusbg2_color.set_tooltip_text ("Set the background gradient end of the search entry in focus state");
		var overview_searchfg_label = new Label.with_mnemonic ("Search entry text color");
		overview_searchfg_label.set_halign (Align.START);
		overview_searchfg_color = new ColorButton ();
		((ColorChooser) overview_searchfg_color).set_use_alpha (true);
		overview_searchfg_color.set_tooltip_text ("Set the text color of the search entry");
		var overview_searchfocusfg_label = new Label.with_mnemonic ("Focused search entry text color");
		overview_searchfocusfg_label.set_halign (Align.START);
		overview_searchfocusfg_color = new ColorButton ();
		((ColorChooser) overview_searchfocusfg_color).set_use_alpha (true);
		overview_searchfocusfg_color.set_tooltip_text ("Set the text color of the search entry in focus state");
		var overview_searchborder_label = new Label.with_mnemonic ("Search entry border color");
		overview_searchborder_label.set_halign (Align.START);
		overview_searchborder_color = new ColorButton ();
		((ColorChooser) overview_searchborder_color).set_use_alpha (true);
		overview_searchborder_color.set_tooltip_text ("Set the border color of the search entry");
		var overview_searchfocusborder_label = new Label.with_mnemonic ("Focused search entry border color");
		overview_searchfocusborder_label.set_halign (Align.START);
		overview_searchfocusborder_color = new ColorButton ();
		((ColorChooser) overview_searchfocusborder_color).set_use_alpha (true);
		overview_searchfocusborder_color.set_tooltip_text ("Set the border color of the search entry in focus state");

		var overview_searchbg_box = new Box (Orientation.HORIZONTAL, 0);
		overview_searchbg_box.set_homogeneous (true);
		overview_searchbg_box.get_style_context ().add_class ("linked");
		overview_searchbg_box.add (overview_searchbg1_color);
		overview_searchbg_box.add (overview_searchbg2_color);

		var overview_searchfocusbg_box = new Box (Orientation.HORIZONTAL, 0);
		overview_searchfocusbg_box.set_homogeneous (true);
		overview_searchfocusbg_box.get_style_context ().add_class ("linked");
		overview_searchfocusbg_box.add (overview_searchfocusbg1_color);
		overview_searchfocusbg_box.add (overview_searchfocusbg2_color);

		var overview_grid = new Grid ();
		overview_grid.set_column_homogeneous (true);
		overview_grid.set_column_spacing (10);
		overview_grid.set_row_spacing (10);
		overview_grid.attach (overview_searchbg_label, 0, 0, 2, 1);
		overview_grid.attach_next_to (overview_searchbg_box, overview_searchbg_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_searchfocusbg_label, 0, 1, 2, 1);
		overview_grid.attach_next_to (overview_searchfocusbg_box, overview_searchfocusbg_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_searchfg_label, 0, 2, 2, 1);
		overview_grid.attach_next_to (overview_searchfg_color, overview_searchfg_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_searchfocusfg_label, 0, 3, 2, 1);
		overview_grid.attach_next_to (overview_searchfocusfg_color, overview_searchfocusfg_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_searchborder_label, 0, 4, 2, 1);
		overview_grid.attach_next_to (overview_searchborder_color, overview_searchborder_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_searchfocusborder_label, 0, 5, 2, 1);
		overview_grid.attach_next_to (overview_searchfocusborder_color, overview_searchfocusborder_label, PositionType.RIGHT, 1, 1);

		// Dash
		var dash_bg_label = new Label.with_mnemonic ("Background gradient");
		dash_bg_label.set_halign (Align.START);
		dash_bg1_color = new ColorButton ();
		((ColorChooser) dash_bg1_color).set_use_alpha (true);
		dash_bg1_color.set_tooltip_text ("Set the background gradient start of the dash and workspace panel");
		dash_bg2_color = new ColorButton ();
		((ColorChooser) dash_bg2_color).set_use_alpha (true);
		dash_bg2_color.set_tooltip_text ("Set the background gradient end of the dash and workspace panel");
		var dash_fg_label = new Label.with_mnemonic ("Text color");
		dash_fg_label.set_halign (Align.START);
		dash_fg_color = new ColorButton ();
		((ColorChooser) dash_fg_color).set_use_alpha (true);
		dash_fg_color.set_tooltip_text ("Set the text color of the dash labels and window caption");
		var dash_border_label = new Label.with_mnemonic ("Border color");
		dash_border_label.set_halign (Align.START);
		dash_border_color = new ColorButton ();
		((ColorChooser) dash_border_color).set_use_alpha (true);
		dash_border_color.set_tooltip_text ("Set the border color of the dash and workspace panel");
		var dash_tint_label = new Label.with_mnemonic ("Background tint level");
		dash_tint_label.set_halign (Align.START);
		dash_tint_value = new SpinButton.with_range (0, 100, 1);
		dash_tint_value.set_tooltip_text ("Set the amount of highlight color to mix with the chosen background color of the dash and workspace panel");
		dash_tint_value.set_halign (Align.END);
		var dash_bwidth_label = new Label.with_mnemonic ("Border width");
		dash_bwidth_label.set_halign (Align.START);
		dash_bwidth_value = new SpinButton.with_range (0, 100, 1);
		dash_bwidth_value.set_tooltip_text ("Set the border width of the dash and workspace panel");
		dash_bwidth_value.set_halign (Align.END);

		var dash_bg_box = new Box (Orientation.HORIZONTAL, 0);
		dash_bg_box.set_homogeneous (true);
		dash_bg_box.get_style_context ().add_class ("linked");
		dash_bg_box.add (dash_bg1_color);
		dash_bg_box.add (dash_bg2_color);

		var dash_grid = new Grid ();
		dash_grid.set_column_homogeneous (true);
		dash_grid.set_column_spacing (10);
		dash_grid.set_row_spacing (10);
		dash_grid.attach (dash_bg_label, 0, 0, 2, 1);
		dash_grid.attach_next_to (dash_bg_box, dash_bg_label, PositionType.RIGHT, 1, 1);
		dash_grid.attach (dash_fg_label, 0, 1, 2, 1);
		dash_grid.attach_next_to (dash_fg_color, dash_fg_label, PositionType.RIGHT, 1, 1);
		dash_grid.attach (dash_border_label, 0, 2, 2, 1);
		dash_grid.attach_next_to (dash_border_color, dash_border_label, PositionType.RIGHT, 1, 1);
		dash_grid.attach (dash_tint_label, 0, 3, 2, 1);
		dash_grid.attach_next_to (dash_tint_value, dash_tint_label, PositionType.RIGHT, 1, 1);
		dash_grid.attach (dash_bwidth_label, 0, 4, 2, 1);
		dash_grid.attach_next_to (dash_bwidth_value, dash_bwidth_label, PositionType.RIGHT, 1, 1);

		// Menu
		var menu_bg_label = new Label.with_mnemonic ("Background gradient");
		menu_bg_label.set_halign (Align.START);
		menu_bg1_color = new ColorButton ();
		((ColorChooser) menu_bg1_color).set_use_alpha (true);
		menu_bg1_color.set_tooltip_text ("Set the background gradient start of the popup menu");
		menu_bg2_color = new ColorButton ();
		((ColorChooser) menu_bg2_color).set_use_alpha (true);
		menu_bg2_color.set_tooltip_text ("Set the background gradient end of the popup menu");
		var menu_fg_label = new Label.with_mnemonic ("Text color");
		menu_fg_label.set_halign (Align.START);
		menu_fg_color = new ColorButton ();
		((ColorChooser) menu_fg_color).set_use_alpha (true);
		menu_fg_color.set_tooltip_text ("Set the text color of the popup menu");
		var menu_border_label = new Label.with_mnemonic ("Border color");
		menu_border_label.set_halign (Align.START);
		menu_border_color = new ColorButton ();
		((ColorChooser) menu_border_color).set_use_alpha (true);
		menu_border_color.set_tooltip_text ("Set the border color of the popup menu");
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
		var menu_bwidth_label = new Label.with_mnemonic ("Border width");
		menu_bwidth_label.set_halign (Align.START);
		menu_bwidth_value = new SpinButton.with_range (0, 100, 1);
		menu_bwidth_value.set_tooltip_text ("Set the border width of the popup menu");
		menu_bwidth_value.set_halign (Align.END);

		var menu_bg_box = new Box (Orientation.HORIZONTAL, 0);
		menu_bg_box.set_homogeneous (true);
		menu_bg_box.get_style_context ().add_class ("linked");
		menu_bg_box.add (menu_bg1_color);
		menu_bg_box.add (menu_bg2_color);

		var menu_grid = new Grid ();
		menu_grid.set_column_homogeneous (true);
		menu_grid.set_column_spacing (10);
		menu_grid.set_row_spacing (10);
		menu_grid.attach (menu_bg_label, 0, 0, 2, 1);
		menu_grid.attach_next_to (menu_bg_box, menu_bg_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_fg_label, 0, 1, 2, 1);
		menu_grid.attach_next_to (menu_fg_color, menu_fg_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_border_label, 0, 2, 2, 1);
		menu_grid.attach_next_to (menu_border_color, menu_border_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_arrow_label, 0, 3, 2, 1);
		menu_grid.attach_next_to (menu_arrow_switch, menu_arrow_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_tint_label, 0, 4, 2, 1);
		menu_grid.attach_next_to (menu_tint_value, menu_tint_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_bwidth_label, 0, 5, 2, 1);
		menu_grid.attach_next_to (menu_bwidth_value, menu_bwidth_label, PositionType.RIGHT, 1, 1);

		// Dialogs
		var dialog_bg_label = new Label.with_mnemonic ("Background gradient");
		dialog_bg_label.set_halign (Align.START);
		dialog_bg1_color = new ColorButton ();
		((ColorChooser) dialog_bg1_color).set_use_alpha (true);
		dialog_bg1_color.set_tooltip_text ("Set the background gradient start of the modal dialogs");
		dialog_bg2_color = new ColorButton ();
		((ColorChooser) dialog_bg2_color).set_use_alpha (true);
		dialog_bg2_color.set_tooltip_text ("Set the background gradient end of the modal dialogs");
		var dialog_fg_label = new Label.with_mnemonic ("Text color");
		dialog_fg_label.set_halign (Align.START);
		dialog_fg_color = new ColorButton ();
		((ColorChooser) dialog_fg_color).set_use_alpha (true);
		dialog_fg_color.set_tooltip_text ("Set the text color of the modal dialogs");
		var dialog_heading_label = new Label.with_mnemonic ("Heading color");
		dialog_heading_label.set_halign (Align.START);
		dialog_heading_color = new ColorButton ();
		((ColorChooser) dialog_heading_color).set_use_alpha (true);
		dialog_heading_color.set_tooltip_text ("Set the text color of headings in the modal dialogs");
		var dialog_border_label = new Label.with_mnemonic ("Border color");
		dialog_border_label.set_halign (Align.START);
		dialog_border_color = new ColorButton ();
		((ColorChooser) dialog_border_color).set_use_alpha (true);
		dialog_border_color.set_tooltip_text ("Set the border color of the modal dialogs");
		var dialog_tint_label = new Label.with_mnemonic ("Background tint level");
		dialog_tint_label.set_halign (Align.START);
		dialog_tint_value = new SpinButton.with_range (0, 100, 1);
		dialog_tint_value.set_tooltip_text ("Set the amount of highlight color to mix with the chosen background color of the modal dialogs");
		dialog_tint_value.set_halign (Align.END);
		var dialog_bwidth_label = new Label.with_mnemonic ("Border width");
		dialog_bwidth_label.set_halign (Align.START);
		dialog_bwidth_value = new SpinButton.with_range (0, 100, 1);
		dialog_bwidth_value.set_tooltip_text ("Set the border width of the modal dialogs");
		dialog_bwidth_value.set_halign (Align.END);

		var dialog_bg_box = new Box (Orientation.HORIZONTAL, 0);
		dialog_bg_box.set_homogeneous (true);
		dialog_bg_box.get_style_context ().add_class ("linked");
		dialog_bg_box.add (dialog_bg1_color);
		dialog_bg_box.add (dialog_bg2_color);

		var dialog_grid = new Grid ();
		dialog_grid.set_column_homogeneous (true);
		dialog_grid.set_column_spacing (10);
		dialog_grid.set_row_spacing (10);
		dialog_grid.attach (dialog_bg_label, 0, 0, 2, 1);
		dialog_grid.attach_next_to (dialog_bg_box, dialog_bg_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_fg_label, 0, 1, 2, 1);
		dialog_grid.attach_next_to (dialog_fg_color, dialog_fg_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_heading_label, 0, 2, 2, 1);
		dialog_grid.attach_next_to (dialog_heading_color, dialog_heading_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_border_label, 0, 3, 2, 1);
		dialog_grid.attach_next_to (dialog_border_color, dialog_border_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_tint_label, 0, 4, 2, 1);
		dialog_grid.attach_next_to (dialog_tint_value, dialog_tint_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_bwidth_label, 0, 5, 2, 1);
		dialog_grid.attach_next_to (dialog_bwidth_value, dialog_bwidth_label, PositionType.RIGHT, 1, 1);

		// Buttons
		var button_bg_label = new Label.with_mnemonic ("Background gradient");
		button_bg_label.set_halign (Align.START);
		button_bg1_color = new ColorButton ();
		((ColorChooser) button_bg1_color).set_use_alpha (true);
		button_bg1_color.set_tooltip_text ("Set the background gradient start of the buttons");
		button_bg2_color = new ColorButton ();
		((ColorChooser) button_bg2_color).set_use_alpha (true);
		button_bg2_color.set_tooltip_text ("Set the background gradient end of the buttons");
		var button_hoverbg_label = new Label.with_mnemonic ("Hover background gradient");
		button_hoverbg_label.set_halign (Align.START);
		button_hoverbg1_color = new ColorButton ();
		((ColorChooser) button_hoverbg1_color).set_use_alpha (true);
		button_hoverbg1_color.set_tooltip_text ("Set the background gradient start of the buttons in hover state");
		button_hoverbg2_color = new ColorButton ();
		((ColorChooser) button_hoverbg2_color).set_use_alpha (true);
		button_hoverbg2_color.set_tooltip_text ("Set the background gradient end of the buttons in hover state");
		var button_activebg_label = new Label.with_mnemonic ("Active background gradient");
		button_activebg_label.set_halign (Align.START);
		button_activebg1_color = new ColorButton ();
		((ColorChooser) button_activebg1_color).set_use_alpha (true);
		button_activebg1_color.set_tooltip_text ("Set the background gradient start of the buttons in active state");
		button_activebg2_color = new ColorButton ();
		((ColorChooser) button_activebg2_color).set_use_alpha (true);
		button_activebg2_color.set_tooltip_text ("Set the background gradient end of the buttons in active state");
		var button_fg_label = new Label.with_mnemonic ("Text color");
		button_fg_label.set_halign (Align.START);
		button_fg_color = new ColorButton ();
		((ColorChooser) button_fg_color).set_use_alpha (true);
		button_fg_color.set_tooltip_text ("Set the text color of the buttons");
		var button_hoverfg_label = new Label.with_mnemonic ("Hover text color");
		button_hoverfg_label.set_halign (Align.START);
		button_hoverfg_color = new ColorButton ();
		((ColorChooser) button_hoverfg_color).set_use_alpha (true);
		button_hoverfg_color.set_tooltip_text ("Set the text color of the buttons in hover state");
		var button_activefg_label = new Label.with_mnemonic ("Active text color");
		button_activefg_label.set_halign (Align.START);
		button_activefg_color = new ColorButton ();
		((ColorChooser) button_activefg_color).set_use_alpha (true);
		button_activefg_color.set_tooltip_text ("Set the text color of the buttons in active state");
		var button_border_label = new Label.with_mnemonic ("Border color");
		button_border_label.set_halign (Align.START);
		button_border_color = new ColorButton ();
		((ColorChooser) button_border_color).set_use_alpha (true);
		button_border_color.set_tooltip_text ("Set the border color of the buttons");
		var button_hoverborder_label = new Label.with_mnemonic ("Hover border color");
		button_hoverborder_label.set_halign (Align.START);
		button_hoverborder_color = new ColorButton ();
		((ColorChooser) button_hoverborder_color).set_use_alpha (true);
		button_hoverborder_color.set_tooltip_text ("Set the border color of the buttons in hover state");
		var button_activeborder_label = new Label.with_mnemonic ("Active border color");
		button_activeborder_label.set_halign (Align.START);
		button_activeborder_color = new ColorButton ();
		((ColorChooser) button_activeborder_color).set_use_alpha (true);
		button_activeborder_color.set_tooltip_text ("Set the border color of the buttons in active state");
		var button_bold_label = new Label.with_mnemonic ("Bold label");
		button_bold_label.set_halign (Align.START);
		button_bold_switch = new Switch ();
		button_bold_switch.set_tooltip_text ("Enable/disable bold label in the buttons");
		button_bold_switch.set_halign (Align.END);

		var button_bg_box = new Box (Orientation.HORIZONTAL, 0);
		button_bg_box.set_homogeneous (true);
		button_bg_box.get_style_context ().add_class ("linked");
		button_bg_box.add (button_bg1_color);
		button_bg_box.add (button_bg2_color);

		var button_hoverbg_box = new Box (Orientation.HORIZONTAL, 0);
		button_hoverbg_box.set_homogeneous (true);
		button_hoverbg_box.get_style_context ().add_class ("linked");
		button_hoverbg_box.add (button_hoverbg1_color);
		button_hoverbg_box.add (button_hoverbg2_color);

		var button_activebg_box = new Box (Orientation.HORIZONTAL, 0);
		button_activebg_box.set_homogeneous (true);
		button_activebg_box.get_style_context ().add_class ("linked");
		button_activebg_box.add (button_activebg1_color);
		button_activebg_box.add (button_activebg2_color);

		var button_grid = new Grid ();
		button_grid.set_column_homogeneous (true);
		button_grid.set_column_spacing (10);
		button_grid.set_row_spacing (10);
		button_grid.attach (button_bg_label, 0, 0, 2, 1);
		button_grid.attach_next_to (button_bg_box, button_bg_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_hoverbg_label, 0, 1, 2, 1);
		button_grid.attach_next_to (button_hoverbg_box, button_hoverbg_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_activebg_label, 0, 2, 2, 1);
		button_grid.attach_next_to (button_activebg_box, button_activebg_label, PositionType.RIGHT, 1, 1);
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

		// Focused buttons
		var buttonfocus_bg_label = new Label.with_mnemonic ("Background gradient");
		buttonfocus_bg_label.set_halign (Align.START);
		buttonfocus_bg1_color = new ColorButton ();
		((ColorChooser) buttonfocus_bg1_color).set_use_alpha (true);
		buttonfocus_bg1_color.set_tooltip_text ("Set the background gradient start of the focused buttons");
		buttonfocus_bg2_color = new ColorButton ();
		((ColorChooser) buttonfocus_bg2_color).set_use_alpha (true);
		buttonfocus_bg2_color.set_tooltip_text ("Set the background gradient end of the focused buttons");
		var buttonfocus_hoverbg_label = new Label.with_mnemonic ("Hover background gradient");
		buttonfocus_hoverbg_label.set_halign (Align.START);
		buttonfocus_hoverbg1_color = new ColorButton ();
		((ColorChooser) buttonfocus_hoverbg1_color).set_use_alpha (true);
		buttonfocus_hoverbg1_color.set_tooltip_text ("Set the background gradient start of the focused buttons in hover state");
		buttonfocus_hoverbg2_color = new ColorButton ();
		((ColorChooser) buttonfocus_hoverbg2_color).set_use_alpha (true);
		buttonfocus_hoverbg2_color.set_tooltip_text ("Set the background gradient end of the focused buttons in hover state");
		var buttonfocus_activebg_label = new Label.with_mnemonic ("Active background gradient");
		buttonfocus_activebg_label.set_halign (Align.START);
		buttonfocus_activebg1_color = new ColorButton ();
		((ColorChooser) buttonfocus_activebg1_color).set_use_alpha (true);
		buttonfocus_activebg1_color.set_tooltip_text ("Set the background gradient start of the focused buttons in active state");
		buttonfocus_activebg2_color = new ColorButton ();
		((ColorChooser) buttonfocus_activebg2_color).set_use_alpha (true);
		buttonfocus_activebg2_color.set_tooltip_text ("Set the background gradient end of the focused buttons in active state");
		var buttonfocus_fg_label = new Label.with_mnemonic ("Text color");
		buttonfocus_fg_label.set_halign (Align.START);
		buttonfocus_fg_color = new ColorButton ();
		((ColorChooser) buttonfocus_fg_color).set_use_alpha (true);
		buttonfocus_fg_color.set_tooltip_text ("Set the text color of the focused buttons");
		var buttonfocus_hoverfg_label = new Label.with_mnemonic ("Hover text color");
		buttonfocus_hoverfg_label.set_halign (Align.START);
		buttonfocus_hoverfg_color = new ColorButton ();
		((ColorChooser) buttonfocus_hoverfg_color).set_use_alpha (true);
		buttonfocus_hoverfg_color.set_tooltip_text ("Set the text color of the focused buttons in hover state");
		var buttonfocus_activefg_label = new Label.with_mnemonic ("Active text color");
		buttonfocus_activefg_label.set_halign (Align.START);
		buttonfocus_activefg_color = new ColorButton ();
		((ColorChooser) buttonfocus_activefg_color).set_use_alpha (true);
		buttonfocus_activefg_color.set_tooltip_text ("Set the text color of the focused buttons in active state");
		var buttonfocus_border_label = new Label.with_mnemonic ("Border color");
		buttonfocus_border_label.set_halign (Align.START);
		buttonfocus_border_color = new ColorButton ();
		((ColorChooser) buttonfocus_border_color).set_use_alpha (true);
		buttonfocus_border_color.set_tooltip_text ("Set the border color of the focused buttons");
		var buttonfocus_hoverborder_label = new Label.with_mnemonic ("Hover border color");
		buttonfocus_hoverborder_label.set_halign (Align.START);
		buttonfocus_hoverborder_color = new ColorButton ();
		((ColorChooser) buttonfocus_hoverborder_color).set_use_alpha (true);
		buttonfocus_hoverborder_color.set_tooltip_text ("Set the border color of the focused buttons in hover state");
		var buttonfocus_activeborder_label = new Label.with_mnemonic ("Active border color");
		buttonfocus_activeborder_label.set_halign (Align.START);
		buttonfocus_activeborder_color = new ColorButton ();
		((ColorChooser) buttonfocus_activeborder_color).set_use_alpha (true);
		buttonfocus_activeborder_color.set_tooltip_text ("Set the border color of the focused buttons in active state");

		var buttonfocus_bg_box = new Box (Orientation.HORIZONTAL, 0);
		buttonfocus_bg_box.set_homogeneous (true);
		buttonfocus_bg_box.get_style_context ().add_class ("linked");
		buttonfocus_bg_box.add (buttonfocus_bg1_color);
		buttonfocus_bg_box.add (buttonfocus_bg2_color);

		var buttonfocus_hoverbg_box = new Box (Orientation.HORIZONTAL, 0);
		buttonfocus_hoverbg_box.set_homogeneous (true);
		buttonfocus_hoverbg_box.get_style_context ().add_class ("linked");
		buttonfocus_hoverbg_box.add (buttonfocus_hoverbg1_color);
		buttonfocus_hoverbg_box.add (buttonfocus_hoverbg2_color);

		var buttonfocus_activebg_box = new Box (Orientation.HORIZONTAL, 0);
		buttonfocus_activebg_box.set_homogeneous (true);
		buttonfocus_activebg_box.get_style_context ().add_class ("linked");
		buttonfocus_activebg_box.add (buttonfocus_activebg1_color);
		buttonfocus_activebg_box.add (buttonfocus_activebg2_color);

		var buttonfocus_grid = new Grid ();
		buttonfocus_grid.set_column_homogeneous (true);
		buttonfocus_grid.set_column_spacing (10);
		buttonfocus_grid.set_row_spacing (10);
		buttonfocus_grid.attach (buttonfocus_bg_label, 0, 0, 2, 1);
		buttonfocus_grid.attach_next_to (buttonfocus_bg_box, buttonfocus_bg_label, PositionType.RIGHT, 1, 1);
		buttonfocus_grid.attach (buttonfocus_hoverbg_label, 0, 1, 2, 1);
		buttonfocus_grid.attach_next_to (buttonfocus_hoverbg_box, buttonfocus_hoverbg_label, PositionType.RIGHT, 1, 1);
		buttonfocus_grid.attach (buttonfocus_activebg_label, 0, 2, 2, 1);
		buttonfocus_grid.attach_next_to (buttonfocus_activebg_box, buttonfocus_activebg_label, PositionType.RIGHT, 1, 1);
		buttonfocus_grid.attach (buttonfocus_fg_label, 0, 3, 2, 1);
		buttonfocus_grid.attach_next_to (buttonfocus_fg_color, buttonfocus_fg_label, PositionType.RIGHT, 1, 1);
		buttonfocus_grid.attach (buttonfocus_hoverfg_label, 0, 4, 2, 1);
		buttonfocus_grid.attach_next_to (buttonfocus_hoverfg_color, buttonfocus_hoverfg_label, PositionType.RIGHT, 1, 1);
		buttonfocus_grid.attach (buttonfocus_activefg_label, 0, 5, 2, 1);
		buttonfocus_grid.attach_next_to (buttonfocus_activefg_color, buttonfocus_activefg_label, PositionType.RIGHT, 1, 1);
		buttonfocus_grid.attach (buttonfocus_border_label, 0, 6, 2, 1);
		buttonfocus_grid.attach_next_to (buttonfocus_border_color, buttonfocus_border_label, PositionType.RIGHT, 1, 1);
		buttonfocus_grid.attach (buttonfocus_hoverborder_label, 0, 7, 2, 1);
		buttonfocus_grid.attach_next_to (buttonfocus_hoverborder_color, buttonfocus_hoverborder_label, PositionType.RIGHT, 1, 1);
		buttonfocus_grid.attach (buttonfocus_activeborder_label, 0, 8, 2, 1);
		buttonfocus_grid.attach_next_to (buttonfocus_activeborder_color, buttonfocus_activeborder_label, PositionType.RIGHT, 1, 1);

		// Entry
		var entry_bg_label = new Label.with_mnemonic ("Background gradient");
		entry_bg_label.set_halign (Align.START);
		entry_bg1_color = new ColorButton ();
		((ColorChooser) entry_bg1_color).set_use_alpha (true);
		entry_bg1_color.set_tooltip_text ("Set the background gradient start of the entry widget");
		entry_bg2_color = new ColorButton ();
		((ColorChooser) entry_bg2_color).set_use_alpha (true);
		entry_bg2_color.set_tooltip_text ("Set the background gradient end of the entry widget");
		var entry_fg_label = new Label.with_mnemonic ("Text color");
		entry_fg_label.set_halign (Align.START);
		entry_fg_color = new ColorButton ();
		((ColorChooser) entry_fg_color).set_use_alpha (true);
		entry_fg_color.set_tooltip_text ("Set the text color of the entry widget");
		var entry_border_label = new Label.with_mnemonic ("Border color");
		entry_border_label.set_halign (Align.START);
		entry_border_color = new ColorButton ();
		((ColorChooser) entry_border_color).set_use_alpha (true);
		entry_border_color.set_tooltip_text ("Set the border color of the entry widget");
		var entry_shadow_label = new Label.with_mnemonic ("Inset shadow");
		entry_shadow_label.set_halign (Align.START);
		entry_shadow_switch = new Switch ();
		entry_shadow_switch.set_tooltip_text ("Enable/disable inset shadow in the entry widget");
		entry_shadow_switch.set_halign (Align.END);

		var entry_bg_box = new Box (Orientation.HORIZONTAL, 0);
		entry_bg_box.set_homogeneous (true);
		entry_bg_box.get_style_context ().add_class ("linked");
		entry_bg_box.add (entry_bg1_color);
		entry_bg_box.add (entry_bg2_color);

		var entry_grid = new Grid ();
		entry_grid.set_column_homogeneous (true);
		entry_grid.set_column_spacing (10);
		entry_grid.set_row_spacing (10);
		entry_grid.attach (entry_bg_label, 0, 0, 2, 1);
		entry_grid.attach_next_to (entry_bg_box, entry_bg_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_fg_label, 0, 1, 2, 1);
		entry_grid.attach_next_to (entry_fg_color, entry_fg_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_border_label, 0, 2, 2, 1);
		entry_grid.attach_next_to (entry_border_color, entry_border_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_shadow_label, 0, 3, 2, 1);
		entry_grid.attach_next_to (entry_shadow_switch, entry_shadow_label, PositionType.RIGHT, 1, 1);

		// Miscellaneous
		var misc_runningbg_label = new Label.with_mnemonic ("Background gradient for running apps");
		misc_runningbg_label.set_halign (Align.START);
		misc_runningbg1_color = new ColorButton ();
		((ColorChooser) misc_runningbg1_color).set_use_alpha (true);
		misc_runningbg1_color.set_tooltip_text ("Set the background gradient start for the icons of running apps");
		misc_runningbg2_color = new ColorButton ();
		((ColorChooser) misc_runningbg2_color).set_use_alpha (true);
		misc_runningbg2_color.set_tooltip_text ("Set the background gradient end for the icons of running apps");
		var misc_separator_label = new Label.with_mnemonic ("Separator gradient");
		misc_separator_label.set_halign (Align.START);
		misc_separator1_color = new ColorButton ();
		((ColorChooser) misc_separator1_color).set_use_alpha (true);
		misc_separator1_color.set_tooltip_text ("Set the gradient color start of separators");
		misc_separator2_color = new ColorButton ();
		((ColorChooser) misc_separator2_color).set_use_alpha (true);
		misc_separator2_color.set_tooltip_text ("Set the gradient color end of separators");
		var misc_tooltipbg_label = new Label.with_mnemonic ("Tooltip background gradient");
		misc_tooltipbg_label.set_halign (Align.START);
		misc_tooltipbg1_color = new ColorButton ();
		((ColorChooser) misc_tooltipbg1_color).set_use_alpha (true);
		misc_tooltipbg1_color.set_tooltip_text ("Set the gradient color start of tooltips");
		misc_tooltipbg2_color = new ColorButton ();
		((ColorChooser) misc_tooltipbg2_color).set_use_alpha (true);
		misc_tooltipbg2_color.set_tooltip_text ("Set the gradient color end of tooltips");
		var misc_tooltipfg_label = new Label.with_mnemonic ("Tooltip text color");
		misc_tooltipfg_label.set_halign (Align.START);
		misc_tooltipfg_color = new ColorButton ();
		((ColorChooser) misc_tooltipfg_color).set_use_alpha (true);
		misc_tooltipfg_color.set_tooltip_text ("Set the text color of tooltips");
		var misc_tooltipborder_label = new Label.with_mnemonic ("Tooltip border color");
		misc_tooltipborder_label.set_halign (Align.START);
		misc_tooltipborder_color = new ColorButton ();
		((ColorChooser) misc_tooltipborder_color).set_use_alpha (true);
		misc_tooltipborder_color.set_tooltip_text ("Set the border color of tooltips");
		var misc_insensitive_label = new Label.with_mnemonic ("Insensitive text color");
		misc_insensitive_label.set_halign (Align.START);
		misc_insensitive_color = new ColorButton ();
		((ColorChooser) misc_insensitive_color).set_use_alpha (true);
		misc_insensitive_color.set_tooltip_text ("Set the text color of insensitive and faded items");

		var misc_runningbg_box = new Box (Orientation.HORIZONTAL, 0);
		misc_runningbg_box.set_homogeneous (true);
		misc_runningbg_box.get_style_context ().add_class ("linked");
		misc_runningbg_box.add (misc_runningbg1_color);
		misc_runningbg_box.add (misc_runningbg2_color);

		var misc_separator_box = new Box (Orientation.HORIZONTAL, 0);
		misc_separator_box.set_homogeneous (true);
		misc_separator_box.get_style_context ().add_class ("linked");
		misc_separator_box.add (misc_separator1_color);
		misc_separator_box.add (misc_separator2_color);

		var misc_tooltipbg_box = new Box (Orientation.HORIZONTAL, 0);
		misc_tooltipbg_box.set_homogeneous (true);
		misc_tooltipbg_box.get_style_context ().add_class ("linked");
		misc_tooltipbg_box.add (misc_tooltipbg1_color);
		misc_tooltipbg_box.add (misc_tooltipbg2_color);

		var misc_grid = new Grid ();
		misc_grid.set_column_homogeneous (true);
		misc_grid.set_column_spacing (10);
		misc_grid.set_row_spacing (10);
		misc_grid.attach (misc_runningbg_label, 0, 0, 2, 1);
		misc_grid.attach_next_to (misc_runningbg_box, misc_runningbg_label, PositionType.RIGHT, 1, 1);
		misc_grid.attach (misc_separator_label, 0, 1, 2, 1);
		misc_grid.attach_next_to (misc_separator_box, misc_separator_label, PositionType.RIGHT, 1, 1);
		misc_grid.attach (misc_tooltipbg_label, 0, 2, 2, 1);
		misc_grid.attach_next_to (misc_tooltipbg_box, misc_tooltipbg_label, PositionType.RIGHT, 1, 1);
		misc_grid.attach (misc_tooltipfg_label, 0, 3, 2, 1);
		misc_grid.attach_next_to (misc_tooltipfg_color, misc_tooltipfg_label, PositionType.RIGHT, 1, 1);
		misc_grid.attach (misc_tooltipborder_label, 0, 4, 2, 1);
		misc_grid.attach_next_to (misc_tooltipborder_color, misc_tooltipborder_label, PositionType.RIGHT, 1, 1);
		misc_grid.attach (misc_insensitive_label, 0, 5, 2, 1);
		misc_grid.attach_next_to (misc_insensitive_color, misc_insensitive_label, PositionType.RIGHT, 1, 1);

		// Toolbar
		undo_button = new ToolButton (null, "Undo");
		undo_button.set_icon_name ("edit-undo");
		undo_button.set_tooltip_text ("Undo the last change");
		redo_button = new ToolButton (null, "Redo");
		redo_button.set_icon_name ("edit-redo");
		redo_button.set_tooltip_text ("Redo the last undone change");
		clear_button = new ToolButton (null, "Clear");
		clear_button.set_icon_name ("edit-clear");
		clear_button.set_tooltip_text ("Clear all changes");

		var toolbar = new Toolbar ();
		toolbar.get_style_context ().add_class (STYLE_CLASS_PRIMARY_TOOLBAR);
		toolbar.add (undo_button);
		toolbar.add (redo_button);
		toolbar.add (clear_button);

		// Apply button
		apply_button = new Button.with_mnemonic ("Apply");

		var buttons = new ButtonBox (Orientation.HORIZONTAL);
		buttons.set_layout (ButtonBoxStyle.END);
		buttons.add (apply_button);

		notebook = new Notebook ();
		notebook.set_show_tabs (false);
		notebook.set_show_border (false);
		notebook.append_page (general_grid, null);
		notebook.append_page (panel_grid, null);
		notebook.append_page (overview_grid, null);
		notebook.append_page (dash_grid, null);
		notebook.append_page (menu_grid, null);
		notebook.append_page (dialog_grid, null);
		notebook.append_page (button_grid, null);
		notebook.append_page (buttonfocus_grid, null);
		notebook.append_page (entry_grid, null);
		notebook.append_page (misc_grid, null);

		var mainbox = new Box (Orientation.VERTICAL, 12);
		mainbox.set_border_width (10);
		mainbox.add (notebook);
		mainbox.add (buttons);

		var listmodel = new ListStore (2, typeof (string), typeof (int));
		TreeIter iter;

		listmodel.append (out iter);
		listmodel.set (iter, 0, "General settings", 1, 0);
		listmodel.append (out iter);
		listmodel.set (iter, 0, "Panel", 1, 1);
		listmodel.append (out iter);
		listmodel.set (iter, 0, "Activities overview", 1, 2);
		listmodel.append (out iter);
		listmodel.set (iter, 0, "Dash", 1, 3);
		listmodel.append (out iter);
		listmodel.set (iter, 0, "Popup menu", 1, 4);
		listmodel.append (out iter);
		listmodel.set (iter, 0, "Modal dialogs", 1, 5);
		listmodel.append (out iter);
		listmodel.set (iter, 0, "Buttons", 1, 6);
		listmodel.append (out iter);
		listmodel.set (iter, 0, "Focused buttons", 1, 7);
		listmodel.append (out iter);
		listmodel.set (iter, 0, "Entry", 1, 8);
		listmodel.append (out iter);
		listmodel.set (iter, 0, "Miscellaneous", 1, 9);

		var treeview = new TreeView.with_model (listmodel);
		var treepath = new TreePath.from_string ("0");
		treeview.set_headers_visible (false);
		treeview.set_cursor (treepath, null, false);

		var treecell = new CellRendererText ();
		treeview.insert_column_with_attributes (-1, null, treecell, "text", 0);

		var selection = treeview.get_selection ();
		selection.changed.connect (on_selection_changed);

		var separator = new Separator (Orientation.VERTICAL);

		var hbox = new Box (Orientation.HORIZONTAL, 0);
		hbox.add (treeview);
		hbox.add (separator);
		hbox.add (mainbox);

		var vbox = new Box (Orientation.VERTICAL, 0);
		vbox.add (toolbar);
		vbox.add (hbox);

		// Setup widgets
		set_states ();

		// Connect signals
		connect_signals ();

		notebook.set_current_page (0);
		apply_button.set_sensitive (false);

		this.add (vbox);

		list_undo = new List<string> ();
		list_redo = new List<string> ();

		redo_button.set_sensitive (false);
		undo_button.set_sensitive (false);
		clear_button.set_sensitive (false);
	}

	void connect_signals () {
		// General
		combobox.changed.connect (on_preset_selected);
		match_wallpaper.toggled.connect (() => {
			on_value_changed ();
			if (match_wallpaper.get_active ()) {
				key_file.set_string ("Settings", "mode", "wallpaper");
			}
		});
		match_theme.toggled.connect (() => {
			on_value_changed ();
			if (match_theme.get_active ()) {
				key_file.set_string ("Settings", "mode", "gtk");
			}
		});
		custom_color.toggled .connect (() => {
			on_value_changed ();
			if (custom_color.get_active ()) {
				key_file.set_string ("Settings", "mode", "custom");
				color_button.set_sensitive (true);
			} else {
				color_button.set_sensitive (false);
			}
		});
		color_button.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Settings", "highlight", color_button.get_rgba ().to_string ());
		});
		text_auto.toggled .connect (() => {
			on_value_changed ();
			if (text_auto.get_active ()) {
				key_file.set_string ("Settings", "text", "auto");
			}
		});
		text_color.toggled .connect (() => {
			on_value_changed ();
			if (text_color.get_active ()) {
				key_file.set_string ("Settings", "text", "user");
				text_button.set_sensitive (true);
			} else {
				text_button.set_sensitive (false);
			}
		});
		text_button.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Settings", "textcolor", text_button.get_rgba ().to_string ());
		});
		font_button.font_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Settings", "fontname", font_button.get_font_name ());
		});
		dropshadow_switch.notify["active"].connect (() => {
			on_value_changed ();
			key_file.set_boolean ("Settings", "dropshadow", dropshadow_switch.get_active ());
		});
		selgradient_size.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Settings", "selgradient", selgradient_size.adjustment.value);
		});
		corner_roundness.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Settings", "roundness", corner_roundness.adjustment.value);
		});
		transition_duration.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Settings", "transition", transition_duration.adjustment.value);
		});

		// Panel
		panel_bg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Panel", "panel_bg1", panel_bg1_color.get_rgba ().to_string ());
		});
		panel_bg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Panel", "panel_bg2", panel_bg2_color.get_rgba ().to_string ());
		});
		panel_fg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Panel", "panel_fg", panel_fg_color.get_rgba ().to_string ());
		});
		panel_border_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Panel", "panel_border", panel_border_color.get_rgba ().to_string ());
		});
		panel_icon_switch.notify["active"].connect (() => {
			on_value_changed ();
			key_file.set_boolean ("Panel", "panel_icon", panel_icon_switch.get_active ());
		});
		panel_tint_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Panel", "panel_tint", panel_tint_value.adjustment.value);
		});
		panel_bwidth_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Panel", "panel_bwidth", panel_bwidth_value.adjustment.value);
		});

		// Overview
		overview_searchbg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchbg1", overview_searchbg1_color.get_rgba ().to_string ());
		});
		overview_searchbg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchbg2", overview_searchbg2_color.get_rgba ().to_string ());
		});
		overview_searchfocusbg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchfocusbg1", overview_searchfocusbg1_color.get_rgba ().to_string ());
		});
		overview_searchfocusbg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchfocusbg2", overview_searchfocusbg2_color.get_rgba ().to_string ());
		});
		overview_searchfg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchfg", overview_searchfg_color.get_rgba ().to_string ());
		});
		overview_searchfocusfg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchfocusfg", overview_searchfocusfg_color.get_rgba ().to_string ());
		});
		overview_searchborder_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchborder", overview_searchborder_color.get_rgba ().to_string ());
		});
		overview_searchfocusborder_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchfocusborder", overview_searchfocusborder_color.get_rgba ().to_string ());
		});

		// Dash
		dash_bg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dash", "dash_bg1", dash_bg1_color.get_rgba ().to_string ());
		});
		dash_bg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dash", "dash_bg2", dash_bg2_color.get_rgba ().to_string ());
		});
		dash_fg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dash", "dash_fg", dash_fg_color.get_rgba ().to_string ());
		});
		dash_border_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dash", "dash_border", dash_border_color.get_rgba ().to_string ());
		});
		dash_tint_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Dash", "dash_tint", dash_tint_value.adjustment.value);
		});
		dash_bwidth_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Dash", "dash_bwidth", dash_bwidth_value.adjustment.value);
		});

		// Menu
		menu_bg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Menu", "menu_bg1", menu_bg1_color.get_rgba ().to_string ());
		});
		menu_bg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Menu", "menu_bg2", menu_bg2_color.get_rgba ().to_string ());
		});
		menu_fg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Menu", "menu_fg", menu_fg_color.get_rgba ().to_string ());
		});
		menu_border_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Menu", "menu_border", menu_border_color.get_rgba ().to_string ());
		});
		menu_arrow_switch.notify["active"].connect (() => {
			on_value_changed ();
			key_file.set_boolean ("Menu", "menu_arrow", menu_arrow_switch.get_active ());
		});
		menu_tint_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Menu", "menu_tint", menu_tint_value.adjustment.value);
		});
		menu_bwidth_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Menu", "menu_bwidth", menu_bwidth_value.adjustment.value);
		});

		// Dialogs
		dialog_bg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dialogs", "dialog_bg1", dialog_bg1_color.get_rgba ().to_string ());
		});
		dialog_bg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dialogs", "dialog_bg2", dialog_bg2_color.get_rgba ().to_string ());
		});
		dialog_fg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dialogs", "dialog_fg", dialog_fg_color.get_rgba ().to_string ());
		});
		dialog_heading_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dialogs", "dialog_heading", dialog_heading_color.get_rgba ().to_string ());
		});
		dialog_border_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dialogs", "dialog_border", dialog_border_color.get_rgba ().to_string ());
		});
		dialog_tint_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Dialogs", "dialog_tint", dialog_tint_value.adjustment.value);
		});
		dialog_bwidth_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Dialogs", "dialog_bwidth", dialog_bwidth_value.adjustment.value);
		});

		// Buttons
		button_bg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_bg1", button_bg1_color.get_rgba ().to_string ());
		});
		button_bg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_bg2", button_bg2_color.get_rgba ().to_string ());
		});
		button_hoverbg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_hoverbg1", button_hoverbg1_color.get_rgba ().to_string ());
		});
		button_hoverbg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_hoverbg2", button_hoverbg2_color.get_rgba ().to_string ());
		});
		button_activebg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_activebg1", button_activebg1_color.get_rgba ().to_string ());
		});
		button_activebg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_activebg2", button_activebg2_color.get_rgba ().to_string ());
		});
		button_fg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_fg", button_fg_color.get_rgba ().to_string ());
		});
		button_hoverfg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_hoverfg", button_hoverfg_color.get_rgba ().to_string ());
		});
		button_activefg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_activefg", button_activefg_color.get_rgba ().to_string ());
		});
		button_border_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_border", button_border_color.get_rgba ().to_string ());
		});
		button_hoverborder_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_hoverborder", button_hoverborder_color.get_rgba ().to_string ());
		});
		button_activeborder_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_activeborder", button_activeborder_color.get_rgba ().to_string ());
		});
		button_bold_switch.notify["active"].connect (() => {
			on_value_changed ();
			key_file.set_boolean ("Buttons", "button_bold", button_bold_switch.get_active ());
		});

		// Focused buttons
		buttonfocus_bg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("ButtonsFocus", "buttonfocus_bg1", buttonfocus_bg1_color.get_rgba ().to_string ());
		});
		buttonfocus_bg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("ButtonsFocus", "buttonfocus_bg2", buttonfocus_bg2_color.get_rgba ().to_string ());
		});
		buttonfocus_hoverbg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("ButtonsFocus", "buttonfocus_hoverbg1", buttonfocus_hoverbg1_color.get_rgba ().to_string ());
		});
		buttonfocus_hoverbg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("ButtonsFocus", "buttonfocus_hoverbg2", buttonfocus_hoverbg2_color.get_rgba ().to_string ());
		});
		buttonfocus_activebg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("ButtonsFocus", "buttonfocus_activebg1", buttonfocus_activebg1_color.get_rgba ().to_string ());
		});
		buttonfocus_activebg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("ButtonsFocus", "buttonfocus_activebg2", buttonfocus_activebg2_color.get_rgba ().to_string ());
		});
		buttonfocus_fg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("ButtonsFocus", "buttonfocus_fg", buttonfocus_fg_color.get_rgba ().to_string ());
		});
		buttonfocus_hoverfg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("ButtonsFocus", "buttonfocus_hoverfg", buttonfocus_hoverfg_color.get_rgba ().to_string ());
		});
		buttonfocus_activefg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("ButtonsFocus", "buttonfocus_activefg", buttonfocus_activefg_color.get_rgba ().to_string ());
		});
		buttonfocus_border_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("ButtonsFocus", "buttonfocus_border", buttonfocus_border_color.get_rgba ().to_string ());
		});
		buttonfocus_hoverborder_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("ButtonsFocus", "buttonfocus_hoverborder", buttonfocus_hoverborder_color.get_rgba ().to_string ());
		});
		buttonfocus_activeborder_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("ButtonsFocus", "buttonfocus_activeborder", buttonfocus_activeborder_color.get_rgba ().to_string ());
		});

		// Entry
		entry_bg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Entry", "entry_bg1", entry_bg1_color.get_rgba ().to_string ());
		});
		entry_bg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Entry", "entry_bg2", entry_bg2_color.get_rgba ().to_string ());
		});
		entry_fg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Entry", "entry_fg", entry_fg_color.get_rgba ().to_string ());
		});
		entry_border_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Entry", "entry_border", entry_border_color.get_rgba ().to_string ());
		});
		entry_shadow_switch.notify["active"].connect (() => {
			on_value_changed ();
			key_file.set_boolean ("Entry", "entry_shadow", entry_shadow_switch.get_active ());
		});

		// Miscellaneous
		misc_runningbg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_runningbg1", misc_runningbg1_color.get_rgba ().to_string ());
		});
		misc_runningbg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_runningbg2", misc_runningbg2_color.get_rgba ().to_string ());
		});
		misc_separator1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_separator1", misc_separator1_color.get_rgba ().to_string ());
		});
		misc_separator2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_separator2", misc_separator2_color.get_rgba ().to_string ());
		});
		misc_tooltipbg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_tooltipbg1", misc_tooltipbg1_color.get_rgba ().to_string ());
		});
		misc_tooltipbg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_tooltipbg2", misc_tooltipbg2_color.get_rgba ().to_string ());
		});
		misc_tooltipfg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_tooltipfg", misc_tooltipfg_color.get_rgba ().to_string ());
		});
		misc_tooltipborder_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_tooltipborder", misc_tooltipborder_color.get_rgba ().to_string ());
		});
		misc_insensitive_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_insensitive", misc_insensitive_color.get_rgba ().to_string ());
		});

		// Toolbar
		undo_button.clicked.connect (on_undo_clicked);
		redo_button.clicked.connect (on_redo_clicked);
		clear_button.clicked.connect (on_clear_clicked);

		// Apply button
		apply_button.clicked.connect (on_config_applied);
	}

	void on_selection_changed (TreeSelection selection) {
		TreeModel model;
		TreeIter iter;

		int page;

		if (selection.get_selected (out model, out iter)) {
			model.get (iter, 1, out page);
			notebook.set_current_page (page);
		}
	}

	void on_value_changed () {

		apply_button.set_sensitive (true);
		undo_button.set_sensitive (true);
		clear_button.set_sensitive (true);

		list_undo.append (key_file.to_data (null,null));

		if (new_button_clicked == true) {
				
		} else {
			list_redo = new List<string> ();
			redo_button.set_sensitive (false);
		}
	}

	void on_clear_clicked () {

		load_config ();
		set_states ();

		combobox.set_active (0);
		apply_button.set_sensitive (false);

		list_undo = new List<string> ();
		list_redo = new List<string> ();

		redo_button.set_sensitive (false);
		undo_button.set_sensitive (false);
		clear_button.set_sensitive (false);		
	}

	void on_undo_clicked () {

		clear_button.set_sensitive (true);
		redo_button.set_sensitive (true);
		list_redo.append (key_file.to_data (null,null));

		unowned string? data = list_undo.nth_data (list_undo.length ()-1);

		try {
			key_file.load_from_data (data,-1, KeyFileFlags.NONE);			
		} catch (KeyFileError e) {
			stderr.printf ("Failed to undo: %s\n", e.message);
		}

		new_button_clicked = true;
		list_undo.remove (data);
		new_button_clicked = true;

		set_states ();

		new_button_clicked = true;
		data = list_undo.nth_data (list_undo.length ()-1);
		list_undo.remove (data);
		data = list_undo.nth_data (list_undo.length ()-1);

		if (data == null) {
			undo_button.set_sensitive (false);
		}

		new_button_clicked = false;
		
	}

	void on_redo_clicked () {

		undo_button.set_sensitive (true);
		list_undo.append (key_file.to_data (null,null));

		unowned string? data = list_redo.nth_data (list_redo.length ()-1);

		try {
			key_file.load_from_data (data,-1, KeyFileFlags.NONE);
		} catch (KeyFileError e) {
			stderr.printf ("Failed to redo: %s\n", e.message);
		}

		new_button_clicked = true;
		list_redo.remove (data);
		new_button_clicked = true;

		set_states ();

		new_button_clicked = true;
		data = list_undo.nth_data (list_undo.length ()-1);
		list_undo.remove (data);
		data = list_redo.nth_data (list_redo.length ()-1);

		if (data == null) {
			redo_button.set_sensitive (false);
		}

		new_button_clicked = false;
	}

	void on_preset_selected () {

		if (combobox.get_active () !=0) {
			var preset_file_usr = presets_dir_usr.get_child (presets [combobox.get_active ()]);
			var preset_file_sys = presets_dir_sys.get_child (presets [combobox.get_active ()]);

			if (preset_file_usr.query_exists () && preset_file_usr.query_file_type (0) == FileType.REGULAR) {
				try {
					key_file.load_from_file (preset_file_usr.get_path (), KeyFileFlags.NONE);
				} catch (Error e) {
					stderr.printf ("Failed to load preset from user directory: %s\n", e.message);
				}
			} else if (preset_file_sys.query_exists () && preset_file_sys.query_file_type (0) == FileType.REGULAR) {
				try {
					key_file.load_from_file (preset_file_sys.get_path (), KeyFileFlags.NONE);
				} catch (Error e) {
					stderr.printf ("Failed to load preset from system directory: %s\n", e.message);
				}
			}

			on_load_keyfile ();
		}
	}

	void on_load_keyfile () {
		set_states ();
		on_value_changed ();
	}

	void on_config_applied () {

		try {
			string keyfile_str = key_file.to_data ();
			var dos = new DataOutputStream (config_file.replace (null, false, FileCreateFlags.REPLACE_DESTINATION));
			dos.put_string (keyfile_str);
		} catch (Error e) {
			stderr.printf ("Failed to write configuration: %s\n", e.message);
		}

		try {
			Process.spawn_command_line_sync ("%s apply".printf (elegance_colors));
		} catch (Error e) {
			stderr.printf ("Failed to apply changes: %s\n", e.message);
		}

		apply_button.set_sensitive (false);
		clear_button.set_sensitive (false);
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
