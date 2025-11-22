{
  description = "Broad Spectrum - Website Auditor CLI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [];
        };

        # Node.js dependencies
        nodeDependencies = pkgs.mkYarnPackage {
          name = "broad-spectrum-node-deps";
          src = ./.;
          packageJSON = ./package.json;
          yarnLock = ./package-lock.json;
        };

      in
      {
        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core runtime
            deno

            # Build tools
            nodejs_20
            yarn

            # Task runner
            just

            # Git
            git

            # Testing tools
            curl
            jq

            # Documentation
            pandoc
          ];

          shellHook = ''
            echo "Broad Spectrum Development Environment"
            echo "======================================"
            echo ""
            echo "Available tools:"
            echo "  deno:    $(deno --version | head -1)"
            echo "  node:    $(node --version)"
            echo "  just:    $(just --version)"
            echo ""
            echo "Quick start:"
            echo "  just install  - Install dependencies"
            echo "  just build    - Build the project"
            echo "  just test     - Run tests"
            echo "  just audit URL - Audit a website"
            echo ""
            echo "Run 'just --list' for all available commands"
            echo ""

            # Set up environment
            export DENO_DIR="$PWD/.deno"
            export NODE_PATH="$PWD/node_modules"
          '';
        };

        # Default package
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "broad-spectrum";
          version = "1.0.0";

          src = ./.;

          buildInputs = with pkgs; [
            nodejs_20
            deno
          ];

          buildPhase = ''
            # Install npm dependencies
            npm install

            # Build ReScript
            npm run build
          '';

          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/lib/broad-spectrum

            # Copy built files
            cp -r lib $out/lib/broad-spectrum/
            cp -r src $out/lib/broad-spectrum/
            cp package.json $out/lib/broad-spectrum/
            cp deno.json $out/lib/broad-spectrum/

            # Create wrapper script
            cat > $out/bin/broad-spectrum <<EOF
            #!/usr/bin/env bash
            exec ${pkgs.deno}/bin/deno run \
              --allow-net \
              --allow-read \
              --allow-env \
              $out/lib/broad-spectrum/src/main.ts "\$@"
            EOF

            chmod +x $out/bin/broad-spectrum
          '';

          meta = with pkgs.lib; {
            description = "Comprehensive CLI website auditor for security, accessibility, performance, and SEO";
            homepage = "https://github.com/Hyperpolymath/broad-spectrum";
            license = licenses.mit;
            maintainers = [];
            platforms = platforms.all;
          };
        };

        # Apps
        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.default;
          exePath = "/bin/broad-spectrum";
        };

        # Formatter
        formatter = pkgs.nixpkgs-fmt;

        # Checks (tests)
        checks = {
          build = self.packages.${system}.default;

          tests = pkgs.stdenv.mkDerivation {
            name = "broad-spectrum-tests";
            src = ./.;

            buildInputs = with pkgs; [
              nodejs_20
              deno
            ];

            buildPhase = ''
              npm install
              npm run build
            '';

            checkPhase = ''
              deno test --allow-net --allow-read
            '';

            installPhase = ''
              touch $out
            '';

            doCheck = true;
          };
        };
      }
    );
}
