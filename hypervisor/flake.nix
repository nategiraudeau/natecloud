{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }: {
    nixosConfigurations.nateitx = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ./nateitx ];
    };

    packages.x86_64-linux.nateitx-usb = self.nixosConfigurations.nateitx.config.system.build.isoImage;
  };
}
