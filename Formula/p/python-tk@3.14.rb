class PythonTkAT314 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.9/Python-3.14.9.tgz"
  sha256 "8b47e85ee67e93945e93620a051a8f44bfc1e9735ed67075d166f4a74b7a060b"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dfa63feda4b5345f0a683a5ddf80de1174a9f74b5353203ea90813fec211225b"
    sha256 cellar: :any, arm64_tahoe:       "a4689104d2e729937d6aeef1f70af827c59d3b9d767333c78c597ffa52031b7a"
    sha256 cellar: :any, arm64_sequoia:     "cef599f32d9cf6908548bcca1b671b03d7d23395cb3ceeb7c29a7f9efb8694f4"
    sha256               arm64_linux:       "fa93f147ec142495a6b22186ff599de16635f540e06cbe899343605f6e518e65"
    sha256               x86_64_linux:      "e41c773286d24b4125128125ff3534d2f25fb88f7873b631069d70d27f2dd4d4"
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