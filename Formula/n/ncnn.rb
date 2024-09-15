class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https:github.comTencentncnn"
  url "https:github.comTencentncnnarchiverefstags20240820.tar.gz"
  sha256 "21e7897c7a332894934800a15189915b5131dddc84b2c8d5669ff53de8c5efa4"
  license "BSD-3-Clause"
  revision 2
  head "https:github.comTencentncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4f40dce62661e5e3582d51dccc4c595102fdeacd9b9ceffa4e5644101b75cf77"
    sha256 cellar: :any,                 arm64_sonoma:  "05178f5ea36342bc0dff74ea9fd538655434aaa756ae2355ef5c655fae804fe9"
    sha256 cellar: :any,                 arm64_ventura: "bc2e76d85ab6ddaa993e546a2e73e61e06f6fe3325940e916e81349471b3a375"
    sha256 cellar: :any,                 sonoma:        "93646ad25ee50bf3eb763801af1b58160e9c3170c76f9e70bfe7b84221bc7d2f"
    sha256 cellar: :any,                 ventura:       "048aa9867816ab7e91ef9fba377e342b1c5becee68f74e41ecd6160c98d456ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "334761f9e17e03f90a61a8b5d5bcd4476ce638d12cf964dd3a08969045613ca6"
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