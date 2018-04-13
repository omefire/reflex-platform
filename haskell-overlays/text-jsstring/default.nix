{ haskellLib, fetchFromGitHub }:

self: super: {
  text = self.callCabal2nix "text" (fetchFromGitHub {
    owner = "luigy";
    repo = "text";
    rev = "6cc95ebb07c07001666d84ace5c13caefaaa0cad";
    sha256 = "1zplzy9mfpwjrk5l22gmla1vmk7wmwmgmjfk64b57ysn7madlv19";
  }) {};
  ghcjs-base = haskellLib.overrideCabal super.ghcjs-base (drv: {
    src = fetchFromGitHub {
      owner = "luigy";
      repo = "ghcjs-base";
      rev = "e287c5752064a2d3b2c4776a1520e4b0189881b0";
      sha256 = "01k7wj60gmmf9larjm3gqbsyxwb5xhqr4dyz4xswy78ql845qljd";
    };
    libraryHaskellDepends = with self; [
      base bytestring containers deepseq dlist ghc-prim
      ghcjs-prim integer-gmp primitive time
      transformers vector
    ];
  });
  attoparsec = haskellLib.overrideCabal super.attoparsec (drv: {
    src = fetchFromGitHub {
      owner = "luigy";
      repo = "attoparsec";
      rev = "e766a754811042f061b6b4498137d2ad28e207a8";
      sha256 = "106fn187hw9z3bidbkp7r4wafmhk7g2iv2k0hybirv63f8727x3x";
    };
  });
  buffer-builder = haskellLib.overrideCabal super.buffer-builder (drv: {
    doCheck = false;
    src = fetchFromGitHub {
      owner = "obsidiansystems";
      repo = "buffer-builder";
      rev = "59c730e0dec7ff0efd8068250f4bca9cb74c471d";
      sha256 = "18dd2ydva3hnsfyrzmi3y3r41g2l4r0kfijaan85y6rc507k6x5c";
    };
  });
  hashable = haskellLib.addBuildDepend (self.callCabal2nix "hashable" (fetchFromGitHub {
    owner = "luigy";
    repo = "hashable";
    rev = "97a6fc77b028b4b3a7310a5c2897b8611e518870";
    sha256 = "1rl55p5y0mm8a7hxlfzhhgnnciw2h63ilxdaag3h7ypdx4bfd6rs";
  }) {}) self.text;
  conduit-extra = haskellLib.appendPatch super.conduit-extra ./conduit-extra.patch;
  double-conversion = haskellLib.overrideCabal super.double-conversion (drv: {
    src = fetchFromGitHub {
      owner = "obsidiansystems";
      repo = "double-conversion";
      rev = "0f9ddde468687d25fa6c4c9accb02a034bc2f9c3";
      sha256 = "0sjljf1sbwalw1zycpjf6bqhljag9i1k77b18b0fd1pzrc29wnks";
    };
  });
  say = haskellLib.overrideCabal super.say (drv: {
    patches = (drv.patches or []) ++ [
      ./say-text-jsstring.patch
    ];
    buildDepends = (drv.buildDepends or []) ++ [
      self.ghcjs-base
    ];
  });
  aeson = haskellLib.appendPatch super.aeson ./aeson.patch;
}
