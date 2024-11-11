class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.7/Python-3.12.7.tgz"
  sha256 "73ac8fe780227bf371add8373c3079f42a0dc62deff8d612cd15a618082ab623"
  license "Python-2.0"
  revision 1

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a0e2ee4095c4a880232d28b93b3f80024ab7851b70a6d51ed989ba4553c33d8"
    sha256 cellar: :any,                 arm64_sonoma:  "1fd1eb82c48ca0c87705cb142a5648eed0333b2ea03245db38f5bb9504f3773b"
    sha256 cellar: :any,                 arm64_ventura: "998e785c72fc54c1c972f904062c61331c79e1d5ec90727aa1febb5397a2a8f4"
    sha256 cellar: :any,                 sonoma:        "bc590b3602b08f302319063e0dc116a8a63b011edf322f1c7a3e7e68397e4332"
    sha256 cellar: :any,                 ventura:       "2b0a15b3ef3e7e71577a0dee86797a66ddc728484c90ec779c984f268fa8d89c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa6c801d46186547e89c2e475df5311ba4a9b4e5c326fcaf6287e9079b2a8185"
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