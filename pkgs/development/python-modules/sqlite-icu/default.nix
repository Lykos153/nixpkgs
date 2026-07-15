{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pkg-config,
  icu,
  sqlite,
}:

buildPythonPackage rec {
  pname = "sqlite-icu";
  version = "1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lzyvQfMWcv7XyAUyfB1Ydjb42MvH9uVIbslNaRcDbt0=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pkg-config ];
  # icu.c is a loadable SQLite extension: it needs both ICU's headers/libs
  # (the actual functionality being wrapped) and SQLite's own sqlite3ext.h
  # (the extension-loading API it's written against). `icu` alone doesn't
  # provide the latter.
  buildInputs = [
    icu
    sqlite
  ];

  # icu.c compiles to a "icu" extension module -- a loadable SQLite
  # extension, not a regular importable Python module -- so an imports
  # check would fail; sqlite_icu.py itself is just a tiny locator shim.
  pythonImportsCheck = [ "sqlite_icu" ];
  doCheck = false;

  meta = {
    description = "Loadable ICU extension for SQLite, packaged for use from Python's sqlite3 module";
    homepage = "https://github.com/karlb/sqlite-icu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
