class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.6/Python-3.12.6.tgz"
  sha256 "85a4c1be906d20e5c5a69f2466b00da769c221d6a684acfd3a514dbf5bf10a66"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "17b17d440aee24f8e9babca035c3f1edc306d2502fe51e2ce1298e038b31175c"
    sha256 cellar: :any,                 arm64_sonoma:   "5f22d21be5bfd8054cdadf53295769253af110f601055bb5e7d38d3cd8daa2db"
    sha256 cellar: :any,                 arm64_ventura:  "4dbbbba395a9f95aee1dd7a5340a740b05a5f167970000e009be65f34917cc04"
    sha256 cellar: :any,                 arm64_monterey: "c5c03ce5a3f39491e93d115231ffac7d1a7c6f90b6e10d2498ba11db4bf58bc9"
    sha256 cellar: :any,                 sonoma:         "8d5f84dd0068d72b10559e6cae03b1da742b2d7088a983c31f3d110560f5b47b"
    sha256 cellar: :any,                 ventura:        "bcc763cc850927d6c42ae74a792ad10fe0a72f5c7082d11b3469c908e8735a6f"
    sha256 cellar: :any,                 monterey:       "d60217dab21db273f65069c760563416e0d098e4ad76f927f6cd616ac044a62e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52dfe8eab42a78e4249c8e4ca1cede14535e61b81facffb1b96929eeba08ef79"
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
      (Pathname.pwd/"setup.py").write <<~EOS
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1)],
                          include_dirs=["#{python_include}/internal", "#{Formula["tcl-tk"].opt_include/"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tk#{tcltk_version}"],
                          library_dirs=["#{Formula["tcl-tk"].opt_lib}"])
              ]
        )
      EOS
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