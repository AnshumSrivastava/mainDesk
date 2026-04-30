{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$line_break$character";
      directory = {
        style = "bold #007aff";
      };
      character = {
        success_symbol = "[❯](bold #34c759)";
        error_symbol = "[❯](bold #ff3b30)";
      };
    };
  };
}
