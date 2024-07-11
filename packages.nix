{ pkgs, unstable, opts }:
with pkgs; [
  xclip
  just
  stow
  pciutils
  ffmpeg
  lshw
  zip unzip
  ripgrep

  imagemagick
  at
  taskspooler

  # Monitoring
  htop
  nload


] ++ pkgs.lib.optionals opts.withGUI [
  # For screenshotting
  maim
  xdotool

  pavucontrol

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
] ++ pkgs.lib.optionals opts.withMatlab [
  matlab
] ++ pkgs.lib.optionals opts.withVPN [
  unstable.eduvpn-client
]
