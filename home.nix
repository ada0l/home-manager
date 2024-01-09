{ config, pkgs, ... }:

{
  home.username = "ada0l";
  home.homeDirectory = "/home/ada0l";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    curl
    wget
    htop
    fish
    zellij
    git
    docker
    eza
  
    neovim
    helix

    lazydocker
    lazygit
    
    gnumake
    cmake
    python3
    typescript
    nodejs_20
  ];

  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink dotfiles/nvim;
    ".config/zellij".source = config.lib.file.mkOutOfStoreSymlink dotfiles/zellij;
    ".config/helix".source = config.lib.file.mkOutOfStoreSymlink dotfiles/helix;
  };

  programs.git = {
    enable = true;
    userName = "ada0l";
    userEmail = "andreika.varfolomeev@yandex.ru";
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "exa --color=always --icons --group-directories-first";
      la = "exa --color=always --icons --group-directories-first --all";
      ll = "exa --color=always --icons --group-directories-first --all --long";
    };
    shellAbbrs = {
      lg = "lazygit";
      ld = "lazydocker";
      g = "git";
      ga = "git add";
      glg = "git log --graph";
      gds = "git diff --staged";
      glo = "git log --pretty=format:'%C(Yellow)%h  %C(reset)%ad (%C(Green)%cr%C(reset))%x09 %C(Cyan)%an: %C(reset)%s'";
      z = "zellij";
    };
  };

  programs.home-manager.enable = true;
}
