# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unstable, home-manager, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared/configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "WKS-95141-NLT"; # Define your hostname.

  networking.firewall.allowedUDPPorts = [ 10000 10001 ];
  networking.firewall.allowedTCPPorts = [ 8080 50000 50001 ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.localadmin = {
    isNormalUser = true;
    description = "Olli Koskelainen";
    extraGroups = [ "wheel" "storage" "audio" "networkmanager" ];
  };

  nix.settings.substituters = [ "ssh-ng://localadmin@130.230.29.24" ];
  nix.settings.trusted-public-keys = [ "teho-builder:3HITvp6JLhhLndHQdzIxUpoy5iAZZomIVCYcIx1AgmA=" ];
  # Uncomment this if distributed builds stop working
  # nix.settings.secret-key-files = "/home/localadmin/.ssh/cache-priv-key.pem";


  # Distributed builds. Remember to setup cache keys for substituting!
  # https://nixos.wiki/wiki/Distributed_build
  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "130.230.29.24";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      sshUser = "localadmin";
      maxJobs = 6;
      speedFactor = 100;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }
  ];
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
  # Used to disable local building for testing remote settings
  # nix.settings.max-jobs = 0; 


  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.nvidia = {
    # modesetting.enable = true;
    # powerManagement.enable = false;
    # powerManagement.finegrained = false;
    # open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      # sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:60:0:0";
    };

  };
  services.xserver.videoDrivers = [ "intel" "nvidia" ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
