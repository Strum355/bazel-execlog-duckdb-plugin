{ lib, stdenv, callPackage, libduckdb, pkg-config, zig_0_13 }:
let fs = lib.fileset; in 
stdenv.mkDerivation rec {
  pname = "bazel-execlog-duckdb-extension";
  version = "1.0.0";

  src = fs.toSource {
    root = ./.;
    fileset = fs.difference ./. (fs.unions [
      ./flake.lock
      ./.envrc
      (fs.fileFilter (f: f.hasExt "nix") ./.)
      ./.github
    ]);
  };

  dontConfigure = true;
  dontStrip = true;

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    pkg-config
    zig_0_13.hook
  ];
  
  buildInputs = [
    libduckdb
  ];

  zigBuildFlags = [
    "--system"
    "${deps}"
  ];

  LIBDUCKDB_PATH = "${libduckdb}";
}
