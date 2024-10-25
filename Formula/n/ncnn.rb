class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https:github.comTencentncnn"
  url "https:github.comTencentncnnarchiverefstags20240820.tar.gz"
  sha256 "21e7897c7a332894934800a15189915b5131dddc84b2c8d5669ff53de8c5efa4"
  license "BSD-3-Clause"
  revision 5
  head "https:github.comTencentncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0fc6f36f40ac00a3093b6257a150026398c5ae5304992f103bdc45cf74a253dd"
    sha256 cellar: :any,                 arm64_sonoma:  "bc0120683ef6d55f797dd26f639e860681544d3588f9b28a8cfedf110b0998d2"
    sha256 cellar: :any,                 arm64_ventura: "5bb3b572b66031afc1afa5fad37dbb408a2cf7139d94bb25233eceb3c9dbb18a"
    sha256 cellar: :any,                 sonoma:        "b0ba0c2e85cd0ee075c6f856d7435217b15d6f84d2a24c0cb12c32abc454473b"
    sha256 cellar: :any,                 ventura:       "3f465221ec5d7c109e3a966410e22aabf5e241325312f309d3e009b68d378ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3741ad723827b237a044ae3126c60be1c4a149c58c00ef016b792b6b1b87abc0"
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

    (testpath"test.cpp").write <<~EOS
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
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11",
                    "-I#{include}", "-L#{lib}", "-lncnn",
                    "-o", "test"
    system ".test"
  end
end