{
  inputs = {
    # Candidate channels
    #   - https://github.com/kachick/anylang-template/issues/17
    #   - https://discourse.nixos.org/t/differences-between-nix-channels/13998
    # How to update the revision
    #   - `nix flake update --commit-lock-file` # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake-update.html
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      rec {
        devShells.default = with pkgs;
          mkShell {
            buildInputs = [
              # https://github.com/NixOS/nix/issues/730#issuecomment-162323824
              bashInteractive

              nix-prefetch-git
              jq

              nil
              nixpkgs-fmt
              dprint
              go-task
              typos
            ];
          };

        packages.pinact = pkgs.buildGo120Module
          rec {
            pname = "pinact";
            version = "v0.1.2";
            src = pkgs.fetchFromGitHub {
              owner = "suzuki-shunsuke";
              repo = "pinact";
              rev = version;
              # nix-prefetch-git --url https://github.com/suzuki-shunsuke/pinact.git --rev v0.1.2 --quiet | jq .hash
              hash = "sha256-OQo21RHk0c+eARKrA2qB4NAWWanb94DOZm4b9lqDz8o=";
            };

            # https://discourse.nixos.org/t/buildgomodule-how-to-get-vendorsha256/9317/4
            vendorSha256 = "sha256-g7rdIE+w/pn70i8fOmAo/QGjpla3AUWm7a9MOhNmrgE=";
          };

        packages.default = packages.pinact;

        # `nix run . -- -help`
        apps.default = {
          type = "app";
          program = "${packages.pinact}/bin/pinact";
        };
      }
    );
}
