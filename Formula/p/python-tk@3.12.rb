class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.7/Python-3.12.7.tgz"
  sha256 "73ac8fe780227bf371add8373c3079f42a0dc62deff8d612cd15a618082ab623"
  license "Python-2.0"
  revision 2

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1d3a678547de2990df8986acf5833a34e6c71832da17236c60798b98efeb21cc"
    sha256 cellar: :any,                 arm64_sonoma:  "c44f7604f60ab26b29b9b16d299a67a4531bbfc6448c3e5109ee18e3ae0ad081"
    sha256 cellar: :any,                 arm64_ventura: "9c6a76e835333e6eaedfdb2cfd97b183c66b3b7d04a256578da43b4cfcbf18c3"
    sha256 cellar: :any,                 sonoma:        "0e985bff8d1864fdbfdff626b7c227b9b7e6d95123ee83956bbf3902124a6b23"
    sha256 cellar: :any,                 ventura:       "0a0fc9c50829214923bb18f85a02be9a8691a44fa2b7f17f721a39f4a2711cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9dbb94fb1954e24373c81e7d26b1d989f8f39300519debbe14a1707f5d853c9"
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