{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "hactool";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "SciresM";
    repo = "hactool";
    tag = version;
    sha256 = "0305ngsnwm8npzgyhyifasi4l802xnfz19r0kbzzniirmcn4082d";
  };

  patches = [ ./musl-compat.patch ];

  preBuild = ''
    mv config.mk.template config.mk
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  enableParallelBuilding = true;

  installPhase = ''
    install -D hactool${stdenv.hostPlatform.extensions.executable} $out/bin/hactool${stdenv.hostPlatform.extensions.executable}
  '';

  meta = with lib; {
    homepage = "https://github.com/SciresM/hactool";
    description = "Tool to manipulate common file formats for the Nintendo Switch";
    longDescription = "A tool to view information about, decrypt, and extract common file formats for the Nintendo Switch, especially Nintendo Content Archives";
    license = licenses.isc;
    maintainers = [ ];
    platforms = platforms.all;
    mainProgram = "hactool";
  };
}
