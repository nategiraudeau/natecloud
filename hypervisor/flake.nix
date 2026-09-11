# Build: nix build --impure

{
    description = "Hypervisor for natecloud. Builds configuration.nix (general) with nateitx (specific to my hardware)";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
        disko.url = "github:nix-community/disko";
        disko.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, disko }: {
        nixosConfigurations.nateitx = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { installed = false; diskoModule = null; };

            # Use configuration.nix as a general config
            # nateitx is config specific to my PC
            modules = [ ./configuration.nix ./nateitx ];
        };

        # Deterministic install to the internal drive via disko
        nixosConfigurations.nateitx-installed = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { installed = true; diskoModule = disko.nixosModules.disko; };
            modules = [ ./configuration.nix ./nateitx ];
        };

        # Bootable ISO
        packages.x86_64-linux.nateitx-usb = self.nixosConfigurations.nateitx.config.system.build.isoImage;
    };
}
