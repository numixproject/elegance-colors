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
	ColorButton panel_bg1_color;
	ColorButton panel_bg2_color;
	ColorButton panel_fg_color;
	ColorButton panel_border_color;

	Switch panel_shadow_switch;
	Switch panel_icon_switch;

	SpinButton panel_tint_value;
	SpinButton panel_bwidth_value;
	SpinButton panel_corner_value;

	string panel_bg1_value;
	string panel_bg2_value;
	string panel_fg_value;
	string panel_border_value;

	// Overview
	ColorButton overview_bg1_color;
	ColorButton overview_bg2_color;
	ColorButton overview_searchbg1_color;
	ColorButton overview_searchbg2_color;
	ColorButton overview_searchfocusbg1_color;
	ColorButton overview_searchfocusbg2_color;
	ColorButton overview_searchfg_color;
	ColorButton overview_searchfocusfg_color;
	ColorButton overview_searchborder_color;
	ColorButton overview_searchfocusborder_color;

	SpinButton overview_tint_value;
	SpinButton overview_iconsize_value;
	SpinButton overview_iconspacing_value;

	string overview_bg1_value;
	string overview_bg2_value;
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

	Switch dash_shadow_switch;

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

	Switch menu_shadow_switch;
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

	Switch dialog_shadow_switch;

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

	// Entry
	ColorButton entry_bg1_color;
	ColorButton entry_bg2_color;
	ColorButton entry_focusbg1_color;
	ColorButton entry_focusbg2_color;
	ColorButton entry_fg_color;
	ColorButton entry_focusfg_color;
	ColorButton entry_border_color;
	ColorButton entry_focusborder_color;

	Switch entry_shadow_switch;

	string entry_bg1_value;
	string entry_bg2_value;
	string entry_focusbg1_value;
	string entry_focusbg2_value;
	string entry_fg_value;
	string entry_focusfg_value;
	string entry_border_value;
	string entry_focusborder_value;

	// Misc
	ColorButton misc_runningbg1_color;
	ColorButton misc_runningbg2_color;
	ColorButton misc_separator1_color;
	ColorButton misc_separator2_color;
	ColorButton misc_tooltipbg1_color;
	ColorButton misc_tooltipbg2_color;
	ColorButton misc_tooltipfg_color;
	ColorButton misc_tooltipborder_color;

	string misc_runningbg1_value;
	string misc_runningbg2_value;
	string misc_separator1_value;
	string misc_separator2_value;
	string misc_tooltipbg1_value;
	string misc_tooltipbg2_value;
	string misc_tooltipfg_value;
	string misc_tooltipborder_value;

	// Others
	Notebook notebook;

	//undo redo clear
	ToolButton undo_button;
	ToolButton redo_button;
	ToolButton clear_button;
	List<string> list_undo = new List<string> ();
	List<string> list_redo = new List<string> ();
	bool new_button_clicked = false;

	Button apply_button;

	File config_file;
	File presets_dir_usr;
	File presets_dir_sys;

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
		var config_dir = File.new_for_path (Environment.get_user_config_dir ());
		config_file = config_dir.get_child ("elegance-colors").get_child ("elegance-colors.ini");
		presets_dir_usr = config_dir.get_child ("elegance-colors").get_child ("presets");
		presets_dir_sys = File.parse_name ("/usr/share/elegance-colors/presets");

		key_file = new KeyFile ();

		// Methods
		init_process ();
		load_config ();
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
			"comments", "A customizable chameleon theme for Gnome Shell",
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
			key_file.load_from_file (config_file.get_path(), KeyFileFlags.NONE);
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

			color_value = key_file.get_string ("Settings", "color");

			monitor_switch.set_active (key_file.get_boolean ("Settings", "monitor"));

			fontchooser.set_font_name (key_file.get_string ("Settings", "fontname"));

			selgradient_size.adjustment.value = key_file.get_double ("Settings", "selgradient");
			corner_roundness.adjustment.value = key_file.get_double ("Settings", "roundness");
			transition_duration.adjustment.value = key_file.get_double ("Settings", "transition");

			panel_bg1_value = key_file.get_string ("Panel", "panel_bg1");
			panel_bg2_value = key_file.get_string ("Panel", "panel_bg2");
			panel_fg_value = key_file.get_string ("Panel", "panel_fg");
			panel_border_value = key_file.get_string ("Panel", "panel_border");

			panel_shadow_switch.set_active (key_file.get_boolean ("Panel", "panel_shadow"));
			panel_icon_switch.set_active (key_file.get_boolean ("Panel", "panel_icon"));

			panel_tint_value.adjustment.value = key_file.get_double ("Panel", "panel_tint");
			panel_bwidth_value.adjustment.value = key_file.get_double ("Panel", "panel_bwidth");
			panel_corner_value.adjustment.value = key_file.get_double ("Panel", "panel_corner");

			overview_bg1_value = key_file.get_string ("Overview", "overview_bg1");
			overview_bg2_value = key_file.get_string ("Overview", "overview_bg2");
			overview_searchbg1_value = key_file.get_string ("Overview", "overview_searchbg1");
			overview_searchbg2_value = key_file.get_string ("Overview", "overview_searchbg2");
			overview_searchfocusbg1_value = key_file.get_string ("Overview", "overview_searchfocusbg1");
			overview_searchfocusbg2_value = key_file.get_string ("Overview", "overview_searchfocusbg2");
			overview_searchfg_value = key_file.get_string ("Overview", "overview_searchfg");
			overview_searchfocusfg_value = key_file.get_string ("Overview", "overview_searchfocusfg");
			overview_searchborder_value = key_file.get_string ("Overview", "overview_searchborder");
			overview_searchfocusborder_value = key_file.get_string ("Overview", "overview_searchfocusborder");

			overview_tint_value.adjustment.value = key_file.get_double ("Overview", "overview_tint");
			overview_iconsize_value.adjustment.value = key_file.get_double ("Overview", "overview_iconsize");
			overview_iconspacing_value.adjustment.value = key_file.get_double ("Overview", "overview_iconspacing");

			dash_bg1_value = key_file.get_string ("Dash", "dash_bg1");
			dash_bg2_value = key_file.get_string ("Dash", "dash_bg2");
			dash_fg_value = key_file.get_string ("Dash", "dash_fg");
			dash_border_value = key_file.get_string ("Dash", "dash_border");

			dash_shadow_switch.set_active (key_file.get_boolean ("Dash", "dash_shadow"));

			dash_tint_value.adjustment.value = key_file.get_double ("Dash", "dash_tint");
			dash_bwidth_value.adjustment.value = key_file.get_double ("Dash", "dash_bwidth");

			menu_bg1_value = key_file.get_string ("Menu", "menu_bg1");
			menu_bg2_value = key_file.get_string ("Menu", "menu_bg2");
			menu_fg_value = key_file.get_string ("Menu", "menu_fg");
			menu_border_value = key_file.get_string ("Menu", "menu_border");

			menu_shadow_switch.set_active (key_file.get_boolean ("Menu", "menu_shadow"));
			menu_arrow_switch.set_active (key_file.get_boolean ("Menu", "menu_arrow"));

			menu_tint_value.adjustment.value = key_file.get_double ("Menu", "menu_tint");
			menu_bwidth_value.adjustment.value = key_file.get_double ("Menu", "menu_bwidth");

			dialog_bg1_value = key_file.get_string ("Dialogs", "dialog_bg1");
			dialog_bg2_value = key_file.get_string ("Dialogs", "dialog_bg2");
			dialog_fg_value = key_file.get_string ("Dialogs", "dialog_fg");
			dialog_border_value = key_file.get_string ("Dialogs", "dialog_border");
			dialog_heading_value = key_file.get_string ("Dialogs", "dialog_heading");

			dialog_shadow_switch.set_active (key_file.get_boolean ("Dialogs", "dialog_shadow"));

			dialog_tint_value.adjustment.value = key_file.get_double ("Dialogs", "dialog_tint");
			dialog_bwidth_value.adjustment.value = key_file.get_double ("Dialogs", "dialog_bwidth");

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
			button_border_value = key_file.get_string ("Buttons", "button_hoverborder");
			button_border_value = key_file.get_string ("Buttons", "button_activeborder");

			button_bold_switch.set_active (key_file.get_boolean ("Buttons", "button_bold"));

			entry_bg1_value = key_file.get_string ("Entry", "entry_bg1");
			entry_bg2_value = key_file.get_string ("Entry", "entry_bg2");
			entry_focusbg1_value = key_file.get_string ("Entry", "entry_focusbg1");
			entry_focusbg2_value = key_file.get_string ("Entry", "entry_focusbg2");
			entry_fg_value = key_file.get_string ("Entry", "entry_fg");
			entry_focusfg_value = key_file.get_string ("Entry", "entry_focusfg");
			entry_border_value = key_file.get_string ("Entry", "entry_border");
			entry_border_value = key_file.get_string ("Entry", "entry_focusborder");

			entry_shadow_switch.set_active (key_file.get_boolean ("Entry", "entry_shadow"));

			misc_runningbg1_value = key_file.get_string ("Misc", "misc_runningbg1");
			misc_runningbg2_value = key_file.get_string ("Misc", "misc_runningbg2");
			misc_separator1_value = key_file.get_string ("Misc", "misc_separator1");
			misc_separator2_value = key_file.get_string ("Misc", "misc_separator2");
			misc_tooltipbg1_value = key_file.get_string ("Misc", "misc_tooltipbg1");
			misc_tooltipbg2_value = key_file.get_string ("Misc", "misc_tooltipbg2");
			misc_tooltipfg_value = key_file.get_string ("Misc", "misc_tooltipfg");
			misc_tooltipborder_value = key_file.get_string ("Misc", "misc_tooltipborder");

		} catch (Error e) {
			stderr.printf ("Failed to set properties: %s\n", e.message);
		}

		// Set colors
		var color = Gdk.RGBA ();

		color.parse ("%s".printf (color_value));
		color_button.set_rgba (color);

		color.parse ("%s".printf (panel_bg1_value));
		panel_bg1_color.set_rgba (color);

		color.parse ("%s".printf (panel_bg2_value));
		panel_bg2_color.set_rgba (color);

		color.parse ("%s".printf (panel_fg_value));
		panel_fg_color.set_rgba (color);

		color.parse ("%s".printf (panel_border_value));
		panel_border_color.set_rgba (color);

		color.parse ("%s".printf (overview_bg1_value));
		overview_bg1_color.set_rgba (color);

		color.parse ("%s".printf (overview_bg2_value));
		overview_bg2_color.set_rgba (color);

		color.parse ("%s".printf (overview_searchbg1_value));
		overview_searchbg1_color.set_rgba (color);

		color.parse ("%s".printf (overview_searchbg2_value));
		overview_searchbg2_color.set_rgba (color);

		color.parse ("%s".printf (overview_searchfocusbg1_value));
		overview_searchfocusbg1_color.set_rgba (color);

		color.parse ("%s".printf (overview_searchfocusbg2_value));
		overview_searchfocusbg2_color.set_rgba (color);

		color.parse ("%s".printf (overview_searchfg_value));
		overview_searchfg_color.set_rgba (color);

		color.parse ("%s".printf (overview_searchborder_value));
		overview_searchborder_color.set_rgba (color);

		color.parse ("%s".printf (dash_bg1_value));
		dash_bg1_color.set_rgba (color);

		color.parse ("%s".printf (dash_bg2_value));
		dash_bg2_color.set_rgba (color);

		color.parse ("%s".printf (dash_fg_value));
		dash_fg_color.set_rgba (color);

		color.parse ("%s".printf (dash_border_value));
		dash_border_color.set_rgba (color);

		color.parse ("%s".printf (menu_bg1_value));
		menu_bg1_color.set_rgba (color);

		color.parse ("%s".printf (menu_bg2_value));
		menu_bg2_color.set_rgba (color);

		color.parse ("%s".printf (menu_fg_value));
		menu_fg_color.set_rgba (color);

		color.parse ("%s".printf (menu_border_value));
		menu_border_color.set_rgba (color);

		color.parse ("%s".printf (dialog_bg1_value));
		dialog_bg1_color.set_rgba (color);

		color.parse ("%s".printf (dialog_bg2_value));
		dialog_bg2_color.set_rgba (color);

		color.parse ("%s".printf (dialog_fg_value));
		dialog_fg_color.set_rgba (color);

		color.parse ("%s".printf (dialog_heading_value));
		dialog_heading_color.set_rgba (color);

		color.parse ("%s".printf (dialog_border_value));
		dialog_border_color.set_rgba (color);

		color.parse ("%s".printf (button_bg1_value));
		button_bg1_color.set_rgba (color);

		color.parse ("%s".printf (button_bg2_value));
		button_bg2_color.set_rgba (color);

		color.parse ("%s".printf (button_hoverbg1_value));
		button_hoverbg1_color.set_rgba (color);

		color.parse ("%s".printf (button_hoverbg2_value));
		button_hoverbg2_color.set_rgba (color);

		color.parse ("%s".printf (button_activebg1_value));
		button_activebg1_color.set_rgba (color);

		color.parse ("%s".printf (button_activebg2_value));
		button_activebg2_color.set_rgba (color);

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

		color.parse ("%s".printf (entry_bg1_value));
		entry_bg1_color.set_rgba (color);

		color.parse ("%s".printf (entry_bg2_value));
		entry_bg2_color.set_rgba (color);

		color.parse ("%s".printf (entry_focusbg1_value));
		entry_focusbg1_color.set_rgba (color);

		color.parse ("%s".printf (entry_focusbg2_value));
		entry_focusbg2_color.set_rgba (color);

		color.parse ("%s".printf (entry_fg_value));
		entry_fg_color.set_rgba (color);

		color.parse ("%s".printf (entry_focusfg_value));
		entry_focusfg_color.set_rgba (color);

		color.parse ("%s".printf (entry_border_value));
		entry_border_color.set_rgba (color);

		color.parse ("%s".printf (entry_focusborder_value));
		entry_focusborder_color.set_rgba (color);

		color.parse ("%s".printf (misc_runningbg1_value));
		misc_runningbg1_color.set_rgba (color);

		color.parse ("%s".printf (misc_runningbg2_value));
		misc_runningbg2_color.set_rgba (color);

		color.parse ("%s".printf (misc_separator1_value));
		misc_separator1_color.set_rgba (color);

		color.parse ("%s".printf (misc_separator2_value));
		misc_separator2_color.set_rgba (color);

		color.parse ("%s".printf (misc_tooltipbg1_value));
		misc_tooltipbg1_color.set_rgba (color);

		color.parse ("%s".printf (misc_tooltipbg2_value));
		misc_tooltipbg2_color.set_rgba (color);

		color.parse ("%s".printf (misc_tooltipfg_value));
		misc_tooltipfg_color.set_rgba (color);

		color.parse ("%s".printf (misc_tooltipborder_value));
		misc_tooltipborder_color.set_rgba (color);
	}

	void create_widgets () {

		// Create and setup widgets

		// General
		var presets_label = new Label.with_mnemonic ("Load config from preset");
		presets_label.set_halign (Align.START);

		// Read presets from user dir
		try {
			var dir = Dir.open(presets_dir_usr.get_path());

			var titlechanged = false;

			string preset = "";
			string title = "";
			while ((preset = dir.read_name()) != null) {
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
		} catch (Error e) {
			stderr.printf ("Failed to open user presets directory: %s\n", e.message);
		}

		// Read presets from system dir
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
		combobox.set_tooltip_text ("Load settings from a installed preset");
		combobox.set_halign (Align.END);

		var mode_label = new Label.with_mnemonic ("Derive color from");
		mode_label.set_halign (Align.START);

		match_wallpaper = new RadioButton (null);
		match_wallpaper.set_label ("Wallpaper");
		match_wallpaper.set_mode (false);
		match_wallpaper.set_tooltip_text ("Derive the highlight color from the current wallpaper");
		match_theme = new RadioButton.with_label (match_wallpaper.get_group(),"GTK theme");
		match_theme.set_mode (false);
		match_theme.set_tooltip_text ("Derive the highlight color from the current GTK theme");
		custom_color = new RadioButton.with_label (match_theme.get_group(),"Custom");
		custom_color.set_mode (false);
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

		var colorbox = new Box (Orientation.HORIZONTAL, 0);
		colorbox.set_homogeneous (true);
		colorbox.get_style_context().add_class("linked");
		colorbox.add (match_wallpaper);
		colorbox.add (match_theme);
		colorbox.add (custom_color);
		colorbox.add (color_button);

		var general_grid = new Grid ();
		general_grid.set_column_homogeneous (true);
		general_grid.set_column_spacing (12);
		general_grid.set_row_spacing (12);
		general_grid.attach (presets_label, 0, 0, 1, 1);
		general_grid.attach_next_to (combobox, presets_label, PositionType.RIGHT, 2, 1);
		general_grid.attach (mode_label, 0, 1, 1, 1);
		general_grid.attach_next_to (colorbox, mode_label, PositionType.RIGHT, 2, 1);
		general_grid.attach (monitor_label, 0, 2, 2, 1);
		general_grid.attach_next_to (monitor_switch, monitor_label, PositionType.RIGHT, 1, 1);
		general_grid.attach (font_label, 0, 3, 1, 1);
		general_grid.attach_next_to (fontchooser, font_label, PositionType.RIGHT, 2, 1);
		general_grid.attach (selgradient_label, 0, 4, 2, 1);
		general_grid.attach_next_to (selgradient_size, selgradient_label, PositionType.RIGHT, 1, 1);
		general_grid.attach (roundness_label, 0, 5, 2, 1);
		general_grid.attach_next_to (corner_roundness, roundness_label, PositionType.RIGHT, 1, 1);
		general_grid.attach (transition_label, 0, 6, 2, 1);
		general_grid.attach_next_to (transition_duration, transition_label, PositionType.RIGHT, 1, 1);

		combobox.changed.connect (on_preset_selected);
		match_wallpaper.toggled.connect (() => {
			on_value_changed ();
			if (match_wallpaper.get_active()) {
				key_file.set_string ("Settings", "mode", "wallpaper");
			}
		});
		match_theme.toggled.connect (() => {
			on_value_changed ();
			if (match_theme.get_active()) {
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
			key_file.set_string ("Settings", "color", color_button.rgba.to_string());
		});
		monitor_switch.notify["active"].connect (() => {
			on_value_changed ();
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
		});
		fontchooser.font_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Settings", "fontname", fontchooser.get_font_name());
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
		var panel_bg1_label = new Label.with_mnemonic ("Background gradient start");
		panel_bg1_label.set_halign (Align.START);
		panel_bg1_color = new ColorButton ();
		panel_bg1_color.set_use_alpha (true);
		panel_bg1_color.set_tooltip_text ("Set the background gradient start of the top panel");
		var panel_bg2_label = new Label.with_mnemonic ("Background gradient end");
		panel_bg2_label.set_halign (Align.START);
		panel_bg2_color = new ColorButton ();
		panel_bg2_color.set_use_alpha (true);
		panel_bg2_color.set_tooltip_text ("Set the background gradient end of the top panel");
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
		var panel_bwidth_label = new Label.with_mnemonic ("Border width");
		panel_bwidth_label.set_halign (Align.START);
		panel_bwidth_value = new SpinButton.with_range (0, 100, 1);
		panel_bwidth_value.set_tooltip_text ("Set the width of the border of the top panel");
		panel_bwidth_value.set_halign (Align.END);
		var panel_corner_label = new Label.with_mnemonic ("Corner radius");
		panel_corner_label.set_halign (Align.START);
		panel_corner_value = new SpinButton.with_range (0, 100, 1);
		panel_corner_value.set_tooltip_text ("Set the roundness the top panel corners");
		panel_corner_value.set_halign (Align.END);

		var panel_grid = new Grid ();
		panel_grid.set_column_homogeneous (true);
		panel_grid.set_column_spacing (12);
		panel_grid.set_row_spacing (12);
		panel_grid.attach (panel_bg1_label, 0, 0, 2, 1);
		panel_grid.attach_next_to (panel_bg1_color, panel_bg1_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_bg2_label, 0, 1, 2, 1);
		panel_grid.attach_next_to (panel_bg2_color, panel_bg2_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_fg_label, 0, 2, 2, 1);
		panel_grid.attach_next_to (panel_fg_color, panel_fg_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_border_label, 0, 3, 2, 1);
		panel_grid.attach_next_to (panel_border_color, panel_border_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_shadow_label, 0, 4, 2, 1);
		panel_grid.attach_next_to (panel_shadow_switch, panel_shadow_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_icon_label, 0, 5, 2, 1);
		panel_grid.attach_next_to (panel_icon_switch, panel_icon_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_tint_label, 0, 6, 2, 1);
		panel_grid.attach_next_to (panel_tint_value, panel_tint_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_bwidth_label, 0, 7, 2, 1);
		panel_grid.attach_next_to (panel_bwidth_value, panel_bwidth_label, PositionType.RIGHT, 1, 1);
		panel_grid.attach (panel_corner_label, 0, 8, 2, 1);
		panel_grid.attach_next_to (panel_corner_value, panel_corner_label, PositionType.RIGHT, 1, 1);

		panel_bg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Panel", "panel_bg1", panel_bg1_color.rgba.to_string());
		});
		panel_bg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Panel", "panel_bg2", panel_bg2_color.rgba.to_string());
		});
		panel_fg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Panel", "panel_fg", panel_fg_color.rgba.to_string());
		});
		panel_border_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Panel", "panel_border", panel_border_color.rgba.to_string());
		});
		panel_shadow_switch.notify["active"].connect (() => {
			on_value_changed ();
			key_file.set_boolean ("Panel", "panel_shadow", panel_shadow_switch.get_active());
		});
		panel_icon_switch.notify["active"].connect (() => {
			on_value_changed ();
			key_file.set_boolean ("Panel", "panel_icon", panel_icon_switch.get_active());
		});
		panel_tint_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Panel", "panel_tint", panel_tint_value.adjustment.value);
		});
		panel_bwidth_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Panel", "panel_bwidth", panel_bwidth_value.adjustment.value);
		});
		panel_corner_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Panel", "panel_corner", panel_corner_value.adjustment.value);
		});

		// Overview
		var overview_bg1_label = new Label.with_mnemonic ("Background gradient start");
		overview_bg1_label.set_halign (Align.START);
		overview_bg1_color = new ColorButton ();
		overview_bg1_color.set_use_alpha (true);
		overview_bg1_color.set_tooltip_text ("Set the background gradient start of the overview");
		var overview_bg2_label = new Label.with_mnemonic ("Background gradient end");
		overview_bg2_label.set_halign (Align.START);
		overview_bg2_color = new ColorButton ();
		overview_bg2_color.set_use_alpha (true);
		overview_bg2_color.set_tooltip_text ("Set the background gradient end of the overview");
		var overview_searchbg1_label = new Label.with_mnemonic ("Search entry background gradient start");
		overview_searchbg1_label.set_halign (Align.START);
		overview_searchbg1_color = new ColorButton ();
		overview_searchbg1_color.set_use_alpha (true);
		overview_searchbg1_color.set_tooltip_text ("Set the background gradient start of the search entry");
		var overview_searchbg2_label = new Label.with_mnemonic ("Search entry background gradient end");
		overview_searchbg2_label.set_halign (Align.START);
		overview_searchbg2_color = new ColorButton ();
		overview_searchbg2_color.set_use_alpha (true);
		overview_searchbg2_color.set_tooltip_text ("Set the background gradient end of the search entry");
		var overview_searchfocusbg1_label = new Label.with_mnemonic ("Focus search entry background gradient start");
		overview_searchfocusbg1_label.set_halign (Align.START);
		overview_searchfocusbg1_color = new ColorButton ();
		overview_searchfocusbg1_color.set_use_alpha (true);
		overview_searchfocusbg1_color.set_tooltip_text ("Set the background gradient start of the search entry in focus state");
		var overview_searchfocusbg2_label = new Label.with_mnemonic ("Focus search entry background gradient end");
		overview_searchfocusbg2_label.set_halign (Align.START);
		overview_searchfocusbg2_color = new ColorButton ();
		overview_searchfocusbg2_color.set_use_alpha (true);
		overview_searchfocusbg2_color.set_tooltip_text ("Set the background gradient end of the search entry in focus state");
		var overview_searchfg_label = new Label.with_mnemonic ("Search entry text color");
		overview_searchfg_label.set_halign (Align.START);
		overview_searchfg_color = new ColorButton ();
		overview_searchfg_color.set_use_alpha (true);
		overview_searchfg_color.set_tooltip_text ("Set the text color of the search entry");
		var overview_searchfocusfg_label = new Label.with_mnemonic ("Focus search entry text color");
		overview_searchfocusfg_label.set_halign (Align.START);
		overview_searchfocusfg_color = new ColorButton ();
		overview_searchfocusfg_color.set_use_alpha (true);
		overview_searchfocusfg_color.set_tooltip_text ("Set the text color of the search entry in focus state");
		var overview_searchborder_label = new Label.with_mnemonic ("Search entry border color");
		overview_searchborder_label.set_halign (Align.START);
		overview_searchborder_color = new ColorButton ();
		overview_searchborder_color.set_use_alpha (true);
		overview_searchborder_color.set_tooltip_text ("Set the border color of the search entry");
		var overview_searchfocusborder_label = new Label.with_mnemonic ("Focus search entry border color");
		overview_searchfocusborder_label.set_halign (Align.START);
		overview_searchfocusborder_color = new ColorButton ();
		overview_searchfocusborder_color.set_use_alpha (true);
		overview_searchfocusborder_color.set_tooltip_text ("Set the border color of the search entry in focus state");
		var overview_tint_label = new Label.with_mnemonic ("Background tint level");
		overview_tint_label.set_halign (Align.START);
		overview_tint_value = new SpinButton.with_range (0, 100, 1);
		overview_tint_value.set_tooltip_text ("Set the amount of highlight color to mix with the chosen background color of the overview");
		overview_tint_value.set_halign (Align.END);
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

		overview_bg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_bg1", overview_bg1_color.rgba.to_string());
		});
		overview_bg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_bg2", overview_bg2_color.rgba.to_string());
		});
		overview_searchbg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchbg1", overview_searchbg1_color.rgba.to_string());
		});
		overview_searchbg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchbg2", overview_searchbg2_color.rgba.to_string());
		});
		overview_searchfocusbg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchfocusbg1", overview_searchfocusbg1_color.rgba.to_string());
		});
		overview_searchfocusbg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchfocusbg2", overview_searchfocusbg2_color.rgba.to_string());
		});
		overview_searchfg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchfg", overview_searchfg_color.rgba.to_string());
		});
		overview_searchfocusfg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchfocusfg", overview_searchfocusfg_color.rgba.to_string());
		});
		overview_searchborder_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchborder", overview_searchborder_color.rgba.to_string());
		});
		overview_searchfocusborder_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Overview", "overview_searchfocusborder", overview_searchfocusborder_color.rgba.to_string());
		});
		overview_tint_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Overview", "overview_tint", overview_tint_value.adjustment.value);
		});
		overview_iconsize_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Overview", "overview_iconsize", overview_iconsize_value.adjustment.value);
		});
		overview_iconspacing_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Overview", "overview_iconspacing", overview_iconspacing_value.adjustment.value);
		});

		var overview_grid = new Grid ();
		overview_grid.set_column_homogeneous (true);
		overview_grid.set_column_spacing (12);
		overview_grid.set_row_spacing (12);
		overview_grid.attach (overview_bg1_label, 0, 0, 2, 1);
		overview_grid.attach_next_to (overview_bg1_color, overview_bg1_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_bg2_label, 0, 1, 2, 1);
		overview_grid.attach_next_to (overview_bg2_color, overview_bg2_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_searchbg1_label, 0, 2, 2, 1);
		overview_grid.attach_next_to (overview_searchbg1_color, overview_searchbg1_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_searchbg2_label, 0, 3, 2, 1);
		overview_grid.attach_next_to (overview_searchbg2_color, overview_searchbg2_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_searchfocusbg1_label, 0, 4, 2, 1);
		overview_grid.attach_next_to (overview_searchfocusbg1_color, overview_searchfocusbg1_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_searchfocusbg2_label, 0, 5, 2, 1);
		overview_grid.attach_next_to (overview_searchfocusbg2_color, overview_searchfocusbg2_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_searchfg_label, 0, 6, 2, 1);
		overview_grid.attach_next_to (overview_searchfg_color, overview_searchfg_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_searchfocusfg_label, 0, 7, 2, 1);
		overview_grid.attach_next_to (overview_searchfocusfg_color, overview_searchfocusfg_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_searchborder_label, 0, 8, 2, 1);
		overview_grid.attach_next_to (overview_searchborder_color, overview_searchborder_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_searchfocusborder_label, 0, 9, 2, 1);
		overview_grid.attach_next_to (overview_searchfocusborder_color, overview_searchfocusborder_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_tint_label, 0, 10, 2, 1);
		overview_grid.attach_next_to (overview_tint_value, overview_tint_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_iconsize_label, 0, 11, 2, 1);
		overview_grid.attach_next_to (overview_iconsize_value, overview_iconsize_label, PositionType.RIGHT, 1, 1);
		overview_grid.attach (overview_iconspacing_label, 0, 12, 2, 1);
		overview_grid.attach_next_to (overview_iconspacing_value, overview_iconspacing_label, PositionType.RIGHT, 1, 1);

		// Dash
		var dash_bg1_label = new Label.with_mnemonic ("Background gradient start");
		dash_bg1_label.set_halign (Align.START);
		dash_bg1_color = new ColorButton ();
		dash_bg1_color.set_use_alpha (true);
		dash_bg1_color.set_tooltip_text ("Set the background gradient start of the dash and workspace panel");
		var dash_bg2_label = new Label.with_mnemonic ("Background gradient end");
		dash_bg2_label.set_halign (Align.START);
		dash_bg2_color = new ColorButton ();
		dash_bg2_color.set_use_alpha (true);
		dash_bg2_color.set_tooltip_text ("Set the background gradient end of the dash and workspace panel");
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
		var dash_bwidth_label = new Label.with_mnemonic ("Border width");
		dash_bwidth_label.set_halign (Align.START);
		dash_bwidth_value = new SpinButton.with_range (0, 100, 1);
		dash_bwidth_value.set_tooltip_text ("Set the border width of the dash and workspace panel");
		dash_bwidth_value.set_halign (Align.END);

		dash_bg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dash", "dash_bg1", dash_bg1_color.rgba.to_string());
		});
		dash_bg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dash", "dash_bg2", dash_bg2_color.rgba.to_string());
		});
		dash_fg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dash", "dash_fg", dash_fg_color.rgba.to_string());
		});
		dash_border_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dash", "dash_border", dash_border_color.rgba.to_string());
		});
		dash_shadow_switch.notify["active"].connect (() => {
			on_value_changed ();
			key_file.set_boolean ("Dash", "dash_shadow", dash_shadow_switch.get_active());
		});
		dash_tint_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Dash", "dash_tint", dash_tint_value.adjustment.value);
		});
		dash_bwidth_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Dash", "dash_bwidth", dash_bwidth_value.adjustment.value);
		});

		var dash_grid = new Grid ();
		dash_grid.set_column_homogeneous (true);
		dash_grid.set_column_spacing (12);
		dash_grid.set_row_spacing (12);
		dash_grid.attach (dash_bg1_label, 0, 0, 2, 1);
		dash_grid.attach_next_to (dash_bg1_color, dash_bg1_label, PositionType.RIGHT, 1, 1);
		dash_grid.attach (dash_bg2_label, 0, 1, 2, 1);
		dash_grid.attach_next_to (dash_bg2_color, dash_bg2_label, PositionType.RIGHT, 1, 1);
		dash_grid.attach (dash_fg_label, 0, 2, 2, 1);
		dash_grid.attach_next_to (dash_fg_color, dash_fg_label, PositionType.RIGHT, 1, 1);
		dash_grid.attach (dash_border_label, 0, 3, 2, 1);
		dash_grid.attach_next_to (dash_border_color, dash_border_label, PositionType.RIGHT, 1, 1);
		dash_grid.attach (dash_shadow_label, 0, 4, 2, 1);
		dash_grid.attach_next_to (dash_shadow_switch, dash_shadow_label, PositionType.RIGHT, 1, 1);
		dash_grid.attach (dash_tint_label, 0, 5, 2, 1);
		dash_grid.attach_next_to (dash_tint_value, dash_tint_label, PositionType.RIGHT, 1, 1);
		dash_grid.attach (dash_bwidth_label, 0, 6, 2, 1);
		dash_grid.attach_next_to (dash_bwidth_value, dash_bwidth_label, PositionType.RIGHT, 1, 1);

		// Menu
		var menu_bg1_label = new Label.with_mnemonic ("Background gradient start");
		menu_bg1_label.set_halign (Align.START);
		menu_bg1_color = new ColorButton ();
		menu_bg1_color.set_use_alpha (true);
		menu_bg1_color.set_tooltip_text ("Set the background gradient start of the popup menu");
		var menu_bg2_label = new Label.with_mnemonic ("Background gradient end");
		menu_bg2_label.set_halign (Align.START);
		menu_bg2_color = new ColorButton ();
		menu_bg2_color.set_use_alpha (true);
		menu_bg2_color.set_tooltip_text ("Set the background gradient end of the popup menu");
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
		var menu_bwidth_label = new Label.with_mnemonic ("Border width");
		menu_bwidth_label.set_halign (Align.START);
		menu_bwidth_value = new SpinButton.with_range (0, 100, 1);
		menu_bwidth_value.set_tooltip_text ("Set the border width of the popup menu");
		menu_bwidth_value.set_halign (Align.END);

		menu_bg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Menu", "menu_bg1", menu_bg1_color.rgba.to_string());
		});
		menu_bg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Menu", "menu_bg2", menu_bg2_color.rgba.to_string());
		});
		menu_fg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Menu", "menu_fg", menu_fg_color.rgba.to_string());
		});
		menu_border_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Menu", "menu_border", menu_border_color.rgba.to_string());
		});
		menu_shadow_switch.notify["active"].connect (() => {
			on_value_changed ();
			key_file.set_boolean ("Menu", "menu_shadow", menu_shadow_switch.get_active());
		});
		menu_arrow_switch.notify["active"].connect (() => {
			on_value_changed ();
			key_file.set_boolean ("Menu", "menu_arrow", menu_arrow_switch.get_active());
		});
		menu_tint_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Menu", "menu_tint", menu_tint_value.adjustment.value);
		});
		menu_bwidth_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Menu", "menu_bwidth", menu_bwidth_value.adjustment.value);
		});

		var menu_grid = new Grid ();
		menu_grid.set_column_homogeneous (true);
		menu_grid.set_column_spacing (12);
		menu_grid.set_row_spacing (12);
		menu_grid.attach (menu_bg1_label, 0, 0, 2, 1);
		menu_grid.attach_next_to (menu_bg1_color, menu_bg1_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_bg2_label, 0, 1, 2, 1);
		menu_grid.attach_next_to (menu_bg2_color, menu_bg2_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_fg_label, 0, 2, 2, 1);
		menu_grid.attach_next_to (menu_fg_color, menu_fg_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_border_label, 0, 3, 2, 1);
		menu_grid.attach_next_to (menu_border_color, menu_border_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_shadow_label, 0, 4, 2, 1);
		menu_grid.attach_next_to (menu_shadow_switch, menu_shadow_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_arrow_label, 0, 5, 2, 1);
		menu_grid.attach_next_to (menu_arrow_switch, menu_arrow_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_tint_label, 0, 6, 2, 1);
		menu_grid.attach_next_to (menu_tint_value, menu_tint_label, PositionType.RIGHT, 1, 1);
		menu_grid.attach (menu_bwidth_label, 0, 7, 2, 1);
		menu_grid.attach_next_to (menu_bwidth_value, menu_bwidth_label, PositionType.RIGHT, 1, 1);

		// Dialogs
		var dialog_bg1_label = new Label.with_mnemonic ("Background gradient start");
		dialog_bg1_label.set_halign (Align.START);
		dialog_bg1_color = new ColorButton ();
		dialog_bg1_color.set_use_alpha (true);
		dialog_bg1_color.set_tooltip_text ("Set the background gradient start of the modal dialogs");
		var dialog_bg2_label = new Label.with_mnemonic ("Background gradient end");
		dialog_bg2_label.set_halign (Align.START);
		dialog_bg2_color = new ColorButton ();
		dialog_bg2_color.set_use_alpha (true);
		dialog_bg2_color.set_tooltip_text ("Set the background gradient end of the modal dialogs");
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
		var dialog_bwidth_label = new Label.with_mnemonic ("Border width");
		dialog_bwidth_label.set_halign (Align.START);
		dialog_bwidth_value = new SpinButton.with_range (0, 100, 1);
		dialog_bwidth_value.set_tooltip_text ("Set the border width of the modal dialogs");
		dialog_bwidth_value.set_halign (Align.END);

		dialog_bg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dialogs", "dialog_bg1", dialog_bg1_color.rgba.to_string());
		});
		dialog_bg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dialogs", "dialog_bg2", dialog_bg2_color.rgba.to_string());
		});
		dialog_fg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dialogs", "dialog_fg", dialog_fg_color.rgba.to_string());
		});
		dialog_heading_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dialogs", "dialog_heading", dialog_heading_color.rgba.to_string());
		});
		dialog_border_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Dialogs", "dialog_border", dialog_border_color.rgba.to_string());
		});
		dialog_shadow_switch.notify["active"].connect (() => {
			on_value_changed ();
			key_file.set_boolean ("Dialogs", "dialog_shadow", dialog_shadow_switch.get_active());
		});
		dialog_tint_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Dialogs", "dialog_tint", dialog_tint_value.adjustment.value);
		});
		dialog_bwidth_value.adjustment.value_changed.connect (() => {
			on_value_changed ();
			key_file.set_double ("Dialogs", "dialog_bwidth", dialog_bwidth_value.adjustment.value);
		});

		var dialog_grid = new Grid ();
		dialog_grid.set_column_homogeneous (true);
		dialog_grid.set_column_spacing (12);
		dialog_grid.set_row_spacing (12);
		dialog_grid.attach (dialog_bg1_label, 0, 0, 2, 1);
		dialog_grid.attach_next_to (dialog_bg1_color, dialog_bg1_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_bg2_label, 0, 1, 2, 1);
		dialog_grid.attach_next_to (dialog_bg2_color, dialog_bg2_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_fg_label, 0, 2, 2, 1);
		dialog_grid.attach_next_to (dialog_fg_color, dialog_fg_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_heading_label, 0, 3, 2, 1);
		dialog_grid.attach_next_to (dialog_heading_color, dialog_heading_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_border_label, 0, 4, 2, 1);
		dialog_grid.attach_next_to (dialog_border_color, dialog_border_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_shadow_label, 0, 5, 2, 1);
		dialog_grid.attach_next_to (dialog_shadow_switch, dialog_shadow_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_tint_label, 0, 6, 2, 1);
		dialog_grid.attach_next_to (dialog_tint_value, dialog_tint_label, PositionType.RIGHT, 1, 1);
		dialog_grid.attach (dialog_bwidth_label, 0, 7, 2, 1);
		dialog_grid.attach_next_to (dialog_bwidth_value, dialog_bwidth_label, PositionType.RIGHT, 1, 1);

		// Buttons
		var button_bg1_label = new Label.with_mnemonic ("Background gradient start");
		button_bg1_label.set_halign (Align.START);
		button_bg1_color = new ColorButton ();
		button_bg1_color.set_use_alpha (true);
		button_bg1_color.set_tooltip_text ("Set the background gradient start of the buttons");
		var button_bg2_label = new Label.with_mnemonic ("Background gradient end");
		button_bg2_label.set_halign (Align.START);
		button_bg2_color = new ColorButton ();
		button_bg2_color.set_use_alpha (true);
		button_bg2_color.set_tooltip_text ("Set the background gradient end of the buttons");
		var button_hoverbg1_label = new Label.with_mnemonic ("Hover background gradient start");
		button_hoverbg1_label.set_halign (Align.START);
		button_hoverbg1_color = new ColorButton ();
		button_hoverbg1_color.set_use_alpha (true);
		button_hoverbg1_color.set_tooltip_text ("Set the background gradient start of the buttons in hover state");
		var button_hoverbg2_label = new Label.with_mnemonic ("Hover background gradient end");
		button_hoverbg2_label.set_halign (Align.START);
		button_hoverbg2_color = new ColorButton ();
		button_hoverbg2_color.set_use_alpha (true);
		button_hoverbg2_color.set_tooltip_text ("Set the background gradient end of the buttons in hover state");
		var button_activebg1_label = new Label.with_mnemonic ("Active background gradient start");
		button_activebg1_label.set_halign (Align.START);
		button_activebg1_color = new ColorButton ();
		button_activebg1_color.set_use_alpha (true);
		button_activebg1_color.set_tooltip_text ("Set the background gradient start of the buttons in active state");
		var button_activebg2_label = new Label.with_mnemonic ("Active background gradient end");
		button_activebg2_label.set_halign (Align.START);
		button_activebg2_color = new ColorButton ();
		button_activebg2_color.set_use_alpha (true);
		button_activebg2_color.set_tooltip_text ("Set the background gradient end of the buttons in active state");
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

		var button_grid = new Grid ();
		button_grid.set_column_homogeneous (true);
		button_grid.set_column_spacing (12);
		button_grid.set_row_spacing (12);
		button_grid.attach (button_bg1_label, 0, 0, 2, 1);
		button_grid.attach_next_to (button_bg1_color, button_bg1_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_bg2_label, 0, 1, 2, 1);
		button_grid.attach_next_to (button_bg2_color, button_bg2_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_hoverbg1_label, 0, 2, 2, 1);
		button_grid.attach_next_to (button_hoverbg1_color, button_hoverbg1_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_hoverbg2_label, 0, 3, 2, 1);
		button_grid.attach_next_to (button_hoverbg2_color, button_hoverbg2_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_activebg1_label, 0, 4, 2, 1);
		button_grid.attach_next_to (button_activebg1_color, button_activebg1_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_activebg2_label, 0, 5, 2, 1);
		button_grid.attach_next_to (button_activebg2_color, button_activebg2_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_fg_label, 0, 6, 2, 1);
		button_grid.attach_next_to (button_fg_color, button_fg_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_hoverfg_label, 0, 7, 2, 1);
		button_grid.attach_next_to (button_hoverfg_color, button_hoverfg_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_activefg_label, 0, 8, 2, 1);
		button_grid.attach_next_to (button_activefg_color, button_activefg_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_border_label, 0, 9, 2, 1);
		button_grid.attach_next_to (button_border_color, button_border_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_hoverborder_label, 0, 10, 2, 1);
		button_grid.attach_next_to (button_hoverborder_color, button_hoverborder_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_activeborder_label, 0, 11, 2, 1);
		button_grid.attach_next_to (button_activeborder_color, button_activeborder_label, PositionType.RIGHT, 1, 1);
		button_grid.attach (button_bold_label, 0, 12, 2, 1);
		button_grid.attach_next_to (button_bold_switch, button_bold_label, PositionType.RIGHT, 1, 1);

		button_bg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_bg1", button_bg1_color.rgba.to_string());
		});
		button_bg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_bg2", button_bg2_color.rgba.to_string());
		});
		button_hoverbg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_hoverbg1", button_hoverbg1_color.rgba.to_string());
		});
		button_hoverbg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_hoverbg2", button_hoverbg2_color.rgba.to_string());
		});
		button_activebg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_activebg1", button_activebg1_color.rgba.to_string());
		});
		button_activebg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_activebg2", button_activebg2_color.rgba.to_string());
		});
		button_fg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_fg", button_fg_color.rgba.to_string());
		});
		button_hoverfg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_hoverfg", button_hoverfg_color.rgba.to_string());
		});
		button_activefg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_activefg", button_activefg_color.rgba.to_string());
		});
		button_border_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_border", button_border_color.rgba.to_string());
		});
		button_hoverborder_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_hoverborder", button_hoverborder_color.rgba.to_string());
		});
		button_activeborder_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Buttons", "button_activeborder", button_activeborder_color.rgba.to_string());
		});
		button_bold_switch.notify["active"].connect (() => {
			on_value_changed ();
			key_file.set_boolean ("Buttons", "button_bold", button_bold_switch.get_active());
		});

		// Entry
		var entry_bg1_label = new Label.with_mnemonic ("Background gradient start");
		entry_bg1_label.set_halign (Align.START);
		entry_bg1_color = new ColorButton ();
		entry_bg1_color.set_use_alpha (true);
		entry_bg1_color.set_tooltip_text ("Set the background gradient start of the entry widget");
		var entry_bg2_label = new Label.with_mnemonic ("Background gradient end");
		entry_bg2_label.set_halign (Align.START);
		entry_bg2_color = new ColorButton ();
		entry_bg2_color.set_use_alpha (true);
		entry_bg2_color.set_tooltip_text ("Set the background gradient end of the entry widget");
		var entry_focusbg1_label = new Label.with_mnemonic ("Focus background gradient start");
		entry_focusbg1_label.set_halign (Align.START);
		entry_focusbg1_color = new ColorButton ();
		entry_focusbg1_color.set_use_alpha (true);
		entry_focusbg1_color.set_tooltip_text ("Set the background gradient start of the entry widget in focus state");
		var entry_focusbg2_label = new Label.with_mnemonic ("Focus background gradient end");
		entry_focusbg2_label.set_halign (Align.START);
		entry_focusbg2_color = new ColorButton ();
		entry_focusbg2_color.set_use_alpha (true);
		entry_focusbg2_color.set_tooltip_text ("Set the background gradient end of the entry widget in focus state");
		var entry_fg_label = new Label.with_mnemonic ("Text color");
		entry_fg_label.set_halign (Align.START);
		entry_fg_color = new ColorButton ();
		entry_fg_color.set_use_alpha (true);
		entry_fg_color.set_tooltip_text ("Set the text color of the entry widget in focus state");
		var entry_focusfg_label = new Label.with_mnemonic ("Focus text color");
		entry_focusfg_label.set_halign (Align.START);
		entry_focusfg_color = new ColorButton ();
		entry_focusfg_color.set_use_alpha (true);
		entry_focusfg_color.set_tooltip_text ("Set the text color of the entry widget");
		var entry_border_label = new Label.with_mnemonic ("Border color");
		entry_border_label.set_halign (Align.START);
		entry_border_color = new ColorButton ();
		entry_border_color.set_use_alpha (true);
		entry_border_color.set_tooltip_text ("Set the border color of the entry widget in focus state");
		var entry_focusborder_label = new Label.with_mnemonic ("Focus border color");
		entry_focusborder_label.set_halign (Align.START);
		entry_focusborder_color = new ColorButton ();
		entry_focusborder_color.set_use_alpha (true);
		entry_focusborder_color.set_tooltip_text ("Set the border color of the entry widget in focus state");
		var entry_shadow_label = new Label.with_mnemonic ("Inset shadow");
		entry_shadow_label.set_halign (Align.START);
		entry_shadow_switch = new Switch ();
		entry_shadow_switch.set_tooltip_text ("Enable/disable inset shadow in the entry widget");
		entry_shadow_switch.set_halign (Align.END);

		var entry_grid = new Grid ();
		entry_grid.set_column_homogeneous (true);
		entry_grid.set_column_spacing (12);
		entry_grid.set_row_spacing (12);
		entry_grid.attach (entry_bg1_label, 0, 0, 2, 1);
		entry_grid.attach_next_to (entry_bg1_color, entry_bg1_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_bg2_label, 0, 1, 2, 1);
		entry_grid.attach_next_to (entry_bg2_color, entry_bg2_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_focusbg1_label, 0, 2, 2, 1);
		entry_grid.attach_next_to (entry_focusbg1_color, entry_focusbg1_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_focusbg2_label, 0, 3, 2, 1);
		entry_grid.attach_next_to (entry_focusbg2_color, entry_focusbg2_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_fg_label, 0, 4, 2, 1);
		entry_grid.attach_next_to (entry_fg_color, entry_fg_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_focusfg_label, 0, 5, 2, 1);
		entry_grid.attach_next_to (entry_focusfg_color, entry_focusfg_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_border_label, 0, 6, 2, 1);
		entry_grid.attach_next_to (entry_border_color, entry_border_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_focusborder_label, 0, 7, 2, 1);
		entry_grid.attach_next_to (entry_focusborder_color, entry_focusborder_label, PositionType.RIGHT, 1, 1);
		entry_grid.attach (entry_shadow_label, 0, 8, 2, 1);
		entry_grid.attach_next_to (entry_shadow_switch, entry_shadow_label, PositionType.RIGHT, 1, 1);

		entry_bg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Entry", "entry_bg1", entry_bg1_color.rgba.to_string());
		});
		entry_bg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Entry", "entry_bg2", entry_bg2_color.rgba.to_string());
		});
		entry_focusbg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Entry", "entry_focusbg1", entry_focusbg1_color.rgba.to_string());
		});
		entry_focusbg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Entry", "entry_focusbg2", entry_focusbg2_color.rgba.to_string());
		});
		entry_fg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Entry", "entry_fg", entry_fg_color.rgba.to_string());
		});
		entry_focusfg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Entry", "entry_focusfg", entry_focusfg_color.rgba.to_string());
		});
		entry_border_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Entry", "entry_border", entry_border_color.rgba.to_string());
		});
		entry_focusborder_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Entry", "entry_focusborder", entry_focusborder_color.rgba.to_string());
		});
		entry_shadow_switch.notify["active"].connect (() => {
			on_value_changed ();
			key_file.set_boolean ("Entry", "entry_shadow", entry_shadow_switch.get_active());
		});

		// Misc
		var misc_runningbg1_label = new Label.with_mnemonic ("Background gradient start for running apps");
		misc_runningbg1_label.set_halign (Align.START);
		misc_runningbg1_color = new ColorButton ();
		misc_runningbg1_color.set_use_alpha (true);
		misc_runningbg1_color.set_tooltip_text ("Set the background gradient start for the icons of running apps");
		var misc_runningbg2_label = new Label.with_mnemonic ("Background gradient end for running apps");
		misc_runningbg2_label.set_halign (Align.START);
		misc_runningbg2_color = new ColorButton ();
		misc_runningbg2_color.set_use_alpha (true);
		misc_runningbg2_color.set_tooltip_text ("Set the background gradient end for the icons of running apps");
		var misc_separator1_label = new Label.with_mnemonic ("Separator gradient start");
		misc_separator1_label.set_halign (Align.START);
		misc_separator1_color = new ColorButton ();
		misc_separator1_color.set_use_alpha (true);
		misc_separator1_color.set_tooltip_text ("Set the starting gradient color of separators");
		var misc_separator2_label = new Label.with_mnemonic ("Separator gradient end");
		misc_separator2_label.set_halign (Align.START);
		misc_separator2_color = new ColorButton ();
		misc_separator2_color.set_use_alpha (true);
		misc_separator2_color.set_tooltip_text ("Set the ending gradient color of separators");
		var misc_tooltipbg1_label = new Label.with_mnemonic ("Tooltip background gradient start");
		misc_tooltipbg1_label.set_halign (Align.START);
		misc_tooltipbg1_color = new ColorButton ();
		misc_tooltipbg1_color.set_use_alpha (true);
		misc_tooltipbg1_color.set_tooltip_text ("Set the starting gradient color of tooltips");
		var misc_tooltipbg2_label = new Label.with_mnemonic ("Tooltip background gradient end");
		misc_tooltipbg2_label.set_halign (Align.START);
		misc_tooltipbg2_color = new ColorButton ();
		misc_tooltipbg2_color.set_use_alpha (true);
		misc_tooltipbg2_color.set_tooltip_text ("Set the ending gradient color of tooltips");
		var misc_tooltipfg_label = new Label.with_mnemonic ("Tooltip text color");
		misc_tooltipfg_label.set_halign (Align.START);
		misc_tooltipfg_color = new ColorButton ();
		misc_tooltipfg_color.set_use_alpha (true);
		misc_tooltipfg_color.set_tooltip_text ("Set the text color of tooltips");
		var misc_tooltipborder_label = new Label.with_mnemonic ("Tooltip border color");
		misc_tooltipborder_label.set_halign (Align.START);
		misc_tooltipborder_color = new ColorButton ();
		misc_tooltipborder_color.set_use_alpha (true);
		misc_tooltipborder_color.set_tooltip_text ("Set the border color of tooltips");

		var misc_grid = new Grid ();
		misc_grid.set_column_homogeneous (true);
		misc_grid.set_column_spacing (12);
		misc_grid.set_row_spacing (12);
		misc_grid.attach (misc_runningbg1_label, 0, 0, 2, 1);
		misc_grid.attach_next_to (misc_runningbg1_color, misc_runningbg1_label, PositionType.RIGHT, 1, 1);
		misc_grid.attach (misc_runningbg2_label, 0, 1, 2, 1);
		misc_grid.attach_next_to (misc_runningbg2_color, misc_runningbg2_label, PositionType.RIGHT, 1, 1);
		misc_grid.attach (misc_separator1_label, 0, 2, 2, 1);
		misc_grid.attach_next_to (misc_separator1_color, misc_separator1_label, PositionType.RIGHT, 1, 1);
		misc_grid.attach (misc_separator2_label, 0, 3, 2, 1);
		misc_grid.attach_next_to (misc_separator2_color, misc_separator2_label, PositionType.RIGHT, 1, 1);
		misc_grid.attach (misc_tooltipbg1_label, 0, 4, 2, 1);
		misc_grid.attach_next_to (misc_tooltipbg1_color, misc_tooltipbg1_label, PositionType.RIGHT, 1, 1);
		misc_grid.attach (misc_tooltipbg2_label, 0, 5, 2, 1);
		misc_grid.attach_next_to (misc_tooltipbg2_color, misc_tooltipbg2_label, PositionType.RIGHT, 1, 1);
		misc_grid.attach (misc_tooltipfg_label, 0, 6, 2, 1);
		misc_grid.attach_next_to (misc_tooltipfg_color, misc_tooltipfg_label, PositionType.RIGHT, 1, 1);
		misc_grid.attach (misc_tooltipborder_label, 0, 7, 2, 1);
		misc_grid.attach_next_to (misc_tooltipborder_color, misc_tooltipborder_label, PositionType.RIGHT, 1, 1);

		misc_runningbg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_runningbg1", misc_runningbg1_color.rgba.to_string());
		});
		misc_runningbg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_runningbg2", misc_runningbg2_color.rgba.to_string());
		});
		misc_separator1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_separator1", misc_separator1_color.rgba.to_string());
		});
		misc_separator2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_separator2", misc_separator2_color.rgba.to_string());
		});
		misc_tooltipbg1_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_tooltipbg1", misc_tooltipbg1_color.rgba.to_string());
		});
		misc_tooltipbg2_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_tooltipbg2", misc_tooltipbg2_color.rgba.to_string());
		});
		misc_tooltipfg_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_tooltipfg", misc_tooltipfg_color.rgba.to_string());
		});
		misc_tooltipborder_color.color_set.connect (() => {
			on_value_changed ();
			key_file.set_string ("Misc", "misc_tooltipborder", misc_tooltipborder_color.rgba.to_string());
		});

		// Toolbar
		undo_button = new ToolButton.from_stock (Stock.UNDO);
		undo_button.set_tooltip_text ("Undo the last change");
		redo_button = new ToolButton.from_stock (Stock.REDO);
		redo_button.set_tooltip_text ("Redo the last undone change");
		clear_button = new ToolButton.from_stock (Stock.CLEAR);
		clear_button.set_tooltip_text ("Clear all changes");

		undo_button.clicked.connect (on_undo_clicked);
		redo_button.clicked.connect (on_redo_clicked);
		clear_button.clicked.connect (on_clear_clicked);

		var toolbar = new Toolbar ();
		toolbar.get_style_context().add_class("primary-toolbar");
		toolbar.add (undo_button);
		toolbar.add (redo_button);
		toolbar.add (clear_button);

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
		notebook.append_page (overview_grid, null);
		notebook.append_page (dash_grid, null);
		notebook.append_page (menu_grid, null);
		notebook.append_page (dialog_grid, null);
		notebook.append_page (button_grid, null);
		notebook.append_page (entry_grid, null);
		notebook.append_page (misc_grid, null);

		var mainbox = new Box (Orientation.VERTICAL, 12);
		mainbox.set_border_width (12);
		mainbox.add (notebook);
		mainbox.add (buttons);

		var list_store = new ListStore (2, typeof (string), typeof (int));
		TreeIter iter;

		list_store.append (out iter);
		list_store.set (iter, 0, "General", 1, 0);
		list_store.append (out iter);
		list_store.set (iter, 0, "Panel", 1, 1);
		list_store.append (out iter);
		list_store.set (iter, 0, "Overview", 1, 2);
		list_store.append (out iter);
		list_store.set (iter, 0, "Dash", 1, 3);
		list_store.append (out iter);
		list_store.set (iter, 0, "Menu", 1, 4);
		list_store.append (out iter);
		list_store.set (iter, 0, "Dialogs", 1, 5);
		list_store.append (out iter);
		list_store.set (iter, 0, "Buttons", 1, 6);
		list_store.append (out iter);
		list_store.set (iter, 0, "Entry", 1, 7);
		list_store.append (out iter);
		list_store.set (iter, 0, "Misc", 1, 8);

		var treeview = new TreeView.with_model (list_store);
		var treepath = new TreePath.from_string ("0");
		treeview.set_size_request(100,-1);
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

		notebook.set_current_page (0);
		apply_button.set_sensitive (false);

		this.add (vbox);

		list_undo = new List<string> ();
		list_redo = new List<string> ();

		redo_button.set_sensitive (false);
		undo_button.set_sensitive (false);
		clear_button.set_sensitive (false);
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

		list_undo.append (key_file.to_data(null,null));

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
		list_redo.append (key_file.to_data(null,null));
		unowned string? data = list_undo.nth_data (list_undo.length()-1);
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
		data = list_undo.nth_data (list_undo.length()-1);
		list_undo.remove (data);
		data = list_undo.nth_data (list_undo.length()-1);
		if (data == null) {
			undo_button.set_sensitive (false);
		}

		new_button_clicked = false;
		
	}

	void on_redo_clicked () {

		undo_button.set_sensitive (true);
		list_undo.append (key_file.to_data(null,null));
		unowned string? data = list_redo.nth_data (list_redo.length()-1);
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
		data = list_undo.nth_data (list_undo.length()-1);
		list_undo.remove (data);
		data = list_redo.nth_data (list_redo.length()-1);
		if (data == null) {
			redo_button.set_sensitive (false);
		}

		new_button_clicked = false;
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
		set_states ();
		on_value_changed ();
	}

	void on_config_applied () {

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
