class PythonTkAT313 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.16/Python-3.13.16.tgz"
  sha256 "cfac63bddf956deafb1172ca131ae5dcaafd6f95056086e233fca205593ed427"
  license "Python-2.0"
  revision 1

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e2312ea8ab3904edf8bc0b5cc5fa4a449eef2c63e276a51e3fa26086c91a9f10"
    sha256 cellar: :any, arm64_tahoe:       "4bf089703371c2c0c5fe0a9fb0c43823654a88441c67dc43791d9f7f0a345615"
    sha256 cellar: :any, arm64_sequoia:     "1ef2b97eb91232ad0c92f532a405e47e0d2614e900e477e26414772aea4d6759"
    sha256               arm64_linux:       "0a4bad65e67365fd03492b8c15d2db0ccc767b419ade8bf24f585d443b4ca825"
    sha256               x86_64_linux:      "336a3ebe2b1c0fe87e77c5686e89d99ae85f59372f1fe901866eeeebffdb3a50"
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