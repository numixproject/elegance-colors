### Introduction

Elegance Colors is a chameleon theme for Gnome Shell. It can change colors according to the current GTK theme, current wallpaper (uses imagemagick to get color) or a user defined color. Also various other aspects of the theme are customizable.

Currently Elegance Colors supports only Gnome Shell 3.6.

### License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see [gnu.org/licenses](http://www.gnu.org/licenses/).

Copyright (C) [Satyajit Sahoo](mailto:satyajit.happy@gmail.com)

### How to install

Ubuntu users can install Elegance Colors from our themes PPA using the following commands,

`sudo add-apt-repository ppa:satyajit-happy/themes`
`sudo apt-get update && sudo apt-get install gnome-shell-theme-elegance-colors`

Fedora users can add the [repo](http://download.opensuse.org/repositories/home:/satya164:/elegance-colors/Fedora_18/home:satya164:elegance-colors.repo) and then install Elegance Colors using the following commands,

`sudo yum install gnome-shell-theme-elegance-colors`

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

If you have installed the user-theme extension from the [GNOME Shell Extensions](http://extensions.gnome.org) website, you might need to run the following command before elegance-colors can work,

`elegance-colors fix`

It is recommended to stop any previous instances of elegance-colors when updating to a new version. You can kill running processes of elegance-colors with the command,

`killall elegance-colors`

To view any error messages produced, stop the background process first and then run the process in Terminal,

`elegance-colors stop`
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
