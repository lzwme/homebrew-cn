class PythonTkAT313 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.15/Python-3.13.15.tgz"
  sha256 "c28d9d213c09b5b5ab2c29812950e12f746999e099b82894231be954b26baed9"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "cae878b6d40fb32e715af40f9d1ba5499c969ae0b8f0f8d54722d1ec317724e9"
    sha256 cellar: :any, arm64_tahoe:       "8e41e78e0d9905226b5345f4d96754e15df0f7c3d127981cc485a659af86ceb7"
    sha256 cellar: :any, arm64_sequoia:     "4db9b03ae086cd05d458e06c07b97486d11ce3ffa43564f868fab88bc5f7e9bc"
    sha256               arm64_linux:       "7465c9fb2fed8c2d20758521900742d0ae350a66844466d14390202f3d30a1c4"
    sha256               x86_64_linux:      "a35a2e7ff60d8813c37f9daff8849ef162101ae1f26fcfde2fedc56e1c681ace"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2029-11-01", because: :deprecated_upstream
  disable! date: "2030-11-01", because: :deprecated_upstream

  depends_on "python@3.13"
  depends_on "tcl-tk"

  # Backport of https://github.com/python/cpython/commit/47cbf038850852cdcbe7a404ed7c64542340d58a
  patch do
    file "Patches/python-tk/tcl9.diff"
    type :backport
  end

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      formula_opt_include("python@#{xy}")/"python#{xy}"
    end

    tcltk_version = Formula["tcl-tk"].any_installed_version.major_minor
    (buildpath/"Modules/pyproject.toml").write <<~TOML
      [project]
      name = "tkinter"
      version = "#{version}"
      description = "#{desc}"

      [tool.setuptools]
      packages = []

      [[tool.setuptools.ext-modules]]
      name = "_tkinter"
      sources = ["_tkinter.c", "tkappinit.c"]
      define-macros = [["WITH_APPINIT", "1"], ["TCL_WITH_EXTERNAL_TOMMATH", "1"]]
      include-dirs = ["#{python_include}/internal", "#{formula_opt_include("tcl-tk")/"tcl-tk"}"]
      libraries = ["tcl#{tcltk_version}", "tcl#{tcltk_version.major}tk#{tcltk_version}"]
      library-dirs = ["#{formula_opt_lib("tcl-tk")}"]
    TOML
    system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                            "--target=#{libexec}", "./Modules"
    rm_r libexec.glob("*.dist-info")
  end

  test do
    system python3, "-c", "import tkinter"
  end
end