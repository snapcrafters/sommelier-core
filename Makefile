#!/usr/bin/make -f

LIB_DIR	     := $(DESTDIR)/lib
BINDTEXTDOMAIN  := bindtextdomain.so
HW_PLATFORM     := $(shell uname --hardware-platform)
ARCH_32         := i386-linux-gnu

build:
	# Build the 32-bit version of the bindtextdomain patch. This patch
	# makes it easier for applications to find gettext translations shipped
	# by snaps. 
	#
	# The Gnome extensions only compile the library for 64-bit arch. 
ifeq ($(HW_PLATFORM), x86_64)
	sudo apt-get -y install libc6-dev-i386
	sudo apt-get -y install gcc-multilib
	mkdir -p $(ARCH_32)
	gcc -m32 -Wall -O2 -o $(ARCH_32)/$(BINDTEXTDOMAIN) -fPIC -shared /snap/snapcraft/current/share/snapcraft/extensions/desktop/src/bindtextdomain.c -ldl
endif

clean:
	rm -rf $(ARCH_32)

install:
	# The sommelier script itself
	install -D -m755 scripts/sommelier "$(DESTDIR)"/bin/sommelier

	# Empty directories for mounting content snaps
	install -d "$(DESTDIR)"/wine-runtime
	install -d "$(DESTDIR)"/wine-platform

	# cjk languages config
	install -D -m644 config/noto-sans-cjk-jp.reg "$(DESTDIR)"/sommelier/config/noto-sans-cjk-jp.reg
	install -D -m644 config/noto-sans-cjk-kr.reg "$(DESTDIR)"/sommelier/config/noto-sans-cjk-kr.reg
	install -D -m644 config/noto-sans-cjk-tc.reg "$(DESTDIR)"/sommelier/config/noto-sans-cjk-tc.reg
	install -D -m644 config/noto-sans-cjk-hk.reg "$(DESTDIR)"/sommelier/config/noto-sans-cjk-hk.reg
	install -D -m644 config/noto-sans-cjk-sc.reg "$(DESTDIR)"/sommelier/config/noto-sans-cjk-sc.reg

	# Themes
	install -D -m644 themes/light/light.msstyles "$(DESTDIR)"/sommelier/themes/light/light.msstyles
	install -D -m644 themes/light/light.reg "$(DESTDIR)"/sommelier/themes/light/light.reg

	# bindtextdomain patch
ifeq ($(HW_PLATFORM), x86_64)
	install -D -m644 $(ARCH_32)/$(BINDTEXTDOMAIN) "$(LIB_DIR)"/$(ARCH_32)/$(BINDTEXTDOMAIN)
endif
