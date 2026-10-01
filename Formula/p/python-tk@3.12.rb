class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.15/Python-3.12.15.tgz"
  sha256 "de1a241a519e0a3374fea98988d0b52c886743f9d953f23be8269cc7b59c5fab"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1ef2fe635acf4b3eda7a88e6d1e491a237c8a1e5b9c4cef1927442c93443207d"
    sha256 cellar: :any, arm64_tahoe:       "95fea866e94eac24db0252598ee1d690298cddd08e6b27e7792dc260a2fd51e9"
    sha256 cellar: :any, arm64_sequoia:     "b5b7030fa7640e6d4a7e78a26f3273f0f9c3909ae60cb7a5275d8db347370215"
    sha256               arm64_linux:       "f99465a55f9beb8ea1e76aa30a8339201e6d08472b4aa1d13a6010d0e5cffa78"
    sha256               x86_64_linux:      "e104b63cc83aaa182aef94ddeb5730ed8914c98ca9baeab8b9a9ea49cac20023"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2028-11-01", because: :deprecated_upstream
  disable! date: "2029-11-01", because: :deprecated_upstream

  depends_on "python@3.12"
  depends_on "tcl-tk"

  # Apply commit from open PR to fix TCL 9 threaded detection
  patch do
    url "https://github.com/python/cpython/commit/a2019e226e4650cef35ebfde7ecd7ce044a4a670.patch?full_index=1"
    sha256 "03c4b6a293d4a51f534858657717bdc1465c42acb3b78e64c41f9011f966e449"
    type :backport
    resolves "https://github.com/python/cpython/pull/128103"
  end

  # Backport of https://github.com/python/cpython/commit/47cbf038850852cdcbe7a404ed7c64542340d58a
  patch do
    file "Patches/python-tk/tcl9.diff"
    type :backport
  end

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      formula_opt_include("python@#{xy}")/"python#{xy}"
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
                          include_dirs=["#{python_include}/internal", "#{formula_opt_include("tcl-tk")/"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tcl#{tcltk_version.major}tk#{tcltk_version}"],
                          library_dirs=["#{formula_opt_lib("tcl-tk")}"])
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
  end
end