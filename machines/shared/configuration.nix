{ pkgs, pkgs-unstable, home-manager, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

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
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true; # full configuration in home manager

    # # Fonts for powerline
    # fonts.packages = with pkgs; [
    #   powerline-fonts
    # ];

  environment.systemPackages = with pkgs; [
  ] ++ (with pkgs-unstable; [
  ]);

  # users.defaultUserShell = pkgs.zsh;

}
