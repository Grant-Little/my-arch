# My Arch
A small Arch installation bash script I made so I wouldn't have to remember the same packages and basic /etc files I edit when I install. Also includes a separate script to setup my [dotfiles](https://github.com/Grant-Little/dotfiles).

## What's Installed
- everything I use for my day-to-day life in Qtile, split into:
  - Basic Packages
  - Xorg Driver (manually specified)
  - Vulkan Driver (optional)
  - Desktop
  - Fonts
  - Development
  - Misc (read: emulators)
- lightdm, networkmanager, and paccache are enabled via systemd (sorry Artix)
- adds user to disk, optical, storage, uucp, and video groups
- the wallpapers I shamelessly ripped from wallhaven
- lightdm and slick-greeter config
- enables natural scrolling on trackpads and removes mouse acceleration on other input devices
- seperate script to grab my dotfiles

## Installation
- boot into [arch-iso](https://archlinux.org/download/) live environment
- [connect](https://wiki.archlinux.org/title/Iwd) to the internet
- `archinstall`
- minimal configuration, create user in wheel group
- reboot into new user
- `sudo pacman -Syu git`
- `git clone https://github.com/Grant-Little/my-arch.git`
- `cd my-arch`
- determine xorg and (optional) vulkan [drivers](https://wiki.archlinux.org/title/Xorg#Driver_installation)
- `sudo bash my-arch.sh -X {replace-with-xorg-driver} -V {replace-with-optional-vulkan-driver}`
  - if internet connection is poor, pacman will probably fail on a download, re-run the script or update your [mirrors](https://wiki.archlinux.org/title/Mirrors)
- `bash my-dotfiles.sh`
