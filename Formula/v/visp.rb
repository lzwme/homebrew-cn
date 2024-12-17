class Visp < Formula
  desc "Visual Servoing Platform library"
  homepage "https:visp.inria.fr"
  url "https:visp-doc.inria.frdownloadreleasesvisp-3.6.0.tar.gz"
  sha256 "eec93f56b89fd7c0d472b019e01c3fe03a09eda47f3903c38dc53a27cbfae532"
  license "GPL-2.0-or-later"
  revision 9

  livecheck do
    url "https:visp.inria.frdownload"
    regex(href=.*?visp[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "a5a58d76081eac3f0aa696c9d9d585e13b8d83f87db94d31cf2d6cab4737e1d0"
    sha256 cellar: :any,                 arm64_ventura: "ed6c8b3ecd5b927d4f01d6960ce6403df2205e8c6d5d2698f91326abb0091c1d"
    sha256 cellar: :any,                 sonoma:        "44ea774131f383ff063c3a4cec51d9a88e6e9bdcf13b05ea365b0a9a466e7ddf"
    sha256 cellar: :any,                 ventura:       "eae2d82bde93a8ac54b7c86e1cf1d369b606b0c506fbf70326bfb0502951837f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24d6aa141440f2316eaecd0da436f0876026e101d7821a7a1c6daacbb473c8ae"
  end

  depends_on "cmake" => :build
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

  # One usage of OpenCV Universal Intrinsics API altered starting from 4.9.0
  # Remove this patch if it's merged into a future version
  # https:github.comlagadicvispissues1309
  # Patch source: https:github.comlagadicvisppull1310
  patch :DATA

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
  end
end

__END__
diff --git amodulestrackermbtsrcdepthvpMbtFaceDepthDense.cpp bmodulestrackermbtsrcdepthvpMbtFaceDepthDense.cpp
index 8a47b5d437..c6d636bc9e 100644
--- amodulestrackermbtsrcdepthvpMbtFaceDepthDense.cpp
+++ bmodulestrackermbtsrcdepthvpMbtFaceDepthDense.cpp
@@ -606,9 +606,15 @@ void vpMbtFaceDepthDense::computeInteractionMatrixAndResidu(const vpHomogeneousM
         cv::v_float64x2 vx, vy, vz;
         cv::v_load_deinterleave(ptr_point_cloud, vx, vy, vz);
 
+#if (VISP_HAVE_OPENCV_VERSION >= 0x040900)
+        cv::v_float64x2 va1 = cv::v_sub(cv::v_mul(vnz, vy), cv::v_mul(vny, vz));  vnz*vy - vny*vz
+        cv::v_float64x2 va2 = cv::v_sub(cv::v_mul(vnx, vz), cv::v_mul(vnz, vx));  vnx*vz - vnz*vx
+        cv::v_float64x2 va3 = cv::v_sub(cv::v_mul(vny, vx), cv::v_mul(vnx, vy));  vny*vx - vnx*vy
+#else
         cv::v_float64x2 va1 = vnz*vy - vny*vz;
         cv::v_float64x2 va2 = vnx*vz - vnz*vx;
         cv::v_float64x2 va3 = vny*vx - vnx*vy;
+#endif
 
         cv::v_float64x2 vnxy = cv::v_combine_low(vnx, vny);
         cv::v_store(ptr_L, vnxy);
@@ -630,7 +636,12 @@ void vpMbtFaceDepthDense::computeInteractionMatrixAndResidu(const vpHomogeneousM
         cv::v_store(ptr_L, vnxy);
         ptr_L += 2;
 
+#if (VISP_HAVE_OPENCV_VERSION >= 0x040900)
+        cv::v_float64x2 verr = cv::v_add(vd, cv::v_muladd(vnx, vx, cv::v_muladd(vny, vy, cv::v_mul(vnz, vz))));
+#else
         cv::v_float64x2 verr = vd + cv::v_muladd(vnx, vx, cv::v_muladd(vny, vy, vnz*vz));
+#endif
+
         cv::v_store(ptr_error, verr);
         ptr_error += 2;
 #elif USE_SSE