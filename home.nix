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

    nixpkgs.config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
    };

    home.packages = with pkgs;
    [
      # Utilities
      xclip
      just
      stow
      ripgrep # Required for nvim telescope
      pciutils
      ffmpeg
      lshw

      # Fonts
      powerline-fonts

      # Terminals
      alacritty

      # Medial player
      vlc

      # Browser
      thorium

      # Communication
      teams-for-linux
      discord

      # Compilers
      nodejs # Required for nvim
      gcc13
      # nodejs
    ] ++ (with pkgs-unstable; [
    ]);

    fonts.fontconfig.enable = true;

    xsession.enable = true;
    xsession.windowManager.i3 = {
        enable = true;
        config = rec {
            modifier = "Mod1"; # Mod1 = Alt. Mod4 = super.
            terminal = "alacritty";
            keybindings = lib.mkOptionDefault {
                "${modifier}+Tab" = "workspace next_on_output";
                "${modifier}+Ctrl+greater" = "move workspace to output right";
                "${modifier}+Ctrl+less" = "move workspace to output left";
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

    services.autorandr.enable = true;
    programs.autorandr = {
        enable = true;
        # profiles = {
        #     "docked" = {
        #         # fingerprint = {
        #         #     eDP1 = "";
        #         #     DP2-3 = "";
        #         # };
        #         config = {
        #             eDP1 = {
        #                 enable = true;
        #                 position = "0x860";
        #                 mode = "1920x1080";
        #                 rate = "60.00";
        #             };
        #             DP2-3 = {
        #                 enable = true;
        #                 position = "1920x0";
        #                 mode = "2560x1440";
        #                 rate = "59.95";
        #             };
        #         };
        #     };
        # };
    };

    programs.git = {
      enable = true;
      userName = "Saippua";
      userEmail = "ollikos92@gmail.com";
      lfs.enable = true;
    };

    programs.feh = {
        enable = true;
        keybindings = {}; # Kbd buttons
        buttons = {}; # Mouse buttons
    };

    programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        withPython3 = true;
        withNodeJs = true;
    };

    programs.zsh = {
        enable = true;
        oh-my-zsh = {
            enable = true;
            theme = "dst";
        };
        initExtra = "setopt BASH_AUTO_LIST NO_MENU_COMPLETE NO_AUTO_MENU";
        shellAliases = {
            sourcezsh = "source ~/.zshrc";
            nixconfig="git -C ~/nixconfig";
            };
        history = { ignoreDups = true; };
        syntaxHighlighting.enable = true;
    };

    programs.alacritty = {
        enable = true;
        settings = {
            font = {
                size = 12.0;
                normal = {
                    family = "Meslo LG S DZ for Powerline";
                    style = "Regular";
                };
            };
            keyboard.bindings = [
                # {
                #     key = "Tab";
                #     mods = "Control";
                #     chars = "\u001B[1;5I"
                # }
                # {
                #     key = "Tab";
                #     mods = "Control|Shift";
                #     chars = "\u001B[1;6I";
                # }
            ];
        };
    };

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
}
