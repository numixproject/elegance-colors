### Introduction

Elegance Colors is a highly customizable chameleon theme for Gnome Shell. It can change colors according to the current GTK theme, current wallpaper (uses imagemagick to get color) or use a user defined color.

### License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see [gnu.org/licenses](http://www.gnu.org/licenses/).

Copyright (C) [Satyajit Sahoo](mailto:satyajit.happy@gmail.com)

### Installation

Ubuntu users can install Elegance Colors from our themes PPA using the following commands,

	sudo add-apt-repository ppa:satyajit-happy/themes
	sudo apt-get update && sudo apt-get install gnome-shell-theme-elegance-colors

Fedora and OpenSUSE users can add the appropriate repo from [opensuse build service](http://download.opensuse.org/repositories/home:/satya164:/elegance-colors/) and install the package `gnome-shell-theme-elegance-colors` via the distro's package manager.

Arch Linux users can install Elegance Colors from [aur](https://aur.archlinux.org/packages/gnome-shell-themes-elegance-colors/).

If you use another distro, you need to compile from source. This is needed for the GUI.

Don't worry, it is easy and straight forward.

You need to install the build-dependencies first (package names may vary depending on your distro),

`glib2-devel gtk3-devel vala`

Extract the archive, navigate to the directory and type the following commands in a terminal,

`make`
`sudo make install`

To derive color from wallpaper, you need to install ImageMagick

Also install the [User Theme Extension](https://extensions.gnome.org/extension/19/user-themes/) for Gnome Shell.

### Setup

A process runs in background which detects changes, generates the theme and reloads the theme accordingly. After installation, you must run the following command to start the background process,

`elegance-colors`

To set the theme, choose the theme via Gnome Tweak Tool or run the following commands,

`gsettings set org.gnome.shell.extensions.user-theme name 'elegance-colors'`

You can launch the GUI from the menu which lets you customise various aspects of the the theme. You can also export your customized theme, import/export settings from the GMenu. Click on the title in the Gnome Shell top bar to get the GMenu.

### Advanced configuration

Apart from the included presets, Elegance Colors supports user presets installed under `~/.config/elegance-colors/presets/`

To create a preset, just export your customized settings from the GMenu and give it a name by editing the exported file and adding the following at the beginning,

`# Name: Your Awesome Name`

You can also change the settings by editing the file `~/.config/elegance-colors.ini` instead of using the GUI. It also gives more power to you by enabling you to use symbolic colors.

For example, you can use,

`button_activebg1=@mode`

Where `@mode` is the color derived from the wallpaper, GTK theme or a custom color.

There are 3 methods for manipulating colors, `alpha` - for making a color translucent, `shade` - to darken or lighten a color, `tint` - to mix a color with another.

For example, you can use,

`button_activebg1=shade;@mode;-10`

It takes the symbolic color `@mode`, and darkens it by "10". You can have a look at the included presets to have more understanding.

If you want even more customization, you can include single line custom CSS code,

For example,

	[Include]
	include_code=.toggle-switch-us:checked,.toggle-switch-intl:checked{background-color:rgba(83,169,63,1.0);}

If that's not enough, you can also include a custom CSS file to override the values in the default template.

To include a custom CSS file, create a directory under `~/.config/elegance-colors/presets/` and put all required files there. Then list the files to be included in the configuration file,

For example,

	[Include]
	include_dir=custom
	include_css=close.css;switches.css
	include_files=close.png;on.png;off.png

### Troubleshooting

It is recommended to stop any previous instances of elegance-colors when updating to a new version. You can stop the running process of elegance-colors with the command,

`elegance-colors stop`

To view any error messages produced, run the process in Terminal,

`elegance-colors start`

To manually apply changes, run,

`elegance-colors apply`

If your theme fails to apply after an upgrade, it is likely that the config file doesn't include new options. To update the config file, run,

`elegance-colors update`

To export the theme, run,

`elegance-colors export /path/to/themefile.zip`

### Getting the source

You can get the latest source code from the [GitHub page](https://github.com/satya164/elegance-colors).

`git clone git@github.com:satya164/elegance-colors.git`

### Bugs and feature requests

Please submit bugs and feature requests [here](http://github.com/satya164/elegance-colors/issues).
