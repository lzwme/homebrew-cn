class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https:github.comTencentncnn"
  url "https:github.comTencentncnnarchiverefstags20241226.tar.gz"
  sha256 "2a9f224aab5f016ce790d0bb4f90c495ce4ed5620a9617e4ca522cbc5ca331d1"
  license "BSD-3-Clause"
  head "https:github.comTencentncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "731c86cc2ae64a543ca8c4e50787aa67f8d6777abc5494e4b1d2a522e7426c9f"
    sha256 cellar: :any,                 arm64_sonoma:  "004b65f6a28a2463abbe3c373a537621c74aa8188a4e2b66677ea11457c6a822"
    sha256 cellar: :any,                 arm64_ventura: "ef6c36b31e7f177c535869e2113badc762dccb0d77d4ebd3f61476bad6204d15"
    sha256 cellar: :any,                 sonoma:        "f64b4b7a1d015514f3737e7edc902c4abd882cf156185683630f5ed723831fe9"
    sha256 cellar: :any,                 ventura:       "cb62c3375e3b2ce327e6a200cc8f7fca75e3af2ef74cf3a6b46011f0c628ed22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f5dafdb5b5d51e69997a683d79c35aa6481354ece1ceba8cf6bf138e29cb090"
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
    # https:stackoverflow.coma55086637
    ENV.append "LDFLAGS", "-Wl,--copy-dt-needed-entries" if OS.linux?

    args = %W[
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_CXX_STANDARD_REQUIRED=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DNCNN_SHARED_LIB=ON
      -DNCNN_BUILD_BENCHMARK=OFF
      -DNCNN_BUILD_EXAMPLES=OFF
      -DNCNN_SYSTEM_GLSLANG=ON
      -DGLSLANG_TARGET_DIR=#{Formula["glslang"].opt_lib}cmake
      -DNCNN_VULKAN=ON
    ]

    if OS.mac?
      args += %W[
        -DVulkan_INCLUDE_DIR=#{Formula["molten-vk"].opt_include}
        -DVulkan_LIBRARY=#{Formula["molten-vk"].opt_libshared_library("libMoltenVK")}
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
      # with `vulkan-loader` and `mesa` (CPULLVMpipe) dependencies.
      ENV["VK_ICD_FILENAMES"] = Formula["vulkan-tools"].lib"mock_icdVkICD_mock_icd.json"
    elsif ENV["HOMEBREW_GITHUB_ACTIONS"] && Hardware::CPU.intel?
      # Don't test Vulkan on GitHub Intel macOS runners as they fail with: "vkCreateInstance failed -9"
      vulkan = 0
    end

    (testpath"test.cpp").write <<~CPP
      #include <cassert>
      #include <ncnngpu.h>
      #include <ncnnmat.h>

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
    system ".test"
  end
end