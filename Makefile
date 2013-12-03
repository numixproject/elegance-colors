CC=valac
CFLAGS=--pkg gtk+-3.0
SRC=elegance-colors-prefs.vala
MAIN=elegance-colors-prefs
INSTALL=install
INSTALL_PROGRAM=$(INSTALL) -Dpm 0755
INSTALL_DATA=$(INSTALL) -Dpm 0644
INSTALL_DIRECTORY=$(INSTALL) -dm755
GTK_UPDATE_ICON_CACHE=gtk-update-icon-cache -f -t

all: $(MAIN)

$(MAIN): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(MAIN)

clean:
	$(RM) *~ $(MAIN)

install: $(MAIN)
	$(INSTALL_PROGRAM) elegance-colors-prefs $(DESTDIR)/usr/bin/elegance-colors-prefs
	$(INSTALL_PROGRAM) elegance-colors $(DESTDIR)/usr/bin/elegance-colors
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/share/elegance-colors/presets
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/share/elegance-colors/modules
	$(INSTALL_DATA) README.md $(DESTDIR)/usr/share/elegance-colors/README.md
	$(INSTALL_DATA) presets/* $(DESTDIR)/usr/share/elegance-colors/presets
	$(INSTALL_DATA) modules/* $(DESTDIR)/usr/share/elegance-colors/modules
	$(INSTALL_DATA) elegance-colors.svg $(DESTDIR)/usr/share/icons/hicolor/scalable/apps/elegance-colors.svg
	$(INSTALL_DATA) elegance-colors-prefs.desktop $(DESTDIR)/usr/share/applications/elegance-colors-prefs.desktop
	$(INSTALL_DATA) elegance-colors.desktop $(DESTDIR)/etc/xdg/autostart/elegance-colors.desktop
	$(INSTALL_DATA) elegance-colors.appdata.xml $(DESTDIR)/usr/share/appdata/elegance-colors.appdata.xml
	$(INSTALL_DATA) CREDITS $(DESTDIR)/usr/share/elegance-colors/CREDITS
	for dir in templates/*; do \
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/share/elegance-colors/$$dir; \
	$(INSTALL_DATA) $$dir/* $(DESTDIR)/usr/share/elegance-colors/$$dir; \
	done
	@-if test -z $(DESTDIR); then $(GTK_UPDATE_ICON_CACHE) $(DESTDIR)/usr/share/icons/hicolor; fi

uninstall:
	$(RM) $(DESTDIR)/usr/share/icons/hicolor/scalable/apps/elegance-colors*
	$(RM) $(DESTDIR)/usr/share/applications/elegance-colors*
	$(RM) $(DESTDIR)/usr/share/appdata/elegance-colors*
	$(RM) $(DESTDIR)/usr/bin/elegance-colors*
	$(RM) $(DESTDIR)/etc/xdg/autostart/elegance-colors*
	$(RM) -r $(DESTDIR)/usr/share/elegance-colors*
	@-if test -z $(DESTDIR); then $(GTK_UPDATE_ICON_CACHE) $(DESTDIR)/usr/share/icons/hicolor; fi

