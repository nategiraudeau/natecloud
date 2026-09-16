# Build: nix build --impure

{
    description = "Hypervisor for natecloud. nateitx/ is specific to my hardware and deployment method";

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

        # Persistent install
        nixosConfigurations.nateitx-installed = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { installed = true; diskoModule = disko.nixosModules.disko; };

            # ci.nix defines the GitHub CI runner
            modules = [ ./configuration.nix ./nateitx ./nateitx/ci.nix ];
        };

        # Bootable ISO
        packages.x86_64-linux.nateitx-usb = self.nixosConfigurations.nateitx.config.system.build.isoImage;
    };
}
