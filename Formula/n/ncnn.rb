class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://ghproxy.com/https://github.com/Tencent/ncnn/archive/refs/tags/20231027.tar.gz"
  sha256 "8d85896ed095d09f05fff32fc85d75eea0b971796ce0f48a9874d93d3d347674"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "35c5e0ee2f1eb3d7c7b15985164c690c80c037ee2d95e710179b87d73e0e5418"
    sha256 cellar: :any,                 arm64_ventura:  "d5c6ce4def8b0f3139876dd8e43d607da9ffee047dac6962a77fc71878e370fb"
    sha256 cellar: :any,                 arm64_monterey: "5f983cc31d726d66bbda3c5cff63332b3e0be2a244c3c6fd2f82cb5361689462"
    sha256 cellar: :any,                 sonoma:         "2fa6f3e778d80fc04928a20d9bfd71b2125accadbf7176ceac3a652cee05fb50"
    sha256 cellar: :any,                 ventura:        "a02e578ecd9e87fc6f8a6c8ff5791dea4f3a75d6082862976e2afcc3bad960ba"
    sha256 cellar: :any,                 monterey:       "9f046641c5b35a7526f373e1bc91982fc36eea1a4429181b20f860fbb63c98ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c4d9a3d52715b2041c143f3b7c06696f70146750fd656a3b5f00960439c3ac9"
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