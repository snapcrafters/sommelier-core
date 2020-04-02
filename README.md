# Sommelier Core Scripts

> WARNING: sommelier-core is not stable at the moment, it might break backwards compatibility. Use at your own risk!

This repository contains scripts to help you put a Windows application in a snap. The goal is to create a single `sommelier` script which can be used by every snapped Wine application. Is this script not working for your application? Please let me know! Contributions are welcome!

Features:

* Uses Wine from the wine-platform snaps.
* Uses the `gnome-3-28` extension for all the generic desktop stuff.
* Includes the "Modern" theme from ReactOS.
* Supports Chinese locales.
* Supports running arbitrary applications inside the snap environment using the `myapp.wine64` command.
* Reinstalls the Windows app every time the snap `version` changes.
* Updates the wine prefix every time wine changes.
* Re-runs initialization logic every time the snap `revision` changes.  

Notes:

* This script only runs on amd64 machines. Most distributions have dropped support for 32-bit installations, and Wine isn't very useful on ARM.

## How to use

See the [Photoscape Snap](https://github.com/snapcrafters/photoscape) for a complete example of a snap using sommelier-core.

Environment variables are used to configure sommelier.

```yaml
environment:
  INSTALL_EXE: "$SNAP/PhotoScapeSetup_V3.7.exe"
  INSTALL_FLAGS: "/S"
  DLLOVERRIDES: "mscoree,mshtml="         # Prevent pop-ups about Wine Mono and Wine Gecko
  SNAP_TITLE: "$SNAPCRAFT_PROJECT_SUMMARY"
  SNAP_ICON: "$SNAP/meta/gui/icon.png"
  SNAP_SUPPORT_URL: "https://github.com/snapcrafters/photoscape/issues"
  STRICT_SOMMELIER: "1"  # Make Sommelier exit when unset variable is used. (useful to find bugs)
```

The `run-exe` command tells sommelier to run the exe from the `RUN_EXE` environment variable. It's also useful to include the `wine64` and the `winetricks` commands so users you can run winecfg and winetricks to change wine.

```yaml
apps:
  photoscape:
    extensions: [ gnome-3-28 ]
    command: bin/sommelier run-exe
    environment:
      RUN_EXE: "/Program Files (x86)/PhotoScape/PhotoScape.exe"
    plugs:
      - home
      - network
      - network-bind
  # The wine64 command can be used to run applications inside the wine
  # environment that this snap uses.
  #
  # For example, users can configure the wine environment of this snap
  # by running `myapp.wine64 winecfg`.
  wine64:
    extensions: [ gnome-3-28 ]
    command: bin/sommelier
    plugs:
      - home
      - network
  # The winetricks command can be used to run winetricks inside the wine
  # environment that this snap uses.
  winetricks:
    extensions: [ gnome-3-28 ]
    command: bin/sommelier winetricks
    plugs:
      - network
```

Add the `sommelier` part to pull in the sommelier script.

```yaml
parts:
  # The sommelier script helps you snap Windows applications using Wine. It 
  # initialises and configures Wine and installs the Windows application.
  #
  # This part is copied straight from the sommelier-core repository. Please
  # periodically check the source for updates and copy the changes.
  #    https://github.com/snapcrafters/sommelier-core
  #
  sommelier:
    plugin: make
    source: https://github.com/snapcrafters/sommelier-core.git
```

Add the plugs to connect to the wine runtime snaps.

```yaml
# These plugs are used to connect the snap to the wine runtime.
#
# These plugs are copied straight from the sommelier-core repository. Please
# periodically check the source for updates and copy the changes.
#    https://github.com/snapcrafters/sommelier-core
#
plugs:
  wine-runtime:
    interface: content
    target: $SNAP/wine-runtime
    default-provider: wine-platform-runtime
  wine-4-stable:
    interface: content
    target: $SNAP/wine-platform
    default-provider: wine-platform-4-stable
```
