class PysideAT2 < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  # TODO: Check if we can use unversioned `llvm` at version bump.
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
    sha256 cellar: :any, arm64_sonoma:   "2fb5231ea5c60d393c95fbb817afbc8d5bebdc1b4ad4aae8e66e9de65bb7cc14"
    sha256 cellar: :any, arm64_ventura:  "15e1cc87d80bf3dc621fc99c8bee665eae023787c0fb0a050c01e57b3f21ceb4"
    sha256 cellar: :any, arm64_monterey: "dea75c16bcc8c75a9873e4a6caa2d20c9c57b7872e631e98d63bd8f6f8b9809d"
    sha256 cellar: :any, sonoma:         "c82515db47d91c7ba4f06db606e5c2fc3c898e7cda3cab42c6e6c1682840338d"
    sha256 cellar: :any, ventura:        "9850e91ac91f3608fccfb80b0123a1e2afc9fe5e7d68e7bf041116f5af9c6752"
    sha256 cellar: :any, monterey:       "64a5884f604c5049759a44c36680928be652626ce7173bcd6c9bcbd04964ca49"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "llvm@15" # Upstream issue ref: https://bugreports.qt.io/browse/PYSIDE-2268
  depends_on "python@3.10"
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

  def python3
    "python3.10"
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
                    "-DFORCE_LIMITED_API=yes",
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
    rpaths = []
    rpaths += ["-Wl,-rpath,#{lib}", "-Wl,-rpath,#{Formula["python@3.10"].opt_lib}"] unless OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp",
           "-I#{include}/shiboken2", "-L#{lib}", "-lshiboken2.abi3", *rpaths,
           *pyincludes, *pylib, "-o", "test"
    system "./test"
  end
end