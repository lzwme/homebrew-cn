class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://ghproxy.com/https://github.com/Tencent/ncnn/archive/refs/tags/20231027.tar.gz"
  sha256 "8d85896ed095d09f05fff32fc85d75eea0b971796ce0f48a9874d93d3d347674"
  license "BSD-3-Clause"
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "70ea3121876294da811d8d4c3ff5c51f694c0cc48688b06f1f449582224361a4"
    sha256 cellar: :any,                 arm64_ventura:  "8e8b107b03e129f82a57b24fce97413c2886a61ac40a283f077c73f4f3b2770b"
    sha256 cellar: :any,                 arm64_monterey: "4cca8eaa36bfa9ffea8e0baace5c2b9b95bd6a7f6b2d1b12dafe68a03c5cbc55"
    sha256 cellar: :any,                 sonoma:         "e5b39d066dca11f05524ef745fe5765b469f9c9fc17c0ad229025aab33aab76e"
    sha256 cellar: :any,                 ventura:        "78783d65c80e1dadb81dc544af58b07db6b11419fa82016fecc31506d03c5de9"
    sha256 cellar: :any,                 monterey:       "b4bab3f226332cd93588a1aa6f6f7ce11531ea35137b02a5e04927be51eb6ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab08e1f60cf6a69cc53738db06a9c39a89297d82f3ec54be0aa7cceae873750e"
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
      -DCMAKE_CXX_STANDARD=11
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