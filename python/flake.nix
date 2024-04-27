{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      python = pkgs.python311;
      python_packages = python.withPackages (ps: with ps; [
        ipython
        matplotlib
        openpyxl
        pandas
        requests
        seaborn
        selenium
      ]);
    in {
    devShells.default = pkgs.mkShell {
      name = "python";
      buildInputs = [ python_packages ];
    };
  });
}
