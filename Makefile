#!/usr/bin/make -f

build:
	echo "Nothing to do here"

clean:
	echo "Nothing to do here"

install:
    # The sommelier script itself
	install -D -m755 scripts/sommelier "$(DESTDIR)"/bin/sommelier

	# Empty directories for mounting content snaps
	install -d "$(DESTDIR)"/wine-runtime
	install -d "$(DESTDIR)"/wine-platform

    # Chinese languages config
	install -D -m644 config/noto-sans-cjk-tc-regular.reg "$(DESTDIR)"/sommelier/config/noto-sans-cjk-tc-regular.reg
	install -D -m644 config/noto-sans-cjk-sc-regular.reg "$(DESTDIR)"/sommelier/config/noto-sans-cjk-sc-regular.reg

    # Themes
	install -D -m644 themes/modern/modern.msstyles "$(DESTDIR)"/sommelier/themes/modern/modern.msstyles
	install -D -m644 themes/modern/modern.reg "$(DESTDIR)"/sommelier/themes/modern/modern.reg
