 {
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
           
                  ];

                };
                programs.git = {
                  enable = true;
                  userName = "Ansh-Sonkusare";
                  userEmail = "sonkusare.satish12@gmail.com";
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
}