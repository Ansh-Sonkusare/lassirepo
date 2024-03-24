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
      main = inputs.nixpkgs.lib.nixosSystem{
        system = "x86_64-linux";
        modules = [
          inputs.home-manager.nixosModules.default
          inputs.vscode-server.nixosModules.default
          inputs.nixos-wsl.nixosModules.default
          ({pkgs, ...}:{
	        environment.systemPackages = [pkgs.wget];
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.teak = {
		
                home =  {
                  username = "teak";
                  homeDirectory = "/home/teak";
                  stateVersion = "23.11";
                  packages = [
                      pkgs.wget
                      pkgs.coreutils
                      pkgs.git
                  ];

                };
                programs.git = {
                    enable = true;
                    userEmail = "Ansh-Sonkusare"; 
                    userName = "sonkusare.satish12@gmail.com"; 
                  };

                programs.zsh = {
                  enable = true;
                  oh-my-zsh = {
                        enable = true;
                        plugins = [ "git" ];
                        theme = "bira";
                  };
                };
                
                programs.home-manager.enable = true;
                
                services.ssh-agent.enable = true;

            };
};
            networking.hostName = "nixos";
            system.stateVersion = "23.11";
	          programs.zsh.enable = true;
            users = {
              users.teak = {
		            shell = pkgs.zsh;
                isNormalUser = true;
                extraGroups = ["wheel"];
              };
            };
	          services.vscode-server.enable = true;
            wsl = {
                enable = true;
                defaultUser = "teak";
                wslConf.user.default = "teak";
		          };
          })
        ];
      };
    };

  };

}
