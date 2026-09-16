# Config for my ITX PC: installs on the system from USB

# PC build: https://pcpartpicker.com/list/JdNXQ6
# Current router is an Xfinity XB7-T (PC will have wired connection)

{ modulesPath, lib, installed ? false, diskoModule ? null, ... }:
let key = builtins.getEnv "SSH_PUBLIC_KEY";
in assert key != "" || throw "SSH_PUBLIC_KEY not set (source .env && export SSH_PUBLIC_KEY)"; {
    imports = if installed then [
        diskoModule
        {
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;

            # NVMe boot drive
            disko.devices.disk.nvme = {
                device = "/dev/nvme0n1";
                type = "disk";
                content = {
                    type = "gpt";
                    partitions = {
                        ESP = {
                            size = "512M";
                            type = "EF00";
                            content = { type = "filesystem"; format = "vfat"; mountpoint = "/boot"; };
                        };
                        root = {
                            size = "100%";
                            content = { type = "filesystem"; format = "ext4"; mountpoint = "/"; };
                        };
                    };
                };
            };
        }
    ] else [
        "${modulesPath}/installer/cd-dvd/iso-image.nix"
        { isoImage = { makeEfiBootable = true; makeUsbBootable = true; forceTextMode = true; }; }
    ];

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
}
