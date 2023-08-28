# Codam_apt
Replacement for `apt` for use at Codam Linux stations. Might be compatible with other 42 Network Linux systems as well.

How to install `capt`\
Download & run `installer.sh`: `wget https://raw.githubusercontent.com/PanoramixDeDruide/Codam_apt/main/INSTALL.sh && chmod +x INSTALL.sh && ./INSTALL.sh`

How to check if the `apt` package of your choice is available\
-Run `apt-cache search <package-name>`

How to install a package\
-Run `capt install <package-name>`

Mind that many packages expect their data to be present in the `/usr` filesystem, which is not where `capt` puts your files.
