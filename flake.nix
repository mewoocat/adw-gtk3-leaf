{
  description = "adw-gtk3-leaf flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = {self, ...}@inputs: let
    adw-gtk3-leaf = let 
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      in pkgs.stdenvNoCC.mkDerivation (finalAttrs: with pkgs; {
        pname = "adw-gtk3-leaf";
        version = "5.5-0.1";

        src = ./.;

        nativeBuildInputs = [
          meson
          ninja
          sassc
        ];

        postPatch = ''
          chmod +x gtk/src/adw-gtk3-dark/gtk-3.0/install-dark-theme.sh
          patchShebangs gtk/src/adw-gtk3-dark/gtk-3.0/install-dark-theme.sh
        '';

        passthru = {
          updateScript = nix-update-script { };
        };

        meta = {
          license = lib.licenses.lgpl21Only;
          platforms = lib.platforms.unix;
        };
      });
  in {
    packages."x86_64-linux".default = adw-gtk3-leaf;
  };
}
