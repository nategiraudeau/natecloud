# Configuration to boot my ITX PC from a USB

# PC build: https://pcpartpicker.com/list/JdNXQ6
# Router is an Xfinity XB7-T (PC will have wired connection)

{ modulesPath, ... }:
let key = builtins.getEnv "SSH_PUBLIC_KEY";
in assert key != "" || throw "SSH_PUBLIC_KEY not set (source .env)"; {
    # NixOS built in ISO-image module
    imports = [ "${modulesPath}/installer/cd-dvd/iso-image.nix" ];

    # MSI H510I Pro WiFi: https://pcpartpicker.com/list/JdNXQ6
    hardware.enableRedistributableFirmware = true;
    boot.initrd.availableKernelModules = [ "usb_storage" ];

    networking.hostName = "nateitx";
    # Xfinity router has DHCP on by default
    networking.useDHCP = true;
    users.users.nate.openssh.authorizedKeys.keys = [ key ];

    # Makes .local immediately available for ssh
    services.avahi = {
      enable = true;
      openFirewall = true;
      publish = { enable = true; addresses = true; };
    };

    isoImage = { makeEfiBootable = true; makeUsbBootable = true; forceTextMode = true; };
}
