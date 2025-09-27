class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://ghfast.top/https://github.com/Tencent/ncnn/archive/refs/tags/20250916.tar.gz"
  sha256 "7d463f1e5061facd02b8af5e792e059088695cdcfcc152c8f4892f6ffe5eab1a"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f3c332b4020e083dc259c53af4c2ff87d886ecfacf3b7ba952420d31d6346638"
    sha256 cellar: :any, arm64_sequoia: "c90419a93d75c87be4c82c71a5ec8709b55a82fa0f59ad21e42df9c4ba3c011d"
    sha256 cellar: :any, arm64_sonoma:  "9711cba60770b90541ce6f6fcb7a683d56889c81b7faaa28960ff386e5e594db"
    sha256 cellar: :any, sonoma:        "e2f1d06768912720579016b310c0a1f192f6bd8d2ea7dbef890844a995f2e70f"
    sha256               arm64_linux:   "706ea7b184bbaf7d6fc6cfa9edf1a78b07dd77088af2f271140ff8c0a1898604"
    sha256               x86_64_linux:  "dd8a54e29838f97106ad804127ad367bace7abe4f74f44676b3e63e6bb7753cc"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "glslang"
  depends_on "protobuf"

  on_macos do
    depends_on "libomp"
    depends_on "molten-vk"
    depends_on "spirv-tools"
  end

  on_linux do
    depends_on "vulkan-tools" => :test
  end

  def install
    # fix `libabsl_log_internal_check_op.so.2301.0.0: error adding symbols: DSO missing from command line` error
    # https://stackoverflow.com/a/55086637
    ENV.append "LDFLAGS", "-Wl,--copy-dt-needed-entries" if OS.linux?

    args = %W[
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_CXX_STANDARD_REQUIRED=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DNCNN_SHARED_LIB=ON
      -DNCNN_BUILD_BENCHMARK=OFF
      -DNCNN_BUILD_EXAMPLES=OFF
      -DNCNN_SYSTEM_GLSLANG=ON
      -DGLSLANG_TARGET_DIR=#{Formula["glslang"].opt_lib}/cmake
      -DNCNN_VULKAN=ON
    ]

    if OS.mac?
      args += %W[
        -DVulkan_INCLUDE_DIR=#{Formula["molten-vk"].opt_include}
        -DVulkan_LIBRARY=#{Formula["molten-vk"].opt_lib/shared_library("libMoltenVK")}
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    vulkan = 1
    if OS.linux?
      # Use a fake Vulkan ICD on Linux as it is lighter-weight than testing
      # with `vulkan-loader` and `mesa` (CPU/LLVMpipe) dependencies.
      ENV["VK_ICD_FILENAMES"] = Formula["vulkan-tools"].lib/"mock_icd/VkICD_mock_icd.json"
    elsif ENV["HOMEBREW_GITHUB_ACTIONS"] && Hardware::CPU.intel?
      # Don't test Vulkan on GitHub Intel macOS runners as they fail with: "vkCreateInstance failed -9"
      vulkan = 0
    end

    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <ncnn/gpu.h>
      #include <ncnn/mat.h>

      int main(void) {
          ncnn::Mat myMat = ncnn::Mat(500, 500);
          myMat.fill(1);
          ncnn::Mat myMatClone = myMat.clone();
          myMat.release();
          myMatClone.release();

      #if #{vulkan}
          ncnn::create_gpu_instance();
          assert(ncnn::get_gpu_count() > 0);
          ncnn::destroy_gpu_instance();
      #endif

          return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11",
                    "-I#{include}", "-L#{lib}", "-lncnn",
                    "-o", "test"
    system "./test"
  end
end