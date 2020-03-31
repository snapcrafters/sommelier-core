#!/usr/bin/make -f

build:
	echo "Nothing to do here"

clean:
	echo "Nothing to do here"

install:
	install -D -m755 scripts/sommelier "$(DESTDIR)"/bin/sommelier
	install -D -m644 themes/modern/modern.msstyles "$(DESTDIR)"/themes/modern.msstyles
	install -D -m644 themes/modern/modern.reg "$(DESTDIR)"/themes/modern.reg
	install -d "$(DESTDIR)"/wine-runtime
	install -d "$(DESTDIR)"/wine-platform
