{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

   networking.hostName = "rosetta"; # Define your hostname.
   time.timeZone = "Europe/Sofia"; # Set your time zone.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

users.users = {
  rosetta = {
    isNormalUser = true;
    name = "rosetta";
    description = "Rosetta";
    createHome = true;
    uid = 1000;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword = "$6$pxKVtMwhMcwQ/SwG$1GZKYkTRwZKN/RePnC9jv3Fa3rpBzn7sWo0jiL5mf9rc8PN.nW5cO1U/KdwWtckxohc62FgJ.mf95F.Ju8Jcg.";         # hashed password, see note below
  };
};

security.sudo = {
  enable = true;
  extraConfig = ''
    rosetta ALL=(ALL) NOPASSWD: ALL
  '';
};


nix.settings.experimental-features = [ "nix-command" "flakes" ];
system.stateVersion = "25.11";

  # programs.firefox.enable = true;

   environment.systemPackages = with pkgs; [
     vim
     curl
     wget
     jq
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  ########################################
  # Wordlists (FETCH)
  ########################################
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

      subdomains_20k = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-20000.txt"
        "0fml1ddbn5g5g758q9in7pcl9a7vnjm9yva65ni71qan9crad55f";

      web_extensions_43 = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/web-extensions.txt"
        "0s64g3pwqgrmlphxkakplwmbganm9wcxrcc74g964dny69s6snjp";

      quickhits_3k = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/quickhits.txt"
        "0z2zllk62sd8sdn6csxwfc74wxqs4pf9vlc0mqz89xqbngbian9f";

      common_5k = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt"
        "0nldb3kqzanh07c0qdb8012h360795gdz2pnzld4334lp6whlh3l";

      snmp_3k = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/SNMP/snmp.txt"
        "0rs3c8x5hp47fq8r52vbsvmcpjirldvw6av11g11ng01aq6k3rf8";
    };

    heavy = {
      directories_medium_220k = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt"
        "19za310n1az8k3996dff9wfhnaib77kqij0ncgjknps8azi9yqfp";

      raft_directories_62k = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-large-directories.txt"
        "0828dpbjv9n8k36snnadybd0xj1gvbni7z2d0mr9f9pi3p3ramx8";

      subdomains_bitquark_100k = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/bitquark-subdomains-top100000.txt"
        "0044pf5mf1smvigr6idcpzjvzal08za4dcx3hvx0ifrnq7gsrq7m";

      subdomains_100k = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-110000.txt"
        "17kshahlxklvaim8ppmfaz87qmh9b8qkijjcn644v96f74gl96wl";

      big_20k = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/big.txt"
        "11c1zygmyimrv4x0awrh5z5vfsgl3fgx56s3dymr1z4zapmixfba";
    };

    usersWL = {
      xato_8m = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Usernames/xato-net-10-million-usernames.txt"
        "198xpgf51h093nimwpg5ifqcqvasx0379wbp3qnci5k9fl2szd8r";

      top_17 = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Usernames/top-usernames-shortlist.txt"
        "1pdmdmbfzimhrh2b5r4whd28j0asjfmgy8vn04kl1nyw29fpfi6w";

      jsmith_48k = fetch
        "https://raw.githubusercontent.com/insidetrust/statistically-likely-usernames/master/jsmith.txt"
        "1vy5wm3gn14kdwxiz7skwgcz38lcbg08anr59s67zmid6hp8z7jr";

      jsmith2_5k = fetch
        "https://raw.githubusercontent.com/insidetrust/statistically-likely-usernames/master/jsmith2.txt"
        "0n8h0bnakf6x5i1hl8hpsw9jkb8vw27axm9qlywav830m76bdd3h";
    };

    passwords = {
      top200_2023 = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/2023-200_most_used_passwords.txt"
        "1q2fw8z4fvh2avcxj9xp3hvjlp8vzvrkpkwaav5gz28l01v4mfs6";

      defaults_1k = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Default-Credentials/default-passwords.txt"
        "0nbk51makq1cymi9vp4i2m84g3q0j01q2acyd0y71shflzm79fvf";

      xato_10k = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/xato-net-10-million-passwords-10000.txt"
        "0akjkcnw5q64y00lblpigx8j1gfm9g53kk434mk4sd1iri65wgf6";

      darkweb_10k = fetch
        "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/darkweb2017_top-10000.txt"
        "1by9cwg5bsl1bgrcmd0p4qskfwavlij1yi25c9a0gbpv1mdhk7s7";
    };
  in

  ########################################
  # tmpfiles: directories + writable files
  ########################################
  {
    systemd.tmpfiles.rules = [
      "d /home/rosetta/Downloads 0755 rosetta rosetta -"
      "d /home/rosetta/Light 0755 rosetta rosetta -"
      "d /home/rosetta/Heavy 0755 rosetta rosetta -"
      "d /home/rosetta/Users 0755 rosetta rosetta -"
      "d /home/rosetta/Passwords 0755 rosetta rosetta -"
      "d /home/rosetta/Mutated 0755 rosetta rosetta -"
      "d /home/rosetta/Windows 0755 rosetta rosetta -"

      "C /home/rosetta/Light/directories_small_87k.txt - - - - ${light.directories_small_87k}"
      "z /home/rosetta/Light/directories_small_87k.txt 0644 rosetta rosetta -"

      "C /home/rosetta/Light/burp_parameters_6k.txt - - - - ${light.burp_parameters_6k}"
      "z /home/rosetta/Light/burp_parameters_6k.txt 0644 rosetta rosetta -"

      "C /home/rosetta/Heavy/directories_medium_220k.txt - - - - ${heavy.directories_medium_220k}"
      "z /home/rosetta/Heavy/directories_medium_220k.txt 0644 rosetta rosetta -"
    ];
  }

  ########################################
  # State version
  ########################################
  system.stateVersion = "25.11";
}
