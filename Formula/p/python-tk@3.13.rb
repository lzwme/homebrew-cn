class PythonTkAT313 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.17/Python-3.13.17.tgz"
  sha256 "9cb057caa588f122577a5054a22531cd9c23ab6706f1a19bc95a55380a895177"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "74eee6f6551db16639dc68060dab2362def20ddb569f320249f1228aac2154ba"
    sha256 cellar: :any, arm64_tahoe:       "04a2f09c859755ef839117cf55925a2f9532ea7bc3ce6328f04c54049c83c9ff"
    sha256 cellar: :any, arm64_sequoia:     "177c335b045e36c01689eaa03937ef3dbd57150d5c15693b44b1d1f4025326d7"
    sha256               arm64_linux:       "99c3ccca27b7185b0197b56f17abca87c3b115f4320c4a1623392f5e71bd0d1d"
    sha256               x86_64_linux:      "9733e3361a47f646ded974a8b61e406aa4fb8ec48c1d1f84bd47d90c3089cc68"
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