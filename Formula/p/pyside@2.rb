class PysideAT2 < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.15-src/pyside-setup-opensource-src-5.15.15.tar.xz"
  sha256 "21d6818b064834b08501180e48890e5fd87df2fb3769f80c58143457f548c408"
  # NOTE: We omit some licenses:
  # 1. LICENSE.COMMERCIAL is removed from "OR" options as non-free
  # 2. GFDL-1.3-only is only used by not installed docs, e.g. sources/{pyside2,shiboken2}/doc
  # 3. BSD-3-Clause is only used by not installed examples
  license all_of: [
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
  ]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside2/"
    regex(%r{href=.*?PySide2[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "178bfac28b6aea96909460a6d7ce44db7e640a846a48a964b4fb9364c0dbbb86"
    sha256 cellar: :any,                 arm64_sonoma:  "ab18344204faa467c824c8d4da6e1e5d80dd0e43d7e48998e3f90e95bb956639"
    sha256 cellar: :any,                 arm64_ventura: "8735843b33c4a02bfa3dce6082e5da613f6c942849e6808d5251b5a592a49803"
    sha256 cellar: :any,                 sonoma:        "7a4c28bdc958a68d72769376e82a0b8b4e222ceefa3622028e534ac006fbf147"
    sha256 cellar: :any,                 ventura:       "2536223a55281bada5fd2502933b5573f50073871e23e6b17badeb881038e608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1abdac7d89bd080d31759b882b67af2f5a4870339ab0ee4731daa4571b2bf673"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "pkg-config" => :test
  depends_on "llvm"
  depends_on "python@3.12"
  depends_on "qt@5"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "libxcb"
    depends_on "mesa"
  end

  fails_with gcc: "5"

  # Don't copy qt@5 tools.
  patch do
    url "https://src.fedoraproject.org/rpms/python-pyside2/raw/009100c67a63972e4c5252576af1894fec2e8855/f/pyside2-tools-obsolete.patch"
    sha256 "ede69549176b7b083f2825f328ca68bd99ebf8f42d245908abd320093bac60c9"
  end

  # Apply Debian patches to support newer Clang and Python 3.12
  # Upstream issue ref: https://bugreports.qt.io/browse/PYSIDE-2268
  patch do
    url "http://deb.debian.org/debian/pool/main/p/pyside2/pyside2_5.15.14-1.debian.tar.xz"
    sha256 "a0dae3cc101b50f4ce1cda8076d817261feaa66945f9003560a3af2c0a9a7cd8"
    apply "patches/Shiboken-Fix-the-oldest-shiboken-bug-ever.patch",
          "patches/PyEnum-make-forgiving-duplicates-work-with-Python-3.11.patch",
          "patches/Fix-tests-sample_privatector-sample_privatedtor-failing-w.patch",
          "patches/Python-3.12-Fix-the-structure-of-class-property.patch",
          "patches/Support-running-PySide-on-Python-3.12.patch",
          "patches/Final-details-to-enable-3.12-wheel-compatibility.patch",
          "patches/shiboken2-clang-Fix-clashes-between-type-name-and-enumera.patch",
          "patches/shiboken2-clang-Fix-and-simplify-resolveType-helper.patch",
          "patches/shiboken2-clang-Remove-typedef-expansion.patch",
          "patches/shiboken2-clang-Fix-build-with-clang-16.patch",
          "patches/shiboken2-clang-Record-scope-resolution-of-arguments-func.patch",
          "patches/shiboken2-clang-Suppress-class-scope-look-up-for-paramete.patch",
          "patches/shiboken2-clang-Write-scope-resolution-for-all-parameters.patch",
          "patches/Modify-sendCommand-signatures.patch"
  end

  def python3
    "python3.12"
  end

  def install
    rpaths = if OS.mac?
      pyside2_module = prefix/Language::Python.site_packages(python3)/"PySide2"
      [rpath, rpath(source: pyside2_module)]
    else
      # Add missing include dirs on Linux.
      # upstream issue: https://bugreports.qt.io/browse/PYSIDE-1684
      extra_include_dirs = [Formula["mesa"].opt_include, Formula["libxcb"].opt_include]
      inreplace "sources/pyside2/cmake/Macros/PySideModules.cmake",
                "--include-paths=${shiboken_include_dirs}",
                "--include-paths=${shiboken_include_dirs}:#{extra_include_dirs.join(":")}"

      # Add rpath to qt@5 because it is keg-only.
      [lib, Formula["qt@5"].opt_lib]
    end

    # Avoid shim reference.
    inreplace "sources/shiboken2/ApiExtractor/CMakeLists.txt", "${CMAKE_CXX_COMPILER}", ENV.cxx

    ENV.append_path "CMAKE_PREFIX_PATH", Formula["qt@5"].opt_lib
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    python = which(python3)
    ENV.append_path "PYTHONPATH", prefix/Language::Python.site_packages(python)

    system python, "-c", "import PySide2"
    system python, "-c", "import shiboken2"

    modules = %w[
      Core
      Gui
      Location
      Multimedia
      Network
      Quick
      Svg
      WebEngineWidgets
      Widgets
      Xml
    ]

    modules.each { |mod| system python, "-c", "import PySide2.Qt#{mod}" }

    pyincludes = shell_output("#{python}-config --includes").chomp.split
    pylib = shell_output("#{python}-config --ldflags --embed").chomp.split

    (testpath/"test.cpp").write <<~EOS
      #include <shiboken.h>
      int main()
      {
        Py_Initialize();
        Shiboken::AutoDecRef module(Shiboken::Module::import("shiboken2"));
        assert(!module.isNull());
        return 0;
      }
    EOS

    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    pkg_config_flags = shell_output("pkg-config --cflags --libs shiboken2").chomp.split
    python_version = Language::Python.major_minor_version(python3)
    rpaths = []
    rpaths += ["-Wl,-rpath,#{lib}", "-Wl,-rpath,#{Formula["python@#{python_version}"].opt_lib}"] unless OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}",
                    *pkg_config_flags, *rpaths, *pyincludes, *pylib
    system "./test"
  end
end