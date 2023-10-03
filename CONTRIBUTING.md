# How to develop

## Setup

1. Install [Nix](https://nixos.org/) package manager
2. Run `nix develop` or `direnv allow` in project root
3. You can use development tools

```console
> nix develop
> task
task: [test] nix run . -- -version
task: [fmt] dprint fmt
task: [lint] dprint check
task: [fmt] nixpkgs-fmt ./*.nix
task: [lint] typos . .github .vscode
0 / 1 have been reformatted
task: [lint] nixpkgs-fmt --check ./*.nix
0 / 1 would have been reformatted
pinact version  ()
```
