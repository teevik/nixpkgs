{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  cmake,
  dbus,
  dbus-test-runner,
  doxygen,
  pkg-config,
  qtbase,
  qtdeclarative,
  qttools,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-action-api";
  version = "1.1.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-action-api";
    tag = finalAttrs.version;
    hash = "sha256-JDcUq7qEp6Z8TjdNspIz4FE/euH+ytGWa4rSxy4voiU=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  postPatch = ''
    # Queries QMake for broken Qt variable: '/build/qtbase-<commit>/$(out)/$(qtQmlPrefix)'
    substituteInPlace qml/Lomiri/Action/CMakeLists.txt \
      --replace-fail 'exec_program(''${QMAKE_EXECUTABLE} ARGS "-query QT_INSTALL_QML" OUTPUT_VARIABLE QT_IMPORTS_DIR)' 'set(QT_IMPORTS_DIR "''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}")'

    # Fix section labels
    substituteInPlace documentation/qml/pages/* \
      --replace-warn '\part' '\section1'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    qtdeclarative
    qttools # qdoc
    validatePkgConfig
  ];

  buildInputs = [
    qtbase
    qtdeclarative
  ];

  nativeCheckInputs = [
    dbus
    dbus-test-runner
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "GENERATE_DOCUMENTATION" true)
    # Use vendored libhud2, TODO package libhud2 separately?
    (lib.cmakeBool "use_libhud2" false)
  ];

  dontWrapQtApps = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
    export QML2_IMPORT_PATH=${lib.getBin qtdeclarative}/${qtbase.qtQmlPrefix}
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Allow applications to export actions in various forms to the Lomiri Shell";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-action-api";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-action-api/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [ "lomiri-action-qt-1" ];
  };
})
