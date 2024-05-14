{ pkgs, pkgs-unstable, home-manager, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        defaultSession = "none+i3";
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
          i3blocks
        ];
      };

      libinput.touchpad.tapping = false;

      # Configure keymap for console
      autoRepeatInterval = 30;
      autoRepeatDelay = 200;
      xkb = {
        layout = "us";
        variant = "altgr-intl";
        options = "caps:swapescape";
      };
  };

  console.useXkbConfig = true;

    # # Fonts for powerline
    # fonts.packages = with pkgs; [
    #   powerline-fonts
    # ];

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  environment.systemPackages = with pkgs; [
  ] ++ (with pkgs-unstable; [
  ]);

  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
  };
  users.defaultUserShell = pkgs.zsh;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
