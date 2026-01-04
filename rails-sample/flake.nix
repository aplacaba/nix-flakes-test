{
  description = "Ruby on Rails development setup";

  inputs  = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # overlays = [
        #   (self: super: {
        #     ruby = pkgs.ruby_3_4;
        #   })
        # ];

        pkgs = import nixpkgs { inherit system; };

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            ruby
            gcc
            gnumake
            pkg-config
            zlib
            openssl
            libyaml
            gmp
            readline
            rustc
            fish
          ];

          nativeBuildInputs = [ pkgs.pkg-config ];

          env = {
            SHELL = "${pkgs.fish}/bin/fish";
          };

          shellHook = ''
          exec fish -C '
            # Set local gem directory
            set -gx GEM_HOME $PWD/.gem;
            set -gx PATH $GEM_HOME/bin $PATH;

            bundle config set path $GEM_HOME

            if not type -q rails
              echo "Rails not found. Installing rails..."
              gem install rails
            end

            if not test -d "$GEM_HOME/gems"
              echo "Installing Ruby gems..."
              bundle install
            end

            # show versions
            echo "Ruby version: $(ruby --version)"
            echo "Rails version: $(rails --version)"
          '
        '';
        };
      }
    );
}
