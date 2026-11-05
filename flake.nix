{
  description = "Project template with the replica-* app-cloning Claude Code skills";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Claude Code plugin with the replica-* skills (no release tags).
    replica-skill = {
      url = "github:Jakeschincariol/replica-skill";
      flake = false;
    };
  };

  outputs = { nixpkgs, replica-skill, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          # replica-diff's tools are standard-library Python; replica-test uses
          # Playwright, whose downloaded browsers don't run on NixOS, so use the
          # ones from nixpkgs (@playwright/test must match PLAYWRIGHT_VERSION).
          packages = [
            pkgs.python3
            pkgs.nodejs_24
          ];
          PLAYWRIGHT_BROWSERS_PATH = pkgs.playwright-driver.browsers;
          PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
          PLAYWRIGHT_VERSION = pkgs.playwright-driver.version;

          # The plugin keeps its skills at the repo root, which Claude Code
          # doesn't load from .claude/skills; link each skill on its own.
          shellHook = ''
            root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
            mkdir -p "$root/.claude/skills"
            for skill in ${replica-skill}/*/SKILL.md; do
              dir=$(dirname "$skill")
              ln -sfn "$dir" "$root/.claude/skills/$(basename "$dir")"
            done
          '';
        };
      });
    };
}
