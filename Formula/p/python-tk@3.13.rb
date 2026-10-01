class PythonTkAT313 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.16/Python-3.13.16.tgz"
  sha256 "cfac63bddf956deafb1172ca131ae5dcaafd6f95056086e233fca205593ed427"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a7a521c3f90dd0598306e51c5a7f1e92039a10ffe68bf9d717cd1151359595ef"
    sha256 cellar: :any, arm64_tahoe:       "a6eb724ddc39cdfd1bbb5d8133ac36b33511cc9a8ddc1580ec2116af8f1cb486"
    sha256 cellar: :any, arm64_sequoia:     "5381c27bda69cce951e12bd81a8afd6f3e9a61ca71151ab855252e411004d733"
    sha256               arm64_linux:       "444f3789060dca98ae4c5eaf03b8e9f08d9a29754c87a9c22e9edf711809bed3"
    sha256               x86_64_linux:      "ee58fc5cb35b91ecfbf548395e149a8f2fc2ce184f4d95e4facb6ce81c15fa9b"
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