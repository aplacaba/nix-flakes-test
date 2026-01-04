{
  description = "python nix project";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # nixpkgs.legacyPackages.${system};

        pythonPackages = ps: with ps; [
          requests
          pytest
          black
        ];
        pythonEnv = pkgs.python311.withPackages pythonPackages;

      in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              pythonEnv
              nodejs_24
              git
              ripgrep
              jq
            ];

            shellHook = ''
              echo "Development Environment Loaded!"
              echo "Python $(python --version)"
              echo "Node.js $(node --version)"
              echo ""
              echo "Run 'python' or 'node' to start config!"
            '';
            PROJECT_NAME = "sample-project";
            NODE_ENV = "development";
          };
        });
}
