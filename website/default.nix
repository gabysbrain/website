#!/usr/bin/env nix-build

{ pkgs ? import <nixpkgs> {} }:
let generator = pkgs.stdenv.mkDerivation {
      name = "website-generator";
      src = ./generator;
      phases = "unpackPhase buildPhase";
      buildInputs = [
        (pkgs.haskellPackages.ghcWithPackages (p: with p; [ hakyll ]))
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
     buildInputs = [ 
       generator 
       #pkgs.nodePackages.yarn
     ];
     buildPhase = ''
       #LANG=en_US.UTF-8 generator build
       generator build
       mkdir $out
       cp -r _site/* $out
     '';
   }
