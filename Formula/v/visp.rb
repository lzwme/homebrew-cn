class Visp < Formula
  desc "Visual Servoing Platform library"
  homepage "https:visp.inria.fr"
  url "https:visp-doc.inria.frdownloadreleasesvisp-3.6.0.tar.gz"
  sha256 "eec93f56b89fd7c0d472b019e01c3fe03a09eda47f3903c38dc53a27cbfae532"
  license "GPL-2.0-or-later"
  revision 11

  livecheck do
    url "https:visp.inria.frdownload"
    regex(href=.*?visp[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "8de6357bee92823b92ba777a8da84b9675af33b5b6ba5c4615056b03d4051001"
    sha256 cellar: :any,                 arm64_ventura: "b1775095986f474013a66720ffd491003aa0e5d493a04e44e247cfbe4a67bd84"
    sha256 cellar: :any,                 sonoma:        "8b05aebbe9cf362755663b48f555f41bee7b028e601ab24ca1d91b1a5b46bab0"
    sha256 cellar: :any,                 ventura:       "da4233284042269153c4204742777d9511cc5c53abb82e6da7d715eda6a6b54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffe814594888a9d0c998fae5dfc4abd0d8e53c61b550a025c4fd2eef0ffcd0aa"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => [:build, :test]

  depends_on "eigen"
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "libdc1394"
  depends_on "libpng"
  depends_on "openblas"
  depends_on "opencv"
  depends_on "pcl"
  depends_on "vtk"
  depends_on "zbar"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "boost"
    depends_on "flann"
    depends_on "glew"
    depends_on "libomp"
    depends_on "libpcap"
    depends_on "qhull"
    depends_on "qt"
  end

  on_linux do
    depends_on "libnsl"
  end

  # Backport fix for recent Apple Clang
  patch do
    url "https:github.comlagadicvispcommit8c1461661f99a5db31c89ede9946d2b0244f8123.patch?full_index=1"
    sha256 "1e0126c731bf14dfe915088a4205a16ec0b6d5f2ea57d0e84f2f69b8e86b144f"
  end
  patch do
    url "https:github.comlagadicvispcommite41aa4881e0d58c182f0c140cc003b37afb99d39.patch?full_index=1"
    sha256 "c0dd6678f1b39473da885f7519daf16018e20209c66cdd04f660a968f6fadbba"
  end

  # Backport fix for VTK include directories detection
  patch do
    url "https:github.comlagadicvispcommit44d06319430c4933127e8dc31094259d92c63c2e.patch?full_index=1"
    sha256 "a474659656764ca7b98d7ab7bad162cd9d36c50018d3033eb59806d2ac309850"
  end
  patch do
    url "https:github.comlagadicvispcommit09c900480c5b9d3b2d97244fe3b109e48f8e2d27.patch?full_index=1"
    sha256 "417c3fa88cd5718e48e970ddd590ccaaafbe01db328dee79390fb931afa67da9"
  end
  patch do
    url "https:github.comlagadicvispcommitd6aebe3af2700c95c17c75aafb4f25d478a8f853.patch?full_index=1"
    sha256 "740cb92ff79a368475af7979ff6ac4c443f90808bd02dd841aec3428cdbc95ed"
  end

  # One usage of OpenCV Universal Intrinsics API altered starting from 4.9.0
  # TODO: Remove this patch in the next release
  patch do
    url "https:github.comlagadicvispcommitebfa2602faca0f40db2dd1cc0cfb72cd8177640c.patch?full_index=1"
    sha256 "7fac428ca4fee039a84770e9c7877c43e28945038ff21233da74f3ae159703e0"
  end

  def install
    ENV.cxx11

    # Avoid superenv shim references
    inreplace "CMakeLists.txt" do |s|
      s.sub!(CMake build tool:"\s+\${CMAKE_BUILD_TOOL},
             "CMake build tool:            gmake\"")
      s.sub!(C\+\+ Compiler:"\s+\${VISP_COMPILER_STR},
             "C++ Compiler:                #{ENV.cxx}\"")
      s.sub!(C Compiler:"\s+\${CMAKE_C_COMPILER},
             "C Compiler:                  #{ENV.cc}\"")
    end

    system "cmake", ".", "-DBUILD_DEMOS=OFF",
                         "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_TESTS=OFF",
                         "-DBUILD_TUTORIALS=OFF",
                         "-DUSE_DC1394=ON",
                         "-DDC1394_INCLUDE_DIR=#{Formula["libdc1394"].opt_include}",
                         "-DDC1394_LIBRARY=#{Formula["libdc1394"].opt_libshared_library("libdc1394")}",
                         "-DUSE_EIGEN3=ON",
                         "-DEigen3_DIR=#{Formula["eigen"].opt_share}eigen3cmake",
                         "-DUSE_GSL=ON",
                         "-DGSL_INCLUDE_DIR=#{Formula["gsl"].opt_include}",
                         "-DGSL_cblas_LIBRARY=#{Formula["gsl"].opt_libshared_library("libgslcblas")}",
                         "-DGSL_gsl_LIBRARY=#{Formula["gsl"].opt_libshared_library("libgsl")}",
                         "-DUSE_JPEG=ON",
                         "-DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}",
                         "-DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_libshared_library("libjpeg")}",
                         "-DUSE_LAPACK=ON",
                         "-DUSE_LIBUSB_1=OFF",
                         "-DUSE_OPENCV=ON",
                         "-DOpenCV_DIR=#{Formula["opencv"].opt_share}OpenCV",
                         "-DUSE_PCL=ON",
                         "-DUSE_PNG=ON",
                         "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}",
                         "-DPNG_LIBRARY_RELEASE=#{Formula["libpng"].opt_libshared_library("libpng")}",
                         "-DUSE_PTHREAD=ON",
                         "-DUSE_PYLON=OFF",
                         "-DUSE_REALSENSE=OFF",
                         "-DUSE_REALSENSE2=OFF",
                         "-DUSE_X11=OFF",
                         "-DUSE_XML2=ON",
                         "-DUSE_ZBAR=ON",
                         "-DZBAR_INCLUDE_DIRS=#{Formula["zbar"].opt_include}",
                         "-DZBAR_LIBRARIES=#{Formula["zbar"].opt_libshared_library("libzbar")}",
                         "-DUSE_ZLIB=ON",
                         *std_cmake_args

    # Replace generated references to OpenCV's Cellar path
    opencv = Formula["opencv"]
    opencv_references = Dir[
      "CMakeCache.txt",
      "CMakeFilesExportlibcmakevispVISPModules.cmake",
      "VISPConfig.cmake",
      "VISPGenerateConfigScript.info.cmake",
      "VISPModules.cmake",
      "modules**flags.make",
      "unix-installVISPConfig.cmake",
    ]
    inreplace opencv_references, opencv.prefix.realpath, opencv.opt_prefix
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    # Make sure software built against visp don't reference opencv's cellar path either
    inreplace [lib"pkgconfigvisp.pc", lib"cmakevispVISPConfig.cmake", lib"cmakevispVISPModules.cmake"],
              opencv.prefix.realpath, opencv.opt_prefix
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <visp3corevpConfig.h>
      #include <iostream>
      int main()
      {
        std::cout << VISP_VERSION_MAJOR << "." << VISP_VERSION_MINOR <<
                "." << VISP_VERSION_PATCH << std::endl;
        return 0;
      }
    CPP
    pkg_config_flags = shell_output("pkgconf --cflags --libs visp").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", *pkg_config_flags
    assert_equal version.to_s, shell_output(".test").chomp

    ENV.delete "CPATH"
    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
      project(visp-check)
      find_package(VISP REQUIRED)
      include_directories(${VISP_INCLUDE_DIRS})
      add_executable(visp-check test.cpp)
      target_link_libraries(visp-check ${VISP_LIBRARIES})
    CMAKE

    system "cmake", "-B", "build", "-S", "."
    system "cmake", "--build", "build"
    assert_equal version.to_s, shell_output("buildvisp-check").chomp
  end
end