class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https:opencv.org"
  url "https:github.comopencvopencvarchiverefstags4.9.0.tar.gz"
  sha256 "ddf76f9dffd322c7c3cb1f721d0887f62d747b82059342213138dc190f28bc6c"
  license "Apache-2.0"
  revision 10

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "ff9a8d7ec44f4e9b954190108144021bbb6a3121c203381c714e608826a14aff"
    sha256 arm64_ventura:  "a91084586bc1d366602537146c69cd3ccebd67cf2f7779308ecb9e0940e76f6d"
    sha256 arm64_monterey: "9d8c2be2139f7266f3561a187d4e6cb60189460f7ad14be3102fa57badc39a8b"
    sha256 sonoma:         "5d28cee03b27355159ca32ad9a2d9820042b48f19830acec480d8b8adc0ade25"
    sha256 ventura:        "24d2a49356fbafd314432923341f2bb9cf740acf6f223e8094f116357660fe1d"
    sha256 monterey:       "954f4bae6843535c027cd0b5f0079a7d7b184a2f5dbec12c13cd1f3c1007770c"
    sha256 x86_64_linux:   "bf5ff1ded3a3278e08aa5257389840c28fc367b29721d4d0d979195de339006d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "ffmpeg@6"
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
  depends_on "vtk"
  depends_on "webp"

  uses_from_macos "zlib"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  resource "contrib" do
    url "https:github.comopencvopencv_contribarchiverefstags4.9.0.tar.gz"
    sha256 "8952c45a73b75676c522dd574229f563e43c271ae1d5bbbd26f8e2b6bc1a4dae"

    # TODO: remove with next OpenCV release. Fix https:github.comopencvopencv_contribpull3624
    patch do
      url "https:github.comopencvopencv_contribcommit46fb893f9a632012990713c4003d7d3cab4f2f25.patch?full_index=1"
      sha256 "8f89f3db9fd022ffbb30dd1992df6d20603980fadfe090384e12c57731a9e062"
    end
  end

  def python3
    "python3.12"
  end

  # Patch for DNN module to work with OpenVINO API 2.0(enabled starting OV 2022.1 release)
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchesa10057a843de773896a50e9b18f4559a8bbc4d27opencvopenvino-api2.0.patch"
    sha256 "08f918fa762715d0fbc558baee9867be8f059ee3008831dc0a09af63404a9048"
  end

  # Patch for G-API to work with OpenVINO API 2.0(enabled starting OV 2022.1 release)
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchesa10057a843de773896a50e9b18f4559a8bbc4d27opencvgapi-openvino-api2.0.patch"
    sha256 "b67aa8882559858824c5841ba3d0746078273be081540b0d339c0ff58dc9452d"
  end

  def install
    resource("contrib").stage buildpath"opencv_contrib"

    # Avoid Accelerate.framework
    ENV["OpenBLAS_HOME"] = Formula["openblas"].opt_prefix

    # Reset PYTHONPATH, workaround for https:github.comHomebrewhomebrew-sciencepull4885
    ENV.delete("PYTHONPATH")

    # Remove bundled libraries to make sure formula dependencies are used
    libdirs = %w[ffmpeg libjasper libjpeg libjpeg-turbo libpng libtiff libwebp openexr openjpeg protobuf tbb zlib]
    libdirs.each { |l| (buildpath"3rdparty"l).rmtree }

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