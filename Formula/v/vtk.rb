class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  url "https://www.vtk.org/files/release/9.6/VTK-9.6.2.tar.gz"
  sha256 "aed12cec12a9609179bf66329070266627ca64244a10856a452b2a17ffb04a1d"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 3
  head "https://gitlab.kitware.com/vtk/vtk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0868c03624da48f7e9bc2271b4bf7b90669ebe1c2680df2081f96fdba03a6dd5"
    sha256 cellar: :any, arm64_sequoia: "02e50fb48b76619297c6f6033396a3f3c229126ddf57de39f92c9aafd8cd5692"
    sha256 cellar: :any, arm64_sonoma:  "f57544a35bb03307e8db483c652fec140e94a54547213c29aa5105d3c2c7b1b6"
    sha256 cellar: :any, sonoma:        "251468ab62211793f447d316ca6a4145c74f51950574261fa5ab89c71952cb5c"
    sha256 cellar: :any, arm64_linux:   "46e253778b6b5db8ea7e863e9703ba419dada27b4dc8905c2453e8f47552c79e"
    sha256 cellar: :any, x86_64_linux:  "15fe4b287b23c31e6452c3b7971c90bec16c35beb77a84acffd1765fa06a1d38"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pyqt" => :test
  depends_on "boost"
  depends_on "cgns"
  depends_on "double-conversion"
  depends_on "eigen"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "hdf5"
  depends_on "jpeg-turbo"
  depends_on "jsoncpp"
  depends_on "libharu"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "lz4"
  depends_on "netcdf"
  depends_on "nlohmann-json"
  depends_on "proj"
  depends_on "pugixml"
  depends_on "python@3.14"
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "sqlite"
  depends_on "theora"
  depends_on "utf8cpp"
  depends_on "xz"

  uses_from_macos "expat"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "gl2ps"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  # Backport fix for HDF5 2.0.0 from CMake repo
  patch :p2 do
    url "https://github.com/Kitware/CMake/commit/27e558dfa5a5441954d8930f2b6d9ae700c95050.patch?full_index=1"
    sha256 "ba4ecd3f9abfaae2c60c9be6978c250622bdb9979b42ddec52116d51d034f911"
    directory "CMake/patches/99"
    type :cherry_pick
    resolves "https://gitlab.kitware.com/vtk/vtk/-/work_items/20014"
  end

  def install
    # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
    # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
    # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
    if OS.mac? && MacOS.version < :sequoia
      env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
      ENV.remove env_vars, /(^|:)#{Regexp.escape(formula_opt_prefix("expat"))}[^:]*/
      ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
    end

    python = "python3.14"
    qml_plugin_dir = lib/"qml/VTK.#{version.major_minor}"
    vtkmodules_dir = prefix/Language::Python.site_packages(python)/"vtkmodules"
    rpaths = [rpath, rpath(source: qml_plugin_dir), rpath(source: vtkmodules_dir)]

    args = %W[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DCMAKE_INSTALL_RPATH:STRING=#{rpaths.join(";")}
      -DCMAKE_DISABLE_FIND_PACKAGE_ICU:BOOL=ON
      -DCMAKE_CXX_STANDARD=14
      -DVTK_IGNORE_CMAKE_CXX11_CHECKS=ON
      -DVTK_WRAP_PYTHON:BOOL=ON
      -DVTK_PYTHON_VERSION:STRING=3
      -DVTK_LEGACY_REMOVE:BOOL=ON
      -DVTK_MODULE_ENABLE_VTK_InfovisBoost:STRING=YES
      -DVTK_MODULE_ENABLE_VTK_InfovisBoostGraphAlgorithms:STRING=YES
      -DVTK_MODULE_ENABLE_VTK_RenderingFreeTypeFontConfig:STRING=YES
      -DVTK_MODULE_USE_EXTERNAL_VTK_cgns:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_doubleconversion:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_eigen:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_expat:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_freetype:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_hdf5:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_jpeg:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_jsoncpp:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_libharu:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_libproj:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_libxml2:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_lz4:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_lzma:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_netcdf:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_nlohmannjson:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_ogg:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_png:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_pugixml:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_sqlite:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_theora:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_tiff:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_utf8:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_zlib:BOOL=ON
      -DPython3_EXECUTABLE:FILEPATH=#{which(python)}
      -DVTK_GROUP_ENABLE_Qt:STRING=YES
      -DVTK_QT_VERSION:STRING=6
    ]
    # External gl2ps causes failure linking to macOS OpenGL.framework
    args << "-DVTK_MODULE_USE_EXTERNAL_VTK_gl2ps:BOOL=ON" unless OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    vtk_dir = lib/"cmake/vtk-#{version.major_minor}"
    vtk_cmake_module = vtk_dir/"VTK-vtk-module-find-packages.cmake"
    assert_match Formula["boost"].version.major_minor_patch.to_s, vtk_cmake_module.read,
                 "VTK needs to be rebuilt against Boost!"

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0 FATAL_ERROR)
      project(Distance2BetweenPoints LANGUAGES CXX)
      find_package(VTK REQUIRED COMPONENTS vtkCommonCore CONFIG)
      add_executable(Distance2BetweenPoints Distance2BetweenPoints.cxx)
      target_link_libraries(Distance2BetweenPoints PRIVATE ${VTK_LIBRARIES})
    CMAKE

    (testpath/"Distance2BetweenPoints.cxx").write <<~CPP
      #include <cassert>
      #include <vtkMath.h>
      int main() {
        double p0[3] = {0.0, 0.0, 0.0};
        double p1[3] = {1.0, 1.0, 1.0};
        assert(vtkMath::Distance2BetweenPoints(p0, p1) == 3.0);
        return 0;
      }
    CPP

    system "cmake", ".", "-DCMAKE_BUILD_TYPE=Debug", "-DCMAKE_VERBOSE_MAKEFILE=ON", "-DVTK_DIR=#{vtk_dir}"
    system "make"
    system "./Distance2BetweenPoints"

    (testpath/"Distance2BetweenPoints.py").write <<~PYTHON
      import vtk
      p0 = (0, 0, 0)
      p1 = (1, 1, 1)
      assert vtk.vtkMath.Distance2BetweenPoints(p0, p1) == 3
    PYTHON

    system bin/"vtkpython", "Distance2BetweenPoints.py"
    system bin/"vtkpython", "-c", "from vtkmodules.qt.QVTKRenderWindowInteractor import QVTKRenderWindowInteractor"
  end
end