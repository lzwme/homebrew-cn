class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https:opencv.org"
  url "https:github.comopencvopencvarchiverefstags4.10.0.tar.gz"
  sha256 "b2171af5be6b26f7a06b1229948bbb2bdaa74fcf5cd097e0af6378fce50a6eb9"
  license "Apache-2.0"
  revision 5
  head "https:github.comopencvopencv.git", branch: "4.x"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "4cd1b358941960a5703e4423bfb0dbe91f1e76cb8b098675893d878660bd1bfb"
    sha256 arm64_ventura:  "6cbc5c39ed022d01c5145293ab1e0ce3443dc38c29a0432f2c8257204655d196"
    sha256 arm64_monterey: "5186b784a6edc6179a738e47c433528b8c9ab4c303d6f1605c493655dc6dfd62"
    sha256 sonoma:         "958d230be219150d9033dd335a317377347e85cadfcb182c5ff424e8ff5a6283"
    sha256 ventura:        "f201a4f858d3cb15b5ef52aa9ab7e75f12106797911ebf0fd9797081da8a07d0"
    sha256 monterey:       "cd5ffe70d6a3bbec8c39e0088a78d7f0519a7cc54a6bad9ab28e69233224e983"
    sha256 x86_64_linux:   "899a23a6efcfff7d4cf29bd7055ff4bbf861e635d010392f0fe32abeece68644"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "abseil"
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "gflags"
  depends_on "glog"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "openvino"
  depends_on "protobuf"
  depends_on "python@3.12"
  depends_on "tbb"
  depends_on "tesseract"
  depends_on "vtk"
  depends_on "webp"

  uses_from_macos "zlib"

  on_macos do
    depends_on "glew"
    depends_on "imath"
    depends_on "jsoncpp"
    depends_on "libarchive"
  end

  on_linux do
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  resource "contrib" do
    url "https:github.comopencvopencv_contribarchiverefstags4.10.0.tar.gz"
    sha256 "65597f8fb8dc2b876c1b45b928bbcc5f772ddbaf97539bf1b737623d0604cba1"
  end

  def python3
    "python3.12"
  end

  def install
    resource("contrib").stage buildpath"opencv_contrib"

    # Avoid Accelerate.framework
    ENV["OpenBLAS_HOME"] = Formula["openblas"].opt_prefix

    # Reset PYTHONPATH, workaround for https:github.comHomebrewhomebrew-sciencepull4885
    ENV.delete("PYTHONPATH")

    # Remove bundled libraries to make sure formula dependencies are used
    libdirs = %w[ffmpeg libjasper libjpeg libjpeg-turbo libpng libtiff libwebp openexr openjpeg protobuf tbb zlib]
    libdirs.each { |l| rm_r(buildpath"3rdparty"l) }

    args = %W[
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_JASPER=OFF
      -DBUILD_JPEG=OFF
      -DBUILD_OPENEXR=OFF
      -DBUILD_OPENJPEG=OFF
      -DBUILD_PERF_TESTS=OFF
      -DBUILD_PNG=OFF
      -DBUILD_PROTOBUF=OFF
      -DBUILD_TBB=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_WEBP=OFF
      -DBUILD_ZLIB=OFF
      -DBUILD_opencv_hdf=OFF
      -DBUILD_opencv_java=OFF
      -DBUILD_opencv_text=ON
      -DOPENCV_ENABLE_NONFREE=ON
      -DOPENCV_EXTRA_MODULES_PATH=#{buildpath}opencv_contribmodules
      -DOPENCV_GENERATE_PKGCONFIG=ON
      -DPROTOBUF_UPDATE_FILES=ON
      -DWITH_1394=OFF
      -DWITH_CUDA=OFF
      -DWITH_EIGEN=ON
      -DWITH_FFMPEG=ON
      -DWITH_GPHOTO2=OFF
      -DWITH_GSTREAMER=OFF
      -DWITH_JASPER=OFF
      -DWITH_OPENEXR=ON
      -DWITH_OPENGL=OFF
      -DWITH_OPENVINO=ON
      -DWITH_QT=OFF
      -DWITH_TBB=ON
      -DWITH_VTK=ON
      -DBUILD_opencv_python2=OFF
      -DBUILD_opencv_python3=ON
      -DPYTHON3_EXECUTABLE=#{which(python3)}
    ]

    args += [
      "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON", # https:github.comprotocolbuffersprotobufissues12292
      "-Dprotobuf_MODULE_COMPATIBLE=ON", # https:github.comprotocolbuffersprotobufissues1931
    ]

    # Disable precompiled headers and force opencv to use brewed libraries on Linux
    if OS.linux?
      args += %W[
        -DENABLE_PRECOMPILED_HEADERS=OFF
        -DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib}libjpeg.so
        -DOpenBLAS_LIB=#{Formula["openblas"].opt_lib}libopenblas.so
        -DOPENEXR_ILMIMF_LIBRARY=#{Formula["openexr"].opt_lib}libIlmImf.so
        -DOPENEXR_ILMTHREAD_LIBRARY=#{Formula["openexr"].opt_lib}libIlmThread.so
        -DPNG_LIBRARY=#{Formula["libpng"].opt_lib}libpng.so
        -DPROTOBUF_LIBRARY=#{Formula["protobuf"].opt_lib}libprotobuf.so
        -DTIFF_LIBRARY=#{Formula["libtiff"].opt_lib}libtiff.so
        -DWITH_V4L=OFF
        -DZLIB_LIBRARY=#{Formula["zlib"].opt_lib}libz.so
      ]
    end

    # Ref: https:github.comopencvopencvwikiCPU-optimizations-build-options
    ENV.runtime_cpu_detection
    if Hardware::CPU.intel? && build.bottle?
      cpu_baseline = if OS.mac? && MacOS.version.requires_sse42?
        "SSE4_2"
      else
        "SSSE3"
      end
      args += %W[-DCPU_BASELINE=#{cpu_baseline} -DCPU_BASELINE_REQUIRE=#{cpu_baseline}]
    end

    system "cmake", "-S", ".", "-B", "build_shared", *args, *std_cmake_args
    inreplace "build_sharedmodulescoreversion_string.inc", "#{Superenv.shims_path}", ""
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", *args, *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    inreplace "build_staticmodulescoreversion_string.inc", "#{Superenv.shims_path}", ""
    system "cmake", "--build", "build_static"
    lib.install buildpath.glob("build_static{lib,3rdparty**}*.a")

    # Prevent dependents from using fragile Cellar paths
    inreplace lib"pkgconfigopencv#{version.major}.pc", prefix, opt_prefix

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <opencv2opencv.hpp>
      #include <iostream>
      int main() {
        std::cout << CV_VERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}opencv4", "-o", "test"
    assert_equal shell_output(".test").strip, version.to_s

    output = shell_output("#{python3} -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end