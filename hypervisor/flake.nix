{
    description = "Hypervisor for natecloud. Builds configuration.nix (general) with nateitx (specific to my hardware)";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    };

    outputs = { self, nixpkgs }: {
        nixosConfigurations.nateitx = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";

            # Use configuration.nix as a general config
            # nateitx is config specific to my PC
            modules = [ ./configuration.nix ./nateitx ];
        };

        # Bootable ISO
        packages.x86_64-linux.nateitx-usb = self.nixosConfigurations.nateitx.config.system.build.isoImage;
    };
}
