# Sommelier Core Scripts

This repository contains the `sommelier` script which helps you put a Windows application in a snap. This is a wrapper script which runs when your snap starts. It initializes and tweaks Wine, installs your application and runs it.

> Note: many Wine snaps were originally built by copying the `sommelier` script and modifying it. This made it hard to maintain and update that script. The goal of this repository is to create a single version of the `sommelier` script which can be used by every snapped Wine application without modification. Is this script not working for your application? Please let me know! Contributions are welcome!

Pros:

* Uses Wine from the wine-platform snaps to reduce the size of your snap.
* Uses the `gnome-3-28` extension for initializing all the generic desktop stuff.
* Includes the "Modern" theme from [ReactOS](https://reactos.org/) so Windows applications look less ugly.
* Updates the Wine prefix every time Wine changes. Can upgrade a 32-bit Wine prefix to 64-bit.
* Reinstalls the Windows app every time the snap `version` changes.
* Reconfigures Wine every time the snap `revision` or the Wine version changes.  
* Users can run `myapp.wine` to run arbitrary applications inside this snap.
* Users can run `myapp.winetricks` to modify the Wine environment.

Cons:

* This script currently only runs on amd64 machines. Most distributions have dropped support for 32-bit installations, and Wine isn't very useful on ARM.

## How to use

See the following snaps for complete examples of how to use sommelier-core.

* [PhotoScape snap](https://github.com/snapcrafters/photoscape)
* [Bridge Designer snap](https://github.com/snapcrafters/bridge-designer)
* [TrackMania Nations Forever snap](https://github.com/galgalesh/tmnationsforever)

### General use

* `TRICKS`: A space-separated list of [winetricks](https://wiki.winehq.org/Winetricks) to run before installing the application. For example, the trick `dxvk` installs and configures the Vulkan-based translation layer for Direct3D 9/10/11. If you're not sure which tricks your application needs, take a look at the test results on [Wine AppDB](https://appdb.winehq.org/) or the [Lutris](https://lutris.net/games) install scripts. Those often mention the required tricks.
  
  > Note: You can experiment with different tricks yourself by building and installing your snap, and then running `myapp.winetricks` to install additional tricks. After that, run `myapp` again and see if everything works.

   Run `myapp.winetricks list-all` to see all available tricks. [Wine errors](https://wiki.winehq.org/Debug_Channels) can help you figure out which tricks are needed. Run `export WINEDEBUG=err+all` before running your snap to see them.
* `INSTALL_URL`: URL to publicly available installer. Sommelier will download this installer and execute it in Wine.
  
  > Note: if the installer is not publicly downloadable, you can alternatively include the installer in the snap and use the `INSTALL_EXE` environment variable to specify the absolute path to the installation exe. Using `INSTALL_URL` is preferred, however, because many installers have licenses that prevent third-party distribution. Example: `INSTALL_PATH: "$SNAP/PhotoScapeSetup_V3.7.exe"`
* `INSTALL_FLAGS`: Windows-style CLI flags to pass to the installer. Many installers have CLI flags for silent installation, for example.

  > Note: Running [Universal Silent Switch Finder](https://www.softpedia.com/get/System/Launchers-Shutdown-Tools/Universal-Silent-Switch-Finder.shtml) on a Windows machine can help you find these flags. This app does not seem to function correctly in Wine.
* `RUN_EXE`: Path to the installed Windows application to run. This accepts both unix paths and Windows paths such as `"C:/Program Files (x86)/TmNationsForever/TmForever.exe"`
* `WINEDLLOVERRIDES`: Override DLL loading behavior: configure Wine to choose between native and builtin DLLs. See [DLL Overrides](https://wiki.winehq.org/Wine_User%27s_Guide#DLL_Overrides) and [WINEDLLOVERRIDES](https://wiki.winehq.org/Wine_User%27s_Guide#WINEDLLOVERRIDES.3DDLL_Overrides) docs for more information. Example: `"mscoree,mshtml="`
* `WINEESYNC`: set to `1` to enable esync. This can increase performance for some games, especially ones that rely heavily on the CPU. See [esync docs](https://github.com/zfigura/wine/blob/esync/README.esync) for more information.
* `WINEARCH`: Wine will start an 64-bit environment by default. This runs both 32-bit and 64-bit Windows binaries. Some 32-bit applications, however, have issues when you run them in 64-bit Wine. For these applications, set `WINEARCH` to `win32` to use a 32-bit-only environment.
* `SOMMELIER_NO_THEME`: Use this variable to disable the ReactOS Modern theme. Some Java 1.6 applications crash when you apply a theme.
* `SOMMELIER_KEEP_CWD`: Use this variable when sommelier should not change the working directory before executing the app. This is useful if your app can take filenames as arguments and you want relative filenames to work. Note: some Windows apps only work when the working directory is their application directory.

## Compatibility

This repository uses branches for stable and backwards-compatible releases. For example, all updates to the "1.0" branch of this repository will be backwards compatible. Set the `source-branch` propertie of the `sommelier` part in your `snapcraft.yaml` file to use a stable version.

```yaml
parts:
  sommelier:
    plugin: make
    source: https://github.com/snapcrafters/sommelier-core.git
    source-branch: "1.0"
```

### Development and debugging

* `SOMMELIER_DEBUG`: Enable bash tracing for the sommelier script and time how long sommelier runs before starting the application.
* `SOMMELIER_STRICT`: Make sommelier exit when an unset variable is used. This might be useful to find bugs in sommelier.

## License

* The ReactOS Modern theme is released under the GNU General Public License v3.0 with the [ReactOS License Binary Linking Exception](https://reactos.org/intellectual-property-guideline/).
* All other content is released under the MIT license.
