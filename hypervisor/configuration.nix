{ pkgs, ... }:
{
    system.stateVersion = "26.05";

    users.mutableUsers = false;
    users.users.root.hashedPassword = "!";

    # nate is the admin user
    users.users.nate = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        hashedPassword = "!";
    };

    # nate does not need a password
    security.sudo.wheelNeedsPassword = false;

    # need to ssh from mac using defined key
    services.openssh.enable = true;
    services.openssh.settings = {
      PermitRootLogin = "no";

      # No password, just ssh key
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };

    environment.systemPackages = with pkgs; [
        fastfetch
        htop
        vim
        fzf
        ghostty
    ];
}
