class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https:github.comTencentncnn"
  url "https:github.comTencentncnnarchiverefstags20240820.tar.gz"
  sha256 "21e7897c7a332894934800a15189915b5131dddc84b2c8d5669ff53de8c5efa4"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comTencentncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d9a2419af4c2b488a7547ec88a5f6596871d41944288a674bfc8ab72fe88ab5c"
    sha256 cellar: :any,                 arm64_ventura:  "a210aac4bc14c81973e6b745eed9d4900252ff2731ecf74c81d0309f0aa123ed"
    sha256 cellar: :any,                 arm64_monterey: "df8a74b93d8db0f9a87935c3133c2a881ada9e321820131d361c8a6abbb7cd8b"
    sha256 cellar: :any,                 sonoma:         "5d261234b1e6dc2ec97ee43dc0b2f3693bdd1725b6a29dd642ef0551e72eb491"
    sha256 cellar: :any,                 ventura:        "428ff9ef964293d46f81e8a6899272198b87dcff0a0366ba061214386dd98343"
    sha256 cellar: :any,                 monterey:       "5b1ac4686398ca3d101aaf01e0e200190e68ab159d110343c501b085269349c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdea38aa95b8ecbee9fc264f0fc86757e07d49066bc62dcd3c93256f35d2ba03"
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