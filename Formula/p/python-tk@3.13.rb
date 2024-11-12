class PythonTkAT313 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.0/Python-3.13.0.tgz"
  sha256 "12445c7b3db3126c41190bfdc1c8239c39c719404e844babbd015a1bc3fafcd4"
  license "Python-2.0"
  revision 2

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ca64a597335059b4a83787e38642cc4084d8e38de8a193833bdeeca94a3596e"
    sha256 cellar: :any,                 arm64_sonoma:  "7fa20baf816abfcaa3ba0db4000bd60a9f124927078dfdd0e963cc39a2d1df69"
    sha256 cellar: :any,                 arm64_ventura: "e7eefc1e865bea88ea576d81c23829d3e384ec1cf5061562b9f64abff16b970c"
    sha256 cellar: :any,                 sonoma:        "30cefbee4731c7915a6c15991f3780bba00cee457ae578cd822e1b94b93492fb"
    sha256 cellar: :any,                 ventura:       "7e0ca107831a97ef3caf4c174565be03679d397c6f3324e7994dac9502d8a11f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a39924b5d12c86b0e91a271da52f4df1c4c5ad27238cf00a622976f124b29b4"
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