class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.13/Python-3.10.13.tgz"
  sha256 "698ec55234c1363bd813b460ed53b0f108877c7a133d48bde9a50a1eb57b7e65"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e2e4bd458f86e006ad32dc643b2dbb6b6bfc995c27d741121939e856d967c65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0302e500cca6e15a20a7393c364bc1ad9dc181f0f431532c765635d938d5062"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38233def9408ba9000078bcecaa14a14df6d2b0cea4de3e87c468c2ef69b67dd"
    sha256 cellar: :any_skip_relocation, ventura:        "eb2b5b54bed50298efcf9c2ee79bf637a6f572e309421c51df27e8b6544322a6"
    sha256 cellar: :any_skip_relocation, monterey:       "4c5c981939a17cca535732e47ce3c4c7b56ff1af2cfa1a3caaf447db1bdd3448"
    sha256 cellar: :any_skip_relocation, big_sur:        "0067cee06fd514adbf20d5f95c86f74021e3dbad2621c9ef14e7ad00747c3a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26ecc36fa6b327628e86c53d2447a52abfd75ea316259d909cab00825f999459"
  end

  keg_only :versioned_formula

  depends_on "python@3.10"
  depends_on "tcl-tk"

  def python3
    "python3.10"
  end

  def install
    cd "Modules" do
      tcltk_version = Formula["tcl-tk"].any_installed_version.major_minor
      (Pathname.pwd/"setup.py").write <<~EOS
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1)],
                          include_dirs=["#{Formula["tcl-tk"].opt_include/"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tk#{tcltk_version}"],
                          library_dirs=["#{Formula["tcl-tk"].opt_lib}"])
              ]
        )
      EOS
      system python3, *Language::Python.setup_install_args(libexec, python3),
                      "--install-lib=#{libexec}"
      rm_r libexec.glob("*.egg-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end