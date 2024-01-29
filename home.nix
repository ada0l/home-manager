{ config, pkgs, ... }:

{
  home.username = "ada0l";
  home.homeDirectory = "/home/ada0l";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    # docker
    colima
    docker

    # misc
    curl
    wget
    htop
    zip
    unzip
    git
    ranger
    fish
    zellij
    eza
    
    # search and replacing
    ripgrep
    fd
    sd
 
    # editors
    neovim
    helix

    lazydocker
    lazygit

    # control version of languages
    asdf-vm

    # nix
    nil
    # golang
    libcap
    go
    gopls
    gcc
    # rust
    cargo
    rustc
    rustfmt
    python
    conda
    nodePackages.pyright
    isort
    black
    # lua
    lua-language-server
    stylua
    # javascript
    prettierd
    typescript
    nodejs_20
    # make
    gnumake
    cmake
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink dotfiles/nvim;
    ".config/zellij".source = config.lib.file.mkOutOfStoreSymlink dotfiles/zellij;
    ".config/helix".source = config.lib.file.mkOutOfStoreSymlink dotfiles/helix;
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "ada0l";
    userEmail = "andreika.varfolomeev@yandex.ru";
    extraConfig = {
      init = {
        defaultbranch = "main";
      };
    };
    aliases = {
        s = "status";
        c = "commit";
        ch = "checkout";
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      source "$HOME/.nix-profile/etc/profile.d/nix.fish"
      source "$HOME/.nix-profile/share/asdf-vm/asdf.fish"
    '';
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

}
