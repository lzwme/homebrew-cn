class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.10/Python-3.11.10.tgz"
  sha256 "92f2faf242681bfa406d53a51e17d42c5373affe23a130cd9697e132ef574706"
  license "Python-2.0"
  revision 1

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "92778211497ed2841346c7e7f1916c6096e29e7c648073a1abe70dde5a36621a"
    sha256 cellar: :any,                 arm64_sonoma:  "e37be25a37436d98d32d2900dee5904df56e383d0110ea7292b6c3beaa7def3b"
    sha256 cellar: :any,                 arm64_ventura: "ba50ca97d3d6e3c64636d048283c391a8348924dc27156ad4da53c1d98a0ccd6"
    sha256 cellar: :any,                 sonoma:        "f4d2305f37b5f17b165dd3ad63ee695e692505cfc367c64623715365fba1c387"
    sha256 cellar: :any,                 ventura:       "d807dc0c3a10262b9ad4a74798640efbfda9876396b2f1ce8da2ad2917b714bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8595687a22fd4fafdf76edca3ecc710dad371864a0ec4f1cc303d5e49a2a870"
  end

  depends_on "python@3.11"
  depends_on "tcl-tk@8"

  def python3
    "python3.11"
  end

  def install
    cd "Modules" do
      tcltk = Formula["tcl-tk@8"]
      tcltk_version = tcltk.any_installed_version.major_minor
      Pathname("setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1)],
                          include_dirs=["#{tcltk.opt_include/"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tk#{tcltk_version}"],
                          library_dirs=["#{tcltk.opt_lib}"])
              ]
        )
      PYTHON
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false), "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end