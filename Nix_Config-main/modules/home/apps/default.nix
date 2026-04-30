{ config, pkgs, inputs, ... }:

{
  imports = [
    ./chrome.nix
  ];

  # Basic programs
  programs.home-manager.enable = true;
  programs.git.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
    ];
  };

  # Declarative Elephant Service
  systemd.user.services.elephant = {
    Unit = {
      Description = "Elephant - Data provider and executor";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.elephant}/bin/elephant";
      Restart = "on-failure";
      RestartSec = "5s";
      Environment = "PATH=${config.home.profileDirectory}/bin:/run/wrapper/bin:/run/current-system/sw/bin";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # WayVNC server
  systemd.user.services.wayvnc = {
    Unit = {
      Description = "WayVNC server";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wayvnc}/bin/wayvnc 0.0.0.0";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Packages to install in user profile
  home.packages = with pkgs; [
    walker
    elephant
    swww
    jq
    socat
    waybar
    libnotify
    wl-clipboard
    wtype
    kdePackages.breeze
    kdePackages.breeze-gtk
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct
    bibata-cursors
    wasistlos
    obsidian
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
