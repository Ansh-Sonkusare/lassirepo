{pkgs, ...}: let
  plug = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-sessionx";
    version = "unstable-2024-05-15";
    src = pkgs.fetchFromGitHub {
      owner = "omerxx";
      repo = "tmux-sessionx";
      rev = "4f58ca79b1c6292c20182ab2fce2b1f2cb39fb9b";
      hash = "sha256-/fmcgFxu2ndJXYNJ3803arcecinYIajPI+1cTcuFVo0=";
    };
    postInstall = ''
      echo "teak" '';
  };

  catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "unstable-2024-05-15";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "697087f593dae0163e01becf483b192894e69e33";
      hash = "sha256-EHinWa6Zbpumu+ciwcMo6JIIvYFfWWEKH1lwfyZUNTo=";
    };
    postInstall = ''
      sed -i -e 's|''${PLUGIN_DIR}/catppuccin-selected-theme.tmuxtheme|''${TMUX_TMPDIR}/catppuccin-selected-theme.tmuxtheme|g' $target/catppuccin.tmux
    '';
  };
in {
  useGlobalPkgs = true;
  useUserPackages = true;
  users.teak = {
    home = {
      username = "teak";
      homeDirectory = "/home/teak";
      stateVersion = "24.11";
      sessionPath = ["$HOME/.local/bin"];
      packages = with pkgs; [
        gnumake
        wget
        coreutils
        git
        openssl
        gcc
        gh
        lua
        alejandra
        nil
        nerdfonts
        unrar
        fzf
        bat
        ripgrep
        fira-code
        fira-code-symbols
      ];
    };
    programs.git = {
      enable = true;
      userName = "Ansh-Sonkusare";
      userEmail = "sonkusare.satish12@gmail.com";
      aliases = {
        ci = "commit";
        co = "checkout";
        s = "status";
      };
    };
    programs.tmux = {
      enable = true;
      plugins = [plug catppuccin];
      baseIndex = 1;
      extraConfig = ''
        set -g @sessionx-bind 'o'

      '';
      # keyMode = "vi";
    };
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;

        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };

        package.disabled = true;
      };
    };
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.direnv.enable = true;
    programs.zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      defaultKeymap = "emacs";
      history.size = 10000;
      history.save = 10000;
      history.expireDuplicatesFirst = true;
      history.ignoreDups = true;
      history.ignoreSpace = true;
      historySubstringSearch.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = ["git"];
        theme = "bira";
      };
      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }
      ];
      shellAliases = {
        cd = "z";
        code = "/mnt/c/Users/sonku/AppData/Local/Programs/'Microsoft VS Code'/bin/code";
      };
      sessionVariables = {
        NVIM_APPNAME = "nvim-chad";
      };
    };

    fonts.fontconfig.enable = true;
    programs.home-manager.enable = true;
    services.ssh-agent.enable = true;
  };
}
