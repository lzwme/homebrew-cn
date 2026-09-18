class OpencvAT4 < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://ghfast.top/https://github.com/opencv/opencv/archive/refs/tags/4.14.0.tar.gz"
  sha256 "ee8fb9b30eb60850431b4656447080e3737b56e45719c92b67f245950609f86e"
  license "Apache-2.0"
  revision 8
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^v?(4(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "d616826b07134f34aa7179ca80ddbbee3a92e334b5db193f90e71319445c9d60"
    sha256 arm64_tahoe:       "7c07f019646dd0c67e10d35cf0a6931b7ea680284e30d308ee5ef4159be11d48"
    sha256 arm64_sequoia:     "9598eb6ea1ba46e25544d5118b6edab6d1aee813910426c956112c4bbf646cc3"
    sha256 arm64_linux:       "53e3d37a85fbec0cc478b9afe2d5576f538785aaae01a756598b5fa8dda15240"
    sha256 x86_64_linux:      "295e5d3d9fdd155786fb9e842968d399e32f72e3384c5e94e8d45a62b375a0f0"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-10-09", because: :unsupported
  disable! date: "2027-07-09", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
  depends_on "jsoncpp"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "openvino"
  depends_on "protobuf"
  depends_on "python@3.14"
  depends_on "tbb"
  depends_on "tesseract"
  depends_on "vtk"
  depends_on "webp"

  on_macos do
    depends_on "glew"
    depends_on "imath"
    depends_on "libarchive"
  end

  on_linux do
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "zlib-ng-compat"
  end

  resource "contrib" do
    url "https://ghfast.top/https://github.com/opencv/opencv_contrib/archive/refs/tags/4.14.0.tar.gz"
    sha256 "4f17abd1bc7f88e19c3380c8de7cbf2d863aced5b5ee8d8934cc7902b67d42c9"

    livecheck do
      formula :parent
    end
  end

  # Fix builds with FFmpeg 9.
  patch do
    url "https://github.com/opencv/opencv/commit/7551012b4e1c854c1dc36483c893f90b1c236977.patch?full_index=1"
    sha256 "0e662fbfd9949c4588138fcdb49bff124bf5e092ecfaa4db07938f50bb3ee1de"
    type :backport
    resolves "https://github.com/opencv/opencv/pull/29533"
  end

  patch do
    url "https://github.com/opencv/opencv/commit/a6f17e1f6a53f8bb016acfbcd55b61cbe220f5c8.patch?full_index=1"
    sha256 "f9fc79e1783debed6530600044c73f9a7d816c3b3095c260e1769bd04a62eb7d"
    type :backport
    resolves "https://github.com/opencv/opencv/pull/29662"
  end

  def install
    resource("contrib").stage buildpath/"opencv_contrib"

    # Avoid Accelerate.framework
    ENV["OpenBLAS_HOME"] = formula_opt_prefix("openblas")

    # Remove bundled libraries to make sure formula dependencies are used
    libdirs = %w[ffmpeg libjasper libjpeg libjpeg-turbo libpng libtiff libwebp openexr openjpeg protobuf tbb zlib]
    libdirs.each { |l| rm_r(buildpath/"3rdparty"/l) }

    # VTK 9.6 stopped transitively including <iostream>;
    # viz uses std::cout/endl directly.
    # PR refs: https://github.com/opencv/opencv_contrib/pull/4085
    inreplace "opencv_contrib/modules/viz/src/vtk/vtkVizInteractorStyle.cpp" do |s|
      s.sub! '#include "../precomp.hpp"', "#include <iostream>\n\\0"
      s.gsub!(/^(\s*)cout (<<.* )endl;$/, "\\1std::cout \\2std::endl;")
    end
    inreplace "opencv_contrib/modules/viz/src/widget.cpp", '#include "precomp.hpp"', "#include <iostream>\n\\0"

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
      -DOPENCV_EXTRA_MODULES_PATH=#{buildpath}/opencv_contrib/modules
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
      -DPYTHON3_EXECUTABLE=#{python3}
    ]

    args += if OS.mac?
      # Requires closed-source, pre-built Orbbec SDK on macOS
      ["-DWITH_OBSENSOR=OFF"]
    else
      # Disable precompiled headers and force opencv to use brewed libraries on Linux
      %W[
        -DENABLE_PRECOMPILED_HEADERS=OFF
        -DJPEG_LIBRARY=#{formula_opt_lib("jpeg-turbo")}/libjpeg.so
        -DOpenBLAS_LIB=#{formula_opt_lib("openblas")}/libopenblas.so
        -DOPENEXR_ILMIMF_LIBRARY=#{formula_opt_lib("openexr")}/libIlmImf.so
        -DOPENEXR_ILMTHREAD_LIBRARY=#{formula_opt_lib("openexr")}/libIlmThread.so
        -DPNG_LIBRARY=#{formula_opt_lib("libpng")}/libpng.so
        -DPROTOBUF_LIBRARY=#{formula_opt_lib("protobuf")}/libprotobuf.so
        -DPROTOBUF_INCLUDE_DIR=#{formula_opt_include("protobuf")}
        -DPROTOBUF_PROTOC_EXECUTABLE=#{formula_opt_bin("protobuf")}/protoc
        -DTIFF_LIBRARY=#{formula_opt_lib("libtiff")}/libtiff.so
        -DWITH_V4L=OFF
        -DZLIB_LIBRARY=#{formula_opt_lib("zlib-ng-compat")}/libz.so
      ]
    end

    # Ref: https://github.com/opencv/opencv/wiki/CPU-optimizations-build-options
    ENV.runtime_cpu_detection

    system "cmake", "-S", ".", "-B", "build_shared", *args, *std_cmake_args
    inreplace "build_shared/modules/core/version_string.inc", "#{Superenv.shims_path}/", ""
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", *args, *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    inreplace "build_static/modules/core/version_string.inc", "#{Superenv.shims_path}/", ""
    system "cmake", "--build", "build_static"
    lib.install buildpath.glob("build_static/{lib,3rdparty/**}/*.a")

    # Prevent dependents from using fragile Cellar paths
    inreplace lib/"pkgconfig/opencv#{version.major}.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <opencv2/core.hpp>
      #include <opencv2/imgcodecs.hpp>
      #include <opencv2/opencv.hpp>
      #include <iostream>
      int main() {
        std::cout << CV_VERSION << std::endl;
        cv::Mat img = cv::imread("#{test_fixtures("test.jpg")}", cv::IMREAD_COLOR);
        if (img.empty()) {
          std::cerr << "Could not read test.jpg fixture" << std::endl;
          return 1;
        }
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}/opencv4", "-o", "test",
                    "-L#{lib}", "-lopencv_core", "-lopencv_imgcodecs"
    assert_equal version.to_s, shell_output("./test").strip

    # The test below seems to time out on Intel macOS.
    return if OS.mac? && Hardware::CPU.intel?

    ENV.prepend_path "PYTHONPATH", prefix/Language::Python.site_packages(python3)
    output = shell_output("#{python3} -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end