class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.20/Python-3.9.20.tar.xz"
  sha256 "6b281279efd85294d2d6993e173983a57464c0133956fbbb5536ec9646beaf0c"
  license "Python-2.0"
  revision 1

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "713fa447f7c22e845ea7f233ee4c9e3688c17942c3ebca2cd86b0892f5a4cbbe"
    sha256 cellar: :any,                 arm64_sonoma:  "8fae9d8fa88dfc67f9cbf446988a5fdbe94ce9c4f6c8cbe0991052fad146f1dc"
    sha256 cellar: :any,                 arm64_ventura: "49cb8b6b5d122cac8762ef7ff7524862331749fc2772c4541ab0c32756a67dce"
    sha256 cellar: :any,                 sonoma:        "49b41bd79d0561af95339e8a75cc1316925ff2ca4ad4db9296502b80e3ac0b4a"
    sha256 cellar: :any,                 ventura:       "d3550da832fb9d53e35a5cb807f02cd16e64dc185cda24c4fd4fed54b1aacac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cff57de7bffd395bbef20d24cb6a04cd41817e8e087eee1af0d241c73f05dcd"
  end

  depends_on "python@3.9"
  depends_on "tcl-tk@8"

  def python3
    "python3.9"
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