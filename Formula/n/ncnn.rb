class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://ghfast.top/https://github.com/Tencent/ncnn/archive/refs/tags/20260526.tar.gz"
  sha256 "da1ade826bc22858a9fb87ae052789bbd614d042b3ec2c22e6544ca83db6bc04"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f6ed08abf4582b618dcb375d3debb0384924aca2f8ca0330bdc275a45a172b79"
    sha256 cellar: :any, arm64_sequoia: "83e688f130e67f31674dd0cfad5bd47fecb04d05205e0031506bfce62d14fd05"
    sha256 cellar: :any, arm64_sonoma:  "24f917966570835505cedd2df8e3441a8a4f8b4568cf69866af69afbf0fddf1d"
    sha256 cellar: :any, sonoma:        "2ea3fbbe9fec96fc38533d7004985b042adbbc4fa47eb1e5864628ef63717246"
    sha256               arm64_linux:   "f9103a48addefe3beb7577d5aea62a27d4cebd9071089fec359b6224831a08d5"
    sha256               x86_64_linux:  "1db8448726fe008e6d540bd7913d7cd257cb2dbb413a2205676450370685ea06"
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
      -DGLSLANG_TARGET_DIR=#{formula_opt_lib("glslang")}/cmake
      -DNCNN_VULKAN=ON
    ]

    if OS.mac?
      args += %W[
        -DVulkan_INCLUDE_DIR=#{formula_opt_include("molten-vk")}
        -DVulkan_LIBRARY=#{formula_opt_lib("molten-vk")/shared_library("libMoltenVK")}
      ]

      # Apple Clang 16 crashes compiling AVX-VNNI(-INT8) and AVX-512(BF16/FP16) intrinsics.
      # No Intel Mac CPU supports these extensions anyway.
      if Hardware::CPU.intel?
        args += %w[
          -DNCNN_AVXVNNI=OFF
          -DNCNN_AVXNECONVERT=OFF
          -DNCNN_AVX512BF16=OFF
          -DNCNN_AVX512FP16=OFF
        ]
      end
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
    elsif Hardware::CPU.arm? && MacOS.version == :sonoma
      # Disable Metal argument buffers for macOS Sonoma on arm
      ENV["MVK_CONFIG_USE_METAL_ARGUMENT_BUFFERS"] = "0"
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