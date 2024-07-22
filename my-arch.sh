#!/usr/bin/bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "run as root"
  exit 1
fi

# receive xorg and vulkan driver from user
while getopts "X:V:" flag
do
  case "${flag}" in
    X) XORG_DRIVER=${OPTARG};;
    V) VULKAN_DRIVER=${OPTARG};;
  esac
done

# was an xorg driver given?
# if not, exit with failure
[ -z ${XORG_DRIVER+x} ] && echo "no xorg driver given, please specify xorg driver using -X flag (see pacman -Ss xf86-video)" && exit 1

# check if given xorg driver is valid
if [[ $XORG_DRIVER = "xf86-video-amdgpu" || \
  $XORG_DRIVER = "xf86-video-ati" || \
  $XORG_DRIVER = "xf86-video-dummy" || \
  $XORG_DRIVER = "xf86-video-fbdev" || \
  $XORG_DRIVER = "xf86-video-intel" || \
  $XORG_DRIVER = "xf86-video-nouveau" || \
  $XORG_DRIVER = "xf86-video-qxl" || \
  $XORG_DRIVER = "xf86-video-sisusb" || \
  $XORG_DRIVER = "xf86-video-vesa" || \
  $XORG_DRIVER = "xf86-video-vmware" || \
  $XORG_DRIVER = "xf86-video-voodoo" ]]; then
  echo "installing xorg driver $XORG_DRIVER"
else
  echo "non-valid xorg driver given, please specify xorg driver using -X flag (see pacman -Ss xf86-video)"; exit 1
fi

# check if given vulkan driver is valid
# since vulkan is not necessary for the desktop
# we can continue with no vulkan driver specified
if [[ $VULKAN_DRIVER = "vulkan-radeon" || \
  $VULKAN_DRIVER = "amdvlk" || \
  $VULKAN_DRIVER = "vulkan-intel" || \
  $VULKAN_DRIVER = "vulkan-nouveau" || \
  $VULKAN_DRIVER = "nvidia-utils" || \
  -z ${VULKAN_DRIVER+x} ]]; then
  echo "installing vulkan driver $VULKAN_DRIVER"
else
  echo "non-valid vulkan driver, proceed without vulkan driver or specify correct driver using -V flag"; exit 1
fi

# set packages
BASIC_PACKAGES="arch-wiki-docs reflector pacman-contrib p7zip unzip unrar vim helix htop vifm fzf lynx networkmanager numlockx wget yt-dlp"

DESKTOP="mesa xorg lightdm lightdm-slick-greeter pipewire pipewire-alsa pipewire-jack pipewire-pulse qtile alsa-utils brightnessctl alacritty thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman xarchiver ristretto vlc brasero firefox qbittorrent obs-studio mousepad gnome-multi-writer shutter xreader libreoffice-still hunspell-en_us hyphen-en lxappearance network-manager-applet nitrogen rofi picom pavucontrol breeze-gtk breeze-icons"

FONTS="noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-liberation ttf-nerd-fonts-symbols"

DEVELOPMENT="clang zig zls go gopls raylib godot tiled glfw python-lsp-server python-numpy python-matplotlib python-sympy python-scipy python-scikit-learn"

MISC="mgba-qt snes9x-gtk"

TO_INSTALL=$BASIC_PACKAGES
TO_INSTALL+=" "
TO_INSTALL+=$XORG_DRIVER
if [[ -z ${VULKAN_DRIVER+x} ]]; then
  echo "skipping vulkan driver"
else
  TO_INSTALL+=" "
  TO_INSTALL+=$VULKAN_DRIVER
fi
TO_INSTALL+=" "
TO_INSTALL+=$DESKTOP
TO_INSTALL+=" "
TO_INSTALL+=$FONTS
TO_INSTALL+=" "
TO_INSTALL+=$DEVELOPMENT
TO_INSTALL+=" "
TO_INSTALL+=$MISC

# install packages
pacman -S $TO_INSTALL

# enable services
systemctl enable lightdm.service
systemctl enable NetworkManager.service
systemctl enable paccache.timer

if [ -d /usr/share/backgrounds ]; then
  echo "backgrounds directory exists"
else
  echo "creating backgrounds directory"
  mkdir /usr/share/backgrounds
fi

mv backgrounds/* /usr/share/backgrounds/
mv -f lightdm/* /etc/lightdm/
mv input/* /etc/X11/xorg.conf.d/

exit 0
