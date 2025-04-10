{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  pytest,
  testrail-api,
}:

buildPythonPackage rec {
  pname = "pytest-pytestrail";
  version = "0.10.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tolstislon";
    repo = "pytest-pytestrail";
    tag = version;
    sha256 = "sha256-y34aRxQ8mu6b6GBRMFVzn1shMVc7TumdjRS3daMEZJM=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ testrail-api ];

  # all tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pytest_pytestrail" ];

  meta = with lib; {
    description = "Pytest plugin for interaction with TestRail";
    homepage = "https://github.com/tolstislon/pytest-pytestrail";
    changelog = "https://github.com/tolstislon/pytest-pytestrail/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ aanderse ];
  };
}
