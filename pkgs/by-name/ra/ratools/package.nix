{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ratools";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "danrl";
    repo = "ratools";
    tag = "v${version}";
    sha256 = "07m45bn9lzgbfihmxic23wqp73nxg5ihrvkigr450jq6gzvgwawq";
  };

  makeFlags = [
    "-C"
    "src"
  ];

  installPhase = ''
    install -vD bin/* -t $out/bin
    install -vD man/* -t $out/share/man/man8
  '';

  meta = with lib; {
    description = "Fast, dynamic, multi-threading framework for IPv6 Router Advertisements";
    homepage = "https://github.com/danrl/ratools";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.fpletz ];
  };
}
