{ lib, config, pkgs, system, pkgs-unstable, ... }:

{
    home.username = "localadmin";
    home.homeDirectory = "/home/localadmin";

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
      pciutils
      ffmpeg
      lshw
      zip unzip

      # Screenshotting
      maim 
      xdotool

      # Monitoring
      htop
      nload

      # Audio
      pavucontrol

      # Fonts
      # powerline-fonts
      zsh-powerlevel10k
      meslo-lgs-nf

      # Terminals
      alacritty

      # Medial player
      vlc

      # Browser
      thorium
      spotify
      zathura #PDF

      # Communication
      teams-for-linux
      whatsapp-for-linux
      discord

      matlab

      gcc13 # Good to have a C compiler, for example for installing neovim plugins

      # For Neovim
      tree-sitter # for nvim (specifically for the latex language)
      ripgrep # Required for nvim telescope
      cargo # For building various packages

    ] ++ (with pkgs-unstable; [
    ]);

    fonts.fontconfig.enable = true;

    xsession.enable = true;
    xsession.windowManager.i3 = {
        enable = true;
        config =
          rec {
            modifier = "Mod1"; # Mod1 = Alt. Mod4 = super.
            terminal = "alacritty";
            keybindings = let 
              screenshot_file = "/home/$USER/Pictures/screenshot_$(date +'%Y-%m-%d_%H:%M:%S').png";
            in lib.mkOptionDefault {
                "${modifier}+Tab" = "workspace next_on_output";
                "${modifier}+Ctrl+Shift+Right"  = "move workspace to output right";
                "${modifier}+Ctrl+Shift+Left"   = "move workspace to output left";
                "${modifier}+Ctrl+Shift+Up"     = "move workspace to output up";
                "${modifier}+Ctrl+Shift+Down"   = "move workspace to output down";
                "${modifier}+Ctrl+Shift+l"      = "move workspace to output right";
                "${modifier}+Ctrl+Shift+h"      = "move workspace to output left";
                "${modifier}+Ctrl+Shift+k"      = "move workspace to output up";
                "${modifier}+Ctrl+Shift+j"      = "move workspace to output down";
                "${modifier}+Shift+l"           = "move right";
                "${modifier}+Shift+h"           = "move left";
                "${modifier}+Shift+k"           = "move up";
                "${modifier}+Shift+j"           = "move down";
                "${modifier}+l"           = "focus right";
                "${modifier}+h"           = "focus left";
                "${modifier}+k"           = "focus up";
                "${modifier}+j"           = "focus down";
                "Mod4+l" = "exec i3lock --color=000000 -i ${pkgs.nixos-artwork.wallpapers.mosaic-blue.gnomeFilePath}";
                "Ctrl+Shift+Print" = "exec --no-startup-id maim --select | xclip -selection clipboard -t image/png";
                "Shift+Print" = "exec --no-startup-id maim --select \"${screenshot_file}\"";
                "Ctrl+Print" = "exec --no-startup-id maim | xclip -selection clipboard -t image/png";
                "Print" = "exec --no-startup-id maim --window $(xdotool getactivewindow) \"${screenshot_file}\"";
            };
            focus.followMouse = false;
            fonts = { size = 13.0; };
            bars = [
                {
                    statusCommand = "${pkgs.i3status}/bin/i3status";
                    command = "i3bar";
                    position = "top";
                    fonts = {
                      size = 13.0;
                    };
                }
            ];
          floating = {
            criteria = [
              { class = "Matplotlib"; }
              { class = "Pavucontrol"; }
              { class = "feh"; }
            ];
          };
        };
    };


## NOTE: Currently we should use xrandr to setup any display configurations. 
## Example for the dock configuration at work:
#> xrandr --output eDP1 --mode 1920x1080 --rate 60.00 --pos 0x860 --output DP2-3 --mode 2560x1440 --rate 59.95 --pos 1920x0 --primary
##
## Autorandr can be used to save the configurations for easier use later on.
#> autorandr --save NAME
#
## To load a profile
#> autorandr NAME
##
## TODO: Changes in hardware should be detected automatically and the correct profile chosen.
## Optimally the correct profile could also be created automatically

    services.autorandr.enable = true;
    programs.autorandr = {
        enable = true;
    };

    programs.tmux = {
      enable = true;
      mouse = true;
      escapeTime = 20;
      tmuxinator.enable = true;
      keyMode = "vi";
      extraConfig = "
        set-option -g detach-on-destroy off
        set-option -g status-bg green
        set-option -g status-fg black

        bind-key -r k select-pane -U
        bind-key -r j select-pane -D
        bind-key -r h select-pane -L
        bind-key -r l select-pane -R

        bind-key C-h previous-window
        bind-key C-l next-window

        bind-key p last-window
      ";
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
      viAlias = false;
      vimAlias = true;
      withPython3 = true;
      withNodeJs = true;
    };

    programs.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        # theme = "dst";
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      initExtra = ''
        setopt BASH_AUTO_LIST NO_MENU_COMPLETE NO_AUTO_MENU
        source ~/nixconfig/config/.p10k.zsh
      '';
        # source ${./config/.p10k.zsh}
      shellAliases = {
        ll = "ls -la";
        dev = "nix develop -c zsh";
        sourcezsh = "source ~/.zshrc";
        nixconfig="git -C ~/nixconfig";
      };
      history.ignoreDups = true;
      syntaxHighlighting.enable = true;
    };

    programs.alacritty = {
        enable = true;
        settings = {
            font = {
                size = 12.0;
                normal = {
                    family = "MesloLGS NF";
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
