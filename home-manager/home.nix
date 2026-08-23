{ config, pkgs, lib, username, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/${username}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Configuring Claude Code. Claude will also write to this file so we want to
  # merge our settings with Claude's current state rather than overwrite it.
  home.activation.claudeCodeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings="$HOME/.claude/settings.json"
    mkdir -p "$(dirname "$settings")"

    # Replaces missing or malformed ~/.claude/settings.json with {}.
    if ! ${pkgs.jq}/bin/jq -e . "$settings" > /dev/null 2>&1; then
      echo '{}' > "$settings"
    fi

    # Merging keys from apps/claude-code/settings.json into
    # ~/.claude/settings.json giving priority to keys in
    # apps/claude-code/settings.json.
    tmp="$(mktemp)"
    ${pkgs.jq}/bin/jq -s '.[0] * .[1]' \
      "$settings" ${./../apps/claude-code/settings.json} > "$tmp" && mv "$tmp" "$settings"
  '';

  # Keep Brave's new tab page clean: force-disable top sites and wipe their backing DBs.
  home.activation.braveHideTopSites = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    pref="$HOME/.config/BraveSoftware/Brave-Browser/Default/Preferences"
    top_sites="$HOME/.config/BraveSoftware/Brave-Browser/Default/Top Sites"
    shortcuts="$HOME/.config/BraveSoftware/Brave-Browser/Default/Shortcuts"

    if [ -f "$pref" ]; then
      tmp="$(mktemp)"
      ${pkgs.jq}/bin/jq '
        .brave.new_tab_page.show_top_sites = false
        | .brave.new_tab_page.show_stats = false
        | .ntp.shortcuts_visible = false
        | .ntp.shortcust_visible = false
        | .brave.brave_search["show-ntp-search"] = false
        | .brave.shields.stats_badge_visible = false
      ' "$pref" > "$tmp" && mv "$tmp" "$pref"
    fi

    # Remove cached top sites/shortcuts so Brave can't repopulate the grid.
    rm -rf "$top_sites" "$shortcuts"
  '';

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/scooke/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Force git/ssh to prompt in the terminal instead of launching the GNOME
  # ssh-askpass dialog, which GNOME exports SSH_ASKPASS for on session start.
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      unset SSH_ASKPASS
    '';
  };

  # Configuring the GNOME dock.
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "brave-browser.desktop"
        "org.gnome.Geary.desktop"
        "spotify.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };

    # Increasing the Console font size by a multiplier.
    "org/gnome/Console" = {
      font-scale = 1.5;
    };
  };

}
