class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://ghproxy.com/https://github.com/Tencent/ncnn/archive/refs/tags/20230816.tar.gz"
  sha256 "6b14105b6aba1e5fc87321b161c1d996c507f9b671a961831c8cd9987e807aa1"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a1553f4fe3c30431b7e4c14c4000050300fc4233abc8c378c2cf5e46b5979f2f"
    sha256 cellar: :any,                 arm64_monterey: "96ef7a5caba2f1a5a6072b2d228e907c1bae5db8939960b818c8d80e7c224a1b"
    sha256 cellar: :any,                 arm64_big_sur:  "77f6e514978c992257a8852ca1f285fa2812193f2ab1558e4fffbe97cf0d48a4"
    sha256 cellar: :any,                 ventura:        "7aaa540ec7c26f1760c518210c1bfeffebcc8f51d5d0367bf593819084653d18"
    sha256 cellar: :any,                 monterey:       "c39464a664a7a6e3a2ebc3d3dac1d44a40937fc300c6e9f721a15f2bc3599b72"
    sha256 cellar: :any,                 big_sur:        "17a975a672a3b5257668ef6116278573f9fcf11b78e03e076eb0bd9959901370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df5f1a858583d8a4c9428e7801b8e9bf561c8d88890da205ba99718c1db778b3"
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