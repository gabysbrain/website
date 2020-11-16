# from https://robertwpearce.com/hakyll-pt-6-pure-builds-with-nix.html
let
  sources = import ./nix/sources.nix;
in
{ compiler ? "ghc883"
, pkgs ? import sources.nixpkgs { }
}:

let
  haskellPackages = pkgs.haskell.packages.${compiler}.override {
    overrides = hpNew: hpOld: {
      hakyll = hpNew.callPackage ./nix/hakyll.nix {};

      website = hpNew.callCabal2nix "gabysbrain-website" ./. { };

      # FIXME: this breaks nix-shell
      niv = import sources.niv { };
    };
  };

  project = haskellPackages.website;
in
{
  project = project;

  shell = haskellPackages.shellFor {
    packages = p: with p; [
      project
    ];
    buildInputs = with haskellPackages; [
      ghcid
      hlint       # or ormolu
      niv
      pkgs.cacert # needed for niv
      pkgs.nix    # needed for niv

      # FIXME: this needs to also be available to nix-build
      pkgs.texlive.combined.scheme-full
    ];
    withHoogle = true;
  };
}
