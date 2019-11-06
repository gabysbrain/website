#!/usr/bin/env nix-build

# from https://utdemir.com/posts/hakyll-on-nixos.html
{ pkgs ? import <nixpkgs> {} }:
let 
    generator = pkgs.stdenv.mkDerivation {
      name = "website-generator";
      src = ./generator;
      phases = "unpackPhase buildPhase";
      #nativeBuildInputs = [ pkgs.libsass ];
      buildInputs = [
        (pkgs.haskellPackages.ghcWithPackages (p: with p; [ 
          hakyll 
          #hakyll-sass 
        ]))
      ];
      buildPhase = ''
        mkdir -p $out/bin
        ghc -O2 --make site.hs -o $out/bin/generator
      '';
    };
in pkgs.stdenv.mkDerivation {
     name = "website-site";
     src = ./site;
     phases = "unpackPhase buildPhase";
     #nativeBuildInputs = [ pkgs.libsass ];
     buildInputs = [ 
       generator 
       pkgs.texlive.combined.scheme-full
       #pkgs.nodePackages.yarn
     ];
     buildPhase = ''
       generator build
       mkdir $out
       cp -r _site/* $out
     '';
   }
