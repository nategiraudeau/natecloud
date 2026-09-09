{
  system.stateVersion = "26.05";

  users.mutableUsers = false;
  users.users.root.hashedPassword = "!";
  users.users.nate = { isNormalUser = true; extraGroups = [ "wheel" ]; hashedPassword = "!"; };

  security.sudo.wheelNeedsPassword = false;
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
  };
}
