{ modulesPath, ... }:
let key = builtins.getEnv "SSH_PUBLIC_KEY";
in assert key != "" || throw "Set SSH_PUBLIC_KEY and build with --impure"; {
  imports = [ "${modulesPath}/installer/cd-dvd/iso-image.nix" ];

  # MSI H510I PRO WIFI: https://pcpartpicker.com/list/JdNXQ6
  hardware.enableRedistributableFirmware = true;
  boot.initrd.availableKernelModules = [ "usb_storage" ];

  networking.hostName = "nateitx";
  networking.useDHCP = true;
  users.users.nate.openssh.authorizedKeys.keys = [ key ];

  services.avahi = {
    enable = true;
    openFirewall = true;
    publish = { enable = true; addresses = true; };
  };

  isoImage = { makeEfiBootable = true; makeUsbBootable = true; forceTextMode = true; };
}
