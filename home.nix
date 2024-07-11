{ lib, config, pkgs, system, unstable, specialArgs, ... }:

let
  packages = import ./packages.nix;
  inherit (lib) mkIf;
  inherit (specialArgs) opts;
in
{


  home.username = "localadmin";
  home.homeDirectory = "/home/localadmin";

  # Tearing fix for i3
  services.picom.enable = opts.withGUI;

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  home.packages = packages {
    inherit pkgs unstable opts;
  };


  services.gnome-keyring.enable = opts.withVPN;

  fonts.fontconfig.enable = opts.withGUI;

  xsession = mkIf opts.withGUI {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = rec {
        modifier = "Mod1"; # Mod1 = Alt. Mod4 = super.
        terminal = "alacritty";
        keybindings =
          let
            screenshot_file = "/home/$USER/Pictures/screenshot_$(date +'%Y-%m-%d_%H:%M:%S').png";
          in
          lib.mkOptionDefault {
            "${modifier}+Tab" = "workspace next_on_output";
            "${modifier}+Ctrl+Shift+Right" = "move workspace to output right";
            "${modifier}+Ctrl+Shift+Left" = "move workspace to output left";
            "${modifier}+Ctrl+Shift+Up" = "move workspace to output up";
            "${modifier}+Ctrl+Shift+Down" = "move workspace to output down";
            "${modifier}+Ctrl+Shift+l" = "move workspace to output right";
            "${modifier}+Ctrl+Shift+h" = "move workspace to output left";
            "${modifier}+Ctrl+Shift+k" = "move workspace to output up";
            "${modifier}+Ctrl+Shift+j" = "move workspace to output down";
            "${modifier}+Shift+l" = "move right";
            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+l" = "focus right";
            "${modifier}+h" = "focus left";
            "${modifier}+k" = "focus up";
            "${modifier}+j" = "focus down";
            "${modifier}+d" = "exec rofi -show drun";
            "${modifier}+f" = "exec rofi -show ssh";
            # "Mod4+l" = "exec bash /home/localadmin/nixconfig/lockmore/i3lockmore --image-fill ${pkgs.nixos-artwork.wallpapers.mosaic-blue.gnomeFilePath}";
            "Mod4+l" = "exec dm-tool lock";
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
        startup = [
        {
          command =
            "${pkgs.feh}/bin/feh --bg-fill ${pkgs.nixos-artwork.wallpapers.mosaic-blue.gnomeFilePath}";
          always = true;
          notification = false;
        }
        ];
      };
    };
  };

  programs.i3status = {
    enable = true;
    modules = {
      "memory" = {
        settings = {
          format = "RAM %used of %available";
          separator_block_width = 10;
        };
      };
      "tztime local" = {
        settings = {
          format = "Week %V %Y-%m-%d %H:%M:%S";
        };
      };
    };
  };

  # dmenu replacement
  programs.rofi = mkIf opts.withGUI {
    enable = true;
    # theme = "android_notificaton";
    # font = "";
    theme = "${pkgs.rofi-unwrapped}/share/rofi/themes/sidebar.rasi";
    terminal = "alacritty";
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

  services.autorandr.enable = opts.withGUI;
  programs.autorandr = mkIf opts.withGUI {
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

  programs.feh = mkIf opts.withGUI {
    enable = true;
    keybindings = { }; # Kbd buttons
    buttons = { }; # Mouse buttons
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
      nixconfig = "git -C ~/nixconfig";
      # nvim = "nix run /home/localadmin/nvim-flake";
    };
    history.ignoreDups = true;
    syntaxHighlighting.enable = true;
  };

  programs.alacritty = mkIf opts.withGUI {
    enable = true;
    settings = {
      font = {
        size = opts.font_size or 13.0;
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

  # Enable dark mode for websites
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
