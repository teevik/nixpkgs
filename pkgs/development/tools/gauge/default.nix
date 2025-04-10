{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gauge";
  version = "1.6.14";

  patches = [
    # adds a check which adds an error message when trying to
    # install plugins imperatively when using the wrapper
    ./nix-check.patch
  ];

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    tag = "v${version}";
    hash = "sha256-eWVU1uAUAM7GGMI6uTpn+89rdwhNVq4sMIfll6NE2XY=";
  };

  vendorHash = "sha256-VrJhi8PUdZ/M8wV/MzxTY/dhUgEQF9BMK7NRb9GVm1g=";

  excludedPackages = [
    "build"
    "man"
  ];

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    mainProgram = "gauge";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = with maintainers; [
      vdemeester
      marie
    ];
  };
}
