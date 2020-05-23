# dmenu - dynamic menu
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dlauncher.c stest.c util.c
OBJ = $(SRC:.c=.o)

all: options dlauncher stest

options:
	@echo dlauncher build options:
	@echo "CFLAGS   = $(CFLAGS)"
	@echo "LDFLAGS  = $(LDFLAGS)"
	@echo "CC       = $(CC)"

.c.o:
	$(CC) -c $(CFLAGS) $<

config.h:
	cp config.def.h $@

$(OBJ): arg.h config.h config.mk drw.h

dlauncher: dlauncher.o drw.o util.o
	$(CC) -o $@ dlauncher.o drw.o util.o $(LDFLAGS)

stest: stest.o
	$(CC) -o $@ stest.o $(LDFLAGS)

clean:
	rm -f dlauncher stest $(OBJ) dlauncher-$(VERSION).tar.gz

dist: clean
	mkdir -p dlauncher-$(VERSION)
	cp LICENSE Makefile README arg.h config.def.h config.mk dlauncher.1\
		drw.h util.h dlauncher_path dlauncher_run stest.1 $(SRC)\
		dlauncher-$(VERSION)
	tar -cf dlauncher-$(VERSION).tar dlauncher-$(VERSION)
	gzip dlauncher-$(VERSION).tar
	rm -rf dlauncher-$(VERSION)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f dlauncher dlauncher_path dlauncher_run stest $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dlauncher
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dlauncher_path
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dlauncher_run
	chmod 755 $(DESTDIR)$(PREFIX)/bin/stest
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < dlauncher.1 > $(DESTDIR)$(MANPREFIX)/man1/dlauncher.1
	sed "s/VERSION/$(VERSION)/g" < stest.1 > $(DESTDIR)$(MANPREFIX)/man1/stest.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/dlauncher.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/stest.1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/dlauncher\
		$(DESTDIR)$(PREFIX)/bin/dlauncher_path\
		$(DESTDIR)$(PREFIX)/bin/dlauncher_run\
		$(DESTDIR)$(PREFIX)/bin/stest\
		$(DESTDIR)$(MANPREFIX)/man1/dlauncher.1\
		$(DESTDIR)$(MANPREFIX)/man1/stest.1

.PHONY: all options clean dist install uninstall
