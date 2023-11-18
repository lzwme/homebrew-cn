class Pyside < Formula
  include Language::Python::Virtualenv

  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.6.0-src/pyside-setup-everywhere-src-6.6.0.tar.xz"
  sha256 "2dd002db8851a87173354f38aa8c6ec42d0ff1fac99ea422b29e2dfce52d1638"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside6/"
    regex(%r{href=.*?PySide6[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "94be62cc50bf972364f1143880ee124d6366b95d2aad8dbb23cf079cd5db3471"
    sha256 cellar: :any, arm64_ventura:  "1fe673f798329681901e462c6eef0e51df5f7158cc86e24be3f0a10085fd41d9"
    sha256 cellar: :any, arm64_monterey: "2c4c5dfce903d49bbb8c2b73ca2c205bb441c5be8a46c33457a5e288fef134f3"
    sha256 cellar: :any, sonoma:         "9da672433c96dc84668836db8e14baccb0319779456fa5ac0988c587a67f5cbf"
    sha256 cellar: :any, ventura:        "59e9b0a27de79ebdfc2eae88d187d93ca29eb8748407bfdafa5e3bfc9d7766d7"
    sha256 cellar: :any, monterey:       "1b144607a6c0f30a08b9c277a49d83d34eb661983fce8f028cec0fb3c5b8cfae"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on xcode: :build
  depends_on "llvm"
  depends_on "python@3.12"
  depends_on "qt"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "mesa"
  end

  fails_with gcc: "5"

  # Fix .../sources/pyside6/qtexampleicons/module.c:4:10: fatal error: 'Python.h' file not found
  # Upstream issue: https://bugreports.qt.io/browse/PYSIDE-2491
  patch :DATA

  def python3
    "python3.12"
  end

  def install
    ENV.append_path "PYTHONPATH", buildpath/"build/sources"

    extra_include_dirs = [Formula["qt"].opt_include]
    extra_include_dirs << Formula["mesa"].opt_include if OS.linux?

    # upstream issue: https://bugreports.qt.io/browse/PYSIDE-1684
    inreplace "sources/pyside6/cmake/Macros/PySideModules.cmake",
              "${shiboken_include_dirs}",
              "${shiboken_include_dirs}:#{extra_include_dirs.join(":")}"

    # Fix build failure on macOS because `CMAKE_BINARY_DIR` points to /tmp but
    # `location` points to `/private/tmp`, which makes this conditional fail.
    # Submitted upstream here: https://codereview.qt-project.org/c/pyside/pyside-setup/+/416706.
    inreplace "sources/pyside6/PySide6/__init__.py.in",
              "in_build = Path(\"@CMAKE_BINARY_DIR@\") in location.parents",
              "in_build = Path(\"@CMAKE_BINARY_DIR@\").resolve() in location.parents"

    # Install python scripts into pkgshare rather than bin
    inreplace "sources/pyside-tools/CMakeLists.txt", "DESTINATION bin", "DESTINATION #{pkgshare}"

    # Avoid shim reference
    inreplace "sources/shiboken6/ApiExtractor/CMakeLists.txt", "${CMAKE_CXX_COMPILER}", ENV.cxx

    system "cmake", "-S", ".", "-B", "build",
                     "-DCMAKE_INSTALL_RPATH=#{lib}",
                     "-DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_lib}",
                     "-DPYTHON_EXECUTABLE=#{which(python3)}",
                     "-DBUILD_TESTS=OFF",
                     "-DNO_QT_TOOLS=yes",
                     "-DFORCE_LIMITED_API=yes",
                     *std_cmake_args

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", "import PySide6"
    system python3, "-c", "import shiboken6"

    modules = %w[
      Core
      Gui
      Network
      Positioning
      Quick
      Svg
      Widgets
      Xml
    ]
    modules << "WebEngineCore" if OS.linux? || (DevelopmentTools.clang_build_version > 1200)
    modules.each { |mod| system python3, "-c", "import PySide6.Qt#{mod}" }

    pyincludes = shell_output("#{python3}-config --includes").chomp.split
    pylib = shell_output("#{python3}-config --ldflags --embed").chomp.split

    if OS.linux?
      pyver = Language::Python.major_minor_version python3
      pylib += %W[
        -Wl,-rpath,#{Formula["python@#{pyver}"].opt_lib}
        -Wl,-rpath,#{lib}
      ]
    end

    (testpath/"test.cpp").write <<~EOS
      #include <shiboken.h>
      int main()
      {
        Py_Initialize();
        Shiboken::AutoDecRef module(Shiboken::Module::import("shiboken6"));
        assert(!module.isNull());
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp",
                    "-I#{include}/shiboken6",
                    "-L#{lib}", "-lshiboken6.abi3",
                    *pyincludes, *pylib, "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/sources/pyside6/qtexampleicons/CMakeLists.txt b/sources/pyside6/qtexampleicons/CMakeLists.txt
index 1562f7b..0611399 100644
--- a/sources/pyside6/qtexampleicons/CMakeLists.txt
+++ b/sources/pyside6/qtexampleicons/CMakeLists.txt
@@ -32,6 +32,8 @@ elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
     target_compile_definitions(QtExampleIcons PRIVATE "-DNDEBUG")
 endif()

+get_property(SHIBOKEN_PYTHON_INCLUDE_DIRS GLOBAL PROPERTY shiboken_python_include_dirs)
+
 target_include_directories(QtExampleIcons PRIVATE ${SHIBOKEN_PYTHON_INCLUDE_DIRS})

 get_property(SHIBOKEN_PYTHON_LIBRARIES GLOBAL PROPERTY shiboken_python_libraries)