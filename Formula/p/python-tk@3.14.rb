class PythonTkAT314 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.8/Python-3.14.8.tgz"
  sha256 "a65b20a728f169f4e66ae143f40b1bd3d33c38d770251663f627c9767b79b210"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "42ed9fed136c54737b8f4527c576e3410f8736e138c5f53e9e4a590fb19caf2b"
    sha256 cellar: :any, arm64_tahoe:       "87e6f5a1ca14f9e0ba0c9d5f4299f1dadecf46174b814288de38e8cd54554c7b"
    sha256 cellar: :any, arm64_sequoia:     "98d584c2129fb08bfa53cd14b5dcc712d4506899205a8cb2bd4c49eaaaf4da72"
    sha256               arm64_linux:       "dd296e07e265b451a3293907e095e560f1ec0e5e817004f9e5b17b95ac63249c"
    sha256               x86_64_linux:      "dabe938e0e6c0328e694fc406c975d2d26660f1316d793ddcc353e160068ce3b"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2030-11-01", because: :deprecated_upstream
  disable! date: "2031-11-01", because: :deprecated_upstream

  depends_on "python@3.14"
  depends_on "tcl-tk"

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