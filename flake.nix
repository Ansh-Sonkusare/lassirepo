{

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";

  };

  outputs = inputs: {


    nixosConfigurations = {
      main = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.home-manager.nixosModules.default
          inputs.vscode-server.nixosModules.default
          inputs.nixos-wsl.nixosModules.default
          ({ pkgs, ... }: {
            environment.systemPackages = [ pkgs.wget ];

            nixpkgs.config.allowUnfree = true;

            fonts.packages = with pkgs; [
              noto-fonts
              noto-fonts-cjk
              noto-fonts-emoji
              liberation_ttf
              fira-code
              fira-code-symbols
              mplus-outline-fonts.githubRelease
              dina-font
              proggyfonts
            ];
            home-manager = import ./home.nix { inherit pkgs; };
            networking.hostName = "nixos";
            system.stateVersion = "23.11";
            programs.zsh.enable = true;

            users = {
              users.teak = {
                shell = pkgs.zsh;
                isNormalUser = true;
                extraGroups = [ "wheel" "docker" ];
              };
            };
            virtualisation.docker = {
              enable = true;
              enableOnBoot = true;
              autoPrune.enable = true;
            };

            services.vscode-server.enable = true;
            wsl = {
              enable = true;
              defaultUser = "teak";
              docker-desktop.enable = true;
              wslConf.user.default = "teak";
            };
          })
        ];
      };
    };

  };

}
