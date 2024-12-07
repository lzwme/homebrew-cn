class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.8/Python-3.12.8.tgz"
  sha256 "5978435c479a376648cb02854df3b892ace9ed7d32b1fead652712bee9d03a45"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "945f9a1680c498dd78602650f90cf3e0925afbd6644c11166c48a1096327e3be"
    sha256 cellar: :any,                 arm64_sonoma:  "dc19d2315fd205e9c5e14b9c38e4d622d0996cf6da88b0647df2bd01ab43cf2d"
    sha256 cellar: :any,                 arm64_ventura: "d79d6dd6618b25e038892c53cd5d5fabe7462cb11f0b01b6c671e4eed58ad1a8"
    sha256 cellar: :any,                 sonoma:        "119696795a5495f88fabb6cfcee86c348e9b41d474e40db76651a4a7a8e13c82"
    sha256 cellar: :any,                 ventura:       "bcb5c33f62df281a176011f0611d0e3840d549ee098ddefee6e31b5cfe76491d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aefa3f0277e334e53ed9e7ade6b1b8a9ba9f9627257bedb6707297fa517b4969"
  end

  depends_on "python@3.12"
  depends_on "tcl-tk"

  def python3
    "python3.12"
  end

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      Formula["python@#{xy}"].opt_include/"python#{xy}"
    end

    cd "Modules" do
      tcltk_version = Formula["tcl-tk"].any_installed_version.major_minor
      Pathname("setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1), ("TCL_WITH_EXTERNAL_TOMMATH", 1)],
                          include_dirs=["#{python_include}/internal", "#{Formula["tcl-tk"].opt_include/"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tcl#{tcltk_version.major}tk#{tcltk_version}"],
                          library_dirs=["#{Formula["tcl-tk"].opt_lib}"])
              ]
        )
      PYTHON
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                              "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end