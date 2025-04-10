{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "apcaccess";
  version = "0.0.13";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "flyte";
    repo = "apcaccess";
    tag = version;
    hash = "sha256-XLoNRh6MgXCfRtWD9NpVZSyroW6E9nRYw6Grxa+AQkc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "setup_requires='pytest-runner'," ""
  '';

  pythonImportsCheck = [ "apcaccess" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Library offers programmatic access to the status information provided by apcupsd over its Network Information Server";
    mainProgram = "apcaccess";
    homepage = "https://github.com/flyte/apcaccess";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
  };
}
