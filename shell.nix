{ nixpkgs ? import <nixpkgs> {} }:

with nixpkgs;

let
  cyberauftritt-jekyll = bundlerEnv rec {
    name = "cyberauftritt-jekyll-${version}";
    version = (import ./gemset.nix).jekyll.version;

    inherit ruby;
    gemdir = ./.;
  };
in stdenv.mkDerivation {
  name = "cyberauftritt-jekyll-env";
  buildInputs = [ cyberauftritt-jekyll ];
  shellHook = ''
    set -e
    # Build the site
    jekyll build
    # Run the tests
    htmlproofer --url-ignore https://www.blablacar.de _site
    # Automatically start the server
    exec jekyll serve
  '';
}
