# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared/configuration.nix
      # <home-manager/nixos>
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  virtualisation = {
    libvirtd.enable = true;
    virtualbox.host.enable = true;
    virtualbox.guest.enable = true;
  };

  networking.hostName = "ollenovo"; # Define your hostname.

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "xfce4-session";
  # services.xrdp.openFirewall = true;

  # Sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.localadmin = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$vxTZItHj7fGHKhFgt.Ebw.$8CTxdlHFhoPd08VTiGxQ99GtPhGIxtvpcTHQ49epIgC";
    extraGroups = [ "wheel" "storage" "audio" "dialout" "libvirtd" "qemu-libvirtd" ]; # Enable ‘sudo’ for the user.
  };
  users.extraGroups.vboxusers.members = [ "localadmin" ];

  services.udev.extraRules = ''
    KERNEL=="ttyUSB0", MODE:="774"
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

