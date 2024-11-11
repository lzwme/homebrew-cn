class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.15/Python-3.10.15.tgz"
  sha256 "a27864e5ba2a4474f8f6c58ab92ff52767ac8b66f1646923355a53fe3ef15074"
  license "Python-2.0"
  revision 1

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bb493b45c3af673f353cda086feed51dc4da1f20ba9b0114b2cd8d318ea088e6"
    sha256 cellar: :any,                 arm64_sonoma:  "b3e9fc8276fc21b82cf9420e370d4561a3846c712f88a40d6652d6d2c61eca84"
    sha256 cellar: :any,                 arm64_ventura: "79ae5313ab99ed582a363997fbcde8dc5f724e56e19f4019c29970a81cceffc6"
    sha256 cellar: :any,                 sonoma:        "e8b05abf545c822e0024b6f19094a78ae944c469b54696181490818064ed34a0"
    sha256 cellar: :any,                 ventura:       "23c9e2cbbe7a8494bb496d754658b3deb8cdfc6f84dd358b51a6ec230fb84b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "014fbacded75238e7471ebce827c6de8cb40953bccf473259121228b0d1662ae"
  end

  keg_only :versioned_formula

  depends_on "python@3.10"
  depends_on "tcl-tk@8"

  def python3
    "python3.10"
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