{ config, pkgs, ... }:

{
  home.username = "ada0l";
  home.homeDirectory = "/Users/ada0l";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    neofetch
    # docker
    colima
    docker

    # misc
    wireguard-tools
    bat
    curl
    grpcurl
    wget
    htop
    zip
    unzip
    git
    gh
    gitui
    ranger
    fish
    zellij
    eza
    jq
    fzf
    zsh
    oh-my-zsh

    # search and replacing
    ripgrep
    fd
    gnused
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
    go
    gopls
    gcc
    delve
    impl
    gotests
    go-swagger
    # rust
    cargo
    rustc
    rustfmt
    python3
    nodePackages.pyright
    isort
    black
    # lua
    lua-language-server
    stylua
    # javascript
    nodePackages_latest.typescript-language-server
    prettierd
    nodejs_20

    # for ruby
    libyaml
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
# nix
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
      source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
      source "$HOME/.nix-profile/share/asdf-vm/asdf.fish"
# brew
      fish_add_path /opt/homebrew/bin

function envsource
  for line in (cat $argv | grep -v '^#')
    set item (string split -m 1 '=' $line)
    set -gx $item[1] $item[2]
    echo "Exported key $item[1]"
  end
end
    alias gsed="gnused"
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

  programs.zsh = {
    enable = true;
    initExtraFirst = ''
      # nix
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      source "$HOME/.nix-profile/share/asdf-vm/asdf.sh"
    '';
    oh-my-zsh = {
        enable = true;
        plugins = [ "git" "fzf" ];
        theme = "robbyrussell";
    };
    shellAliases = {
      ls = "exa --color=always --icons --group-directories-first";
      la = "exa --color=always --icons --group-directories-first --all";
      ll = "exa --color=always --icons --group-directories-first --all --long";
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
