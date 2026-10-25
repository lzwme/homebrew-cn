class PythonTkAT315 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.15.1/Python-3.15.1.tgz"
  sha256 "133d85e118dc32621cda1d9d1d7d9694fe0c5e82bc339a7d528c109fe8b36387"
  license "Python-2.0"

  livecheck do
    formula "python@3.15"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a66d82f2f695011b453fac5098bca6f13c3b8d0c410fa09b2cd72737e824d51f"
    sha256 cellar: :any, arm64_tahoe:       "136d77c283eae1f6fea2aa78dd4bf7e91737862f2a51cab45a07bea5bb29deab"
    sha256 cellar: :any, arm64_sequoia:     "b215c6ccef059efe2d5f8c3b35338d4dbcec8c0131a92da384b20f90c601870d"
    sha256               arm64_linux:       "90850e9e516f33eee289385d410091f9bc14fb7c14a5769aa79182ff3b974be1"
    sha256               x86_64_linux:      "13ef7b4e8368e8cdc52c670d55d53b6dad69e5bcd7efdcba1b9a30fc631653e5"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2031-11-01", because: :deprecated_upstream
  disable! date: "2032-11-01", because: :deprecated_upstream

  depends_on "python@3.15"
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