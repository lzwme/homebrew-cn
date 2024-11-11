class PythonTkAT313 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.0/Python-3.13.0.tgz"
  sha256 "12445c7b3db3126c41190bfdc1c8239c39c719404e844babbd015a1bc3fafcd4"
  license "Python-2.0"
  revision 1

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "76378aa64f14fc1629d67c4b555d67854f4eb38feb2116f68811acc3aba57fe0"
    sha256 cellar: :any,                 arm64_sonoma:  "1ea77015e79a44a30119ecaf88dcfd3ff5dc7be58278bd4adcb863f73d371529"
    sha256 cellar: :any,                 arm64_ventura: "7e881be3fa5e73d640a2622f473f5f355717fec82c2a37d2e8c103054f439002"
    sha256 cellar: :any,                 sonoma:        "e42d8d999d0e0d903edb68ede51e0951557779d2d607296e6e8e3563ca556fce"
    sha256 cellar: :any,                 ventura:       "cff0b668f1118abbf2de33172a9c5ec2dfa7c4306c7cc00820259c63cee3c39a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d4383b52d57b5ce3e717173f1cccde3d6fbcfecebf36a3328b8423380b30a7d"
  end

  depends_on "python@3.13"
  depends_on "tcl-tk"

  def python3
    "python3.13"
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
                          define_macros=[("WITH_APPINIT", 1)],
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