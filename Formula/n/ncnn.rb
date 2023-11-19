class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://ghproxy.com/https://github.com/Tencent/ncnn/archive/refs/tags/20231027.tar.gz"
  sha256 "8d85896ed095d09f05fff32fc85d75eea0b971796ce0f48a9874d93d3d347674"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b23c9027141674a70d605d9327042f903d0bb03dc7985d378ca7f739dad7ae87"
    sha256 cellar: :any,                 arm64_ventura:  "d360e6eba72e11fe8278fb5a0b0758f882e824be4117321d78158fccc08146bf"
    sha256 cellar: :any,                 arm64_monterey: "c374c47595c01b001db0a77088e7d0092a799d5c89b8445b7fcaff05d805d1b1"
    sha256 cellar: :any,                 sonoma:         "fc2e611a03655d5774dbadb1e3548947f0647bfaa19d537340663e8bf7f7cbc3"
    sha256 cellar: :any,                 ventura:        "b1e96f6d5fb66f67eef884d865d3358a89c7b587840127bfab304c4902019887"
    sha256 cellar: :any,                 monterey:       "9326de1cf95113872d481078af4e1bb1def7e6592cc94ccd0c9c9f0dbbd2152c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0173e6aa228d9c61ac7b019a50083a94e0bcc772b68892b3c8d19955db4415a7"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"

  on_macos do
    depends_on "glslang" => :build
    depends_on "vulkan-headers" => [:build, :test]
    depends_on "libomp"
    depends_on "molten-vk"
  end

  def install
    # fix `libabsl_log_internal_check_op.so.2301.0.0: error adding symbols: DSO missing from command line` error
    # https://stackoverflow.com/a/55086637
    ENV.append "LDFLAGS", "-Wl,--copy-dt-needed-entries" if OS.linux?

    args = std_cmake_args + %w[
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_CXX_STANDARD_REQUIRED=ON
      -DNCNN_SHARED_LIB=ON
      -DNCNN_BUILD_BENCHMARK=OFF
      -DNCNN_BUILD_EXAMPLES=OFF
    ]

    if OS.mac?
      args += %W[
        -DNCNN_SYSTEM_GLSLANG=ON
        -DGLSLANG_TARGET_DIR=#{Formula["glslang"].opt_lib/"cmake"}
        -DNCNN_VULKAN=ON
        -DVulkan_INCLUDE_DIR=#{Formula["molten-vk"].opt_include}
        -DVulkan_LIBRARY=#{Formula["molten-vk"].opt_lib/shared_library("libMoltenVK")}
      ]
    end

    inreplace "src/gpu.cpp", "glslang/glslang", "glslang"
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ncnn/mat.h>

      int main(void) {
          ncnn::Mat myMat = ncnn::Mat(500, 500);
          myMat.fill(1);
          ncnn::Mat myMatClone = myMat.clone();
          myMat.release();
          myMatClone.release();
          return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11",
                    "-I#{Formula["vulkan-headers"].opt_include}", "-I#{include}", "-L#{lib}", "-lncnn",
                    "-o", "test"
    system "./test"
  end
end