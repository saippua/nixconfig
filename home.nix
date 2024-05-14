{ lib, config, pkgs, pkgs-unstable, ... }:

{
    home.username = "localadmin";
    home.homeDirectory = "/home/localadmin";

    # home.packages = with pkgs; [
    #     alacritty
    #     just
    #     thorium
    # ];

    # programs.i3lock = {
    #     enable = true;
    #     settings = {
    #         color = "000000"; 
    #         font-size = 24; 
    #         indicator-idle-visible = false; 
    #         indicator-radius = 100; 
    #         show-failed-attempts = true;
    #     };
    # };

    # Tearing fix for i3
    services.picom.enable = true;

    home.packages = with pkgs;
    [
      # Utilities
      xclip
      just
      stow
      ripgrep
      pciutils
      ffmpeg

      # Fonts
      powerline-fonts

      # Terminals
      alacritty

      # Medial player
      vlc

      # Browser
      thorium

      # Communication
      discord

      # Compilers
      llvmPackages_17.libcxxClang
      nodejs
      # gcc13
      # nodejs
    ] ++ (with pkgs-unstable; [
      arduino-ide
    ]);

    fonts.fontconfig.enable = true;

    xsession.enable = true;
    xsession.windowManager.i3 = {
        enable = true;
        config = rec {
            modifier = "Mod1"; # Mod1 = Alt. Mod4 = super.
            terminal = "alacritty";
            keybindings = lib.mkOptionDefault {
                "${modifier}+tab" = "workspace next_on_output";
                "Mod4+l" = "exec i3lock --color=000000";
            };
            bars = [
                {
                    "statusCommand" = "${pkgs.i3status}/bin/i3status";
                    "command" = "i3bar";
                    "position" = "top";
                }
            ];
        };
        extraConfig = "for_window [class=\"Matplotlib\"] floating enable, resize set 900px 600px, move position center, border normal";
    };

    programs.git = {
      enable = true;
      userName = "Saippua";
      userEmail = "ollikos92@gmail.com";
      lfs.enable = true;
    };


    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
}
