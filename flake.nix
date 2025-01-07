{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    # <-- this ensures inputs is passed to the function
    nixosConfigurations = {
      nixos = inputs.nixpkgs.lib.nixosSystem {
        # now inputs is properly passed
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          inputs.home-manager.nixosModules.default
          inputs.vscode-server.nixosModules.default
          inputs.nixos-wsl.nixosModules.default

          ({
            pkgs,
            lib,
            ... # ensure this part is properly scoped
          }: {
            nix.settings.experimental-features = ["nix-command" "flakes"];
            services.vscode-server.enable = true;

            environment.systemPackages = [
              pkgs.wget
              pkgs.tailscale
              pkgs.kubectl
              pkgs.nodePackages_latest.prisma
              pkgs.graphite-cli
            ];
            nixpkgs.config.allowUnfree = true;
            fonts.packages = with pkgs; [
              noto-fonts
              noto-fonts-cjk-sans
              noto-fonts-emoji
              liberation_ttf
              fira-code
              fira-code-symbols
              mplus-outline-fonts.githubRelease
              dina-font
              proggyfonts
            ];

            # Prisma:
            environment.variables = {
              PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
              PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
              PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
              PRISMA_TMP_DIR = "/tmp/prisma"; # Ensure this directory is writable
            };
            home-manager = import ./home.nix {inherit pkgs;};
            networking.hostName = "nixos";
            system.stateVersion = "24.11";
            programs.zsh.enable = true;
            programs.nix-ld.enable = true;

            users = {
              users.teak = {
                shell = pkgs.zsh;
                isNormalUser = true;
                extraGroups = ["wheel" "docker"];
              };
            };
            virtualisation.docker = {
              enable = true;
              enableOnBoot = true;
              autoPrune.enable = true;
            };

            services.tailscale.enable = true;
            systemd.user = {
              paths.vscode-remote-workaround = {
                wantedBy = ["default.target"];
                pathConfig.PathChanged = "%h/.vscode-server/bin";
              };
              services.vscode-remote-workaround.script = ''
                for i in ~/.vscode-server/bin/*; do
                  if [ -e $i/node ]; then
                    echo "Fixing vscode-server in $i..."
                    ln -sf ${pkgs.nodejs_18}/bin/node $i/node
                  fi
                done
              '';
            };
            wsl = {
              enable = true;
              defaultUser = "teak";
              wslConf.automount.root = "/mnt";
              wslConf.interop.appendWindowsPath = false;
              wslConf.network.generateHosts = false;

              startMenuLaunchers = true;

              docker-desktop.enable = false;
              wslConf.user.default = "teak";
              extraBin = with pkgs; [
                # Binaries for Docker Desktop wsl-distro-proxy
                {src = "${coreutils}/bin/mkdir";}
                {src = "${coreutils}/bin/cat";}
                {src = "${coreutils}/bin/whoami";}
                {src = "${coreutils}/bin/ls";}
                {src = "${busybox}/bin/addgroup";}
                {src = "${su}/bin/groupadd";}
                {src = "${su}/bin/usermod";}
              ];
            };
          })
        ];
      };
    };
  };
}
