{ pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.atd.enable = true;
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

  services.displayManager.defaultSession = "none+i3";
  services.libinput.touchpad = {
    tapping = false; 
    naturalScrolling = true;
  };

  services.xserver = {
    enable = true;

    windowManager.i3 = {
      enable = true;
    };

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

  hardware.enableAllFirmware = true;

  # For automounting?
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      # Disable password login for safety
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Natural scrolling should be on for touchpad devices

}
