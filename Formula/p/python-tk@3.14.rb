class PythonTkAT314 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.8/Python-3.14.8.tgz"
  sha256 "a65b20a728f169f4e66ae143f40b1bd3d33c38d770251663f627c9767b79b210"
  license "Python-2.0"
  revision 1

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "128a3adfdc43dcdb6eb62657b74c2685a3b637128345b50ccaca1476933da31b"
    sha256 cellar: :any, arm64_tahoe:       "cced776a4fc9c4193d158d9631cab8732fadc2d41a9c4001daba603968a2c93d"
    sha256 cellar: :any, arm64_sequoia:     "38b59b8dd4c5aca796713303518371a9ee263cc5e4f88048ec0aa410aff814be"
    sha256               arm64_linux:       "36a7d1e8b32d7511c0d358e86aca6eb0666cf71072b4fcfd854888c074d732fd"
    sha256               x86_64_linux:      "6c3db931d58c28f7b3856c7736d8d3b2fd0ebed1dcbd8f8d81d37b5bd6bea155"
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