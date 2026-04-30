{ config, pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    extensions = [
      { id = "hkgcgfkkcfjkmlmcliojioobidnjmkkb"; } # Antigravity
    ];
    commandLineArgs = [
      "--no-first-run"
      "--no-default-browser-check"
    ];
  };
}
