{ pkgs, unstable, opts }:
with pkgs; [
  xclip
  just
  stow
  pciutils
  ffmpeg
  lshw
  zip unzip
  ripgrep fd

  imagemagick
  at
  taskspooler
  vlc

  # Monitoring
  htop
  nload
  
  unstable.saippua-neovim


] ++ pkgs.lib.optionals opts.withGUI [
  # For screenshotting
  maim
  xdotool

  pavucontrol
  sxiv

  # Fonts
  # powerline-fonts
  zsh-powerlevel10k
  meslo-lgs-nf

  # Terminals
  alacritty

  # Browser
  thorium
  spotify
  zathura #PDF

  # Communication
  teams-for-linux
  whatsapp-for-linux
  discord
  slack
] ++ pkgs.lib.optionals opts.withMatlab [
  matlab
] ++ pkgs.lib.optionals opts.withVPN [
  unstable.eduvpn-client
]
