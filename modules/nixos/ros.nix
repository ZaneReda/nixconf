{config, pkgs, ...}:
{

  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];


  #users.users.rosCommand = {
  #isNormalUser = true;
 # home = "/var/lib/ros";
 # createHome = true;
  #group = "ros";
  #shell = pkgs.bash;
  #};


imports = let
    nix-ros-overlay = builtins.fetchTarball {
      url = https://github.com/lopsided98/nix-ros-overlay/archive/develop.tar.gz;
      sha256 = "sha256:06mfh4mg8bqm9kbqis4j9xfdrqy2g37lijccdhcf4h371zf2y4yx";
    };
in [ (nix-ros-overlay + "/modules/ros1/ros.nix")
     (nix-ros-overlay + "/modules/ros1/core.nix")
     (nix-ros-overlay + "/modules/ros1/nodes.nix")
     (nix-ros-overlay + "/modules/common.nix") ]; # Makes ros usable and initializes the roscore service, can check with systemctl status roscore.service


  services.ros = {
    enable = true;
    distro = "noetic";
    pkgs = pkgs.rosPackages.noetic;
    systemPackages = p: with p; [ #Note a build error will occur if using a visualization package like viz or rviz with rqt plugins as they both try to build the same package in different ways, rqt uses a special version of said package
      desktop
    ];
  };

  nix = {
    settings = {
      extra-substituters = [ "https://ros.cachix.org" ];
      extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
    };
  };



}
