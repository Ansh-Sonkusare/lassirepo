{pkgs, ...}: {
  useGlobalPkgs = true;
  useUserPackages = true;
  users.teak = {
    home = {
      username = "teak";
      homeDirectory = "/home/teak";
      stateVersion = "24.11";
      sessionPath = [ "$HOME/.local/bin" ];
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
        home-manager
        unrar
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
      plugins = with pkgs.tmuxPlugins; [ catppuccin ];
      baseIndex = 1;
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
      };
     sessionVariables = {
     NVIM_APPNAME="nvim-chad"; 

     };
      
    };

    fonts.fontconfig.enable = true;
    programs.home-manager.enable = true;
    services.ssh-agent.enable = true;
  };
}
