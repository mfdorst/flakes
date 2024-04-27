{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, fenix }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in with pkgs; {
          default = mkShell {
            name = "rust";
            buildInputs = with fenix.packages.${system}.stable; [
              cargo
              clippy
              rustc
              rustfmt
            ];
            nativeBuildInputs = [ pkg-config ];
          };
        }
      );
    };
}
