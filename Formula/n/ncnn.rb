class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https:github.comTencentncnn"
  url "https:github.comTencentncnnarchiverefstags20250427.tar.gz"
  sha256 "9b5bfefd129f89d84d8e8aad0505166cbfaffdbc3721049ccafdee5fb41b464b"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comTencentncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f58cf5927b78838dfccf0719e4a07fa008d83b8a051b945e9f886a8d311cfb13"
    sha256 cellar: :any,                 arm64_sonoma:  "cc0b510dec956b1760c83a9f3ae396a4d7dcc5524726c9f0017505b0dd3d9537"
    sha256 cellar: :any,                 arm64_ventura: "d919d3837e9fc3278a2b3fb1cd46127fdd067b89bc4fdb4e11c018d204f66202"
    sha256 cellar: :any,                 sonoma:        "6e671c4926dd41ddf51c5a3612d4fd0f34f879d9619a0822f6bbf2f20845284e"
    sha256 cellar: :any,                 ventura:       "ed829e66b66c4cda20f7e9282c428e5534171911ee9d88eb6c7436629be7c343"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "280175e2acaae15a5d57ec65c100401be28f431d6c8dc18b2c7720db055842cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "169b4b6bd3b08d7e698e34b84eed1ac2bffaca4b27f07cdda6237247431ef3ae"
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