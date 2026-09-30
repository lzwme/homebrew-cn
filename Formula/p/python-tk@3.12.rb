class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.14/Python-3.12.14.tgz"
  sha256 "6c6df908d2c3fd24e6d76869e92542abd0f33aec9dfc18df8875f89660286d43"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "208188e6c8ce7ba83f98f948d2fcec6f37ca8e88b0786202e9fea59f009f634f"
    sha256 cellar: :any, arm64_tahoe:       "35f171283cf8f6c237b739db2257be852b9ddca263a5698b219643ede9275ca3"
    sha256 cellar: :any, arm64_sequoia:     "40bc7f69e88867e17760809e42da2e3d6404211f136224fa78b6193e93318ce5"
    sha256               arm64_linux:       "71eed55c9809ab32e7c761e21ec0223270dd2f061a190e6ed5e4b708349802f7"
    sha256               x86_64_linux:      "bcdef31ad44ef60cebf9488ebe002c3823d819844e6365a6a2a68e8853e302f5"
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