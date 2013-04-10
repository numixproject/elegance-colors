### Introduction

Elegance Colors is a customizable chameleon theme for Gnome Shell. It can change colors according to the current GTK theme, current wallpaper (uses imagemagick to get color) or a user defined color. Also various other aspects of the theme are customizable.

Currently Elegance Colors supports Gnome Shell 3.6 and 3.8.

### License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see [gnu.org/licenses](http://www.gnu.org/licenses/).

Copyright (C) [Satyajit Sahoo](mailto:satyajit.happy@gmail.com)

### How to install

Ubuntu users can install Elegance Colors from our themes PPA using the following commands,

`sudo add-apt-repository ppa:satyajit-happy/themes`
`sudo apt-get update && sudo apt-get install gnome-shell-theme-elegance-colors`

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

A process runs in background which detects changes, generates the theme and reloads the theme accordingly. After installation, you must run the following command to start the background process,

`elegance-colors`

To set the theme, run the following commands,

`gsettings set org.gnome.shell.extensions.user-theme name 'elegance-colors'`

You can launch the GUI from the menu which lets you customise various aspects of the the theme. You can also export your customized theme, import/export settings from the GMenu. Click on the title in the Gnome Shell top bar to get the GMenu.

### Troubleshooting

It is recommended to stop any previous instances of elegance-colors when updating to a new version. You can stop the running process of elegance-colors with the command,

`elegance-colors stop`

To view any error messages produced, run the process in Terminal,

`elegance-colors start`

To manually apply changes, run,

`elegance-colors apply`

To export the theme, run,

`elegance-colors export /path/to/themefile.zip`

### Getting the source

You can get the latest source code from the [GitHub page](https://github.com/satya164/elegance-colors).

`git clone git@github.com:satya164/elegance-colors.git`

### Bugs and feature requests

Please submit bugs and feature requests [here](http://github.com/satya164/elegance-colors/issues).
