{ config, lib, pkgs, ... }:

let
  fetch = url: sha256: pkgs.fetchurl {
    inherit url sha256;
  };

  light = {
    directories_small_87k = fetch
      "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-small.txt"
      "143d3ac05qgjjsmix3ykbr7fx6bcrx94dz2vjqq4rckh2nlapxvp";

    burp_parameters_6k = fetch
      "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/burp-parameter-names.txt"
      "17w9a5qim0vfznk2581ml5025din8208ff6ig110xzaz85by9xwi";
  };

  heavy = {
    directories_medium_220k = fetch
      "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt"
      "19za310n1az8k3996dff9wfhnaib77kqij0ncgjknps8azi9yqfp";
  };
in
{
  ########################################
  # Imports
  ########################################
  imports = [
    ./hardware-configuration.nix
  ];

  ########################################
  # Boot
  ########################################
  boot.loader.grub.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  ########################################
  # Networking / Locale
  ########################################
  networking.hostName = "rosetta";
  time.timeZone = "Europe/Sofia";
  networking.networkmanager.enable = true;

  ########################################
  # Desktop
  ########################################
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  ########################################
  # User
  ########################################
  users.users.rosetta = {
    isNormalUser = true;
    description = "Rosetta";
    createHome = true;
    uid = 1000;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword =
      "$6$pxKVtMwhMcwQ/SwG$1GZKYkTRwZKN/RePnC9jv3Fa3rpBzn7sWo0jiL5mf9rc8PN.nW5cO1U/KdwWtckxohc62FgJ.mf95F.Ju8Jcg.";
  };

  ########################################
  # Sudo
  ########################################
  security.sudo = {
    enable = true;
    extraConfig = ''
      rosetta ALL=(ALL) NOPASSWD: ALL
    '';
  };

  ########################################
  # Nix
  ########################################
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ########################################
  # Packages
  ########################################
  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
    jq
  ];

  ########################################
  # Wordlists → filesystem
  ########################################
  systemd.tmpfiles.rules = [
    "d /home/rosetta/Light 0755 rosetta rosetta -"
    "d /home/rosetta/Heavy 0755 rosetta rosetta -"

    "C /home/rosetta/Light/directories_small_87k.txt - - - - ${light.directories_small_87k}"
    "z /home/rosetta/Light/directories_small_87k.txt 0644 rosetta rosetta -"

    "C /home/rosetta/Light/burp_parameters_6k.txt - - - - ${light.burp_parameters_6k}"
    "z /home/rosetta/Light/burp_parameters_6k.txt 0644 rosetta rosetta -"

    "C /home/rosetta/Heavy/directories_medium_220k.txt - - - - ${heavy.directories_medium_220k}"
    "z /home/rosetta/Heavy/directories_medium_220k.txt 0644 rosetta rosetta -"
  ];

  ########################################
  # State version (define ONCE)
  ########################################
  system.stateVersion = "25.11";
}
