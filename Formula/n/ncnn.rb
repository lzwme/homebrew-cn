class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https:github.comTencentncnn"
  url "https:github.comTencentncnnarchiverefstags20240102.tar.gz"
  sha256 "0770b0b4ccbcb2b4e5f38574bb6f1086b07d48958b10f289251e0359faa1d9cc"
  license "BSD-3-Clause"
  head "https:github.comTencentncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "05a21dfcc877f32f170bda9046fa2656e959fc129d2b0e80a861ffa99da5f5b1"
    sha256 cellar: :any,                 arm64_ventura:  "e136bc8bd218ee61df560f3645cbbb375f7377fc0a9977f849d5f7e9cbeea970"
    sha256 cellar: :any,                 arm64_monterey: "1f7a5b1c16263eeeb3283a7d5ec371415e4add366fc6b1eafa62fec3b82bdb0d"
    sha256 cellar: :any,                 sonoma:         "ed450943d84ad23bbc448431b5515470de333aa1906076b0f86b95e92691ca6f"
    sha256 cellar: :any,                 ventura:        "7090bef317d818b1730eb26de9511de0e895d0d2f36f6314efb16aa6502279d2"
    sha256 cellar: :any,                 monterey:       "30d9c95a4554999272f233c5e7fdf9f173440614c565597e740aa737a82b66e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91267afcf48c1313b2806ba3d073a3cc55dfc6e1fd0b185350ea0521a29a3a43"
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
    # https:stackoverflow.coma55086637
    ENV.append "LDFLAGS", "-Wl,--copy-dt-needed-entries" if OS.linux?

    args = std_cmake_args + %w[
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_CXX_STANDARD_REQUIRED=ON
      -DNCNN_SHARED_LIB=ON
      -DNCNN_BUILD_BENCHMARK=OFF
      -DNCNN_BUILD_EXAMPLES=OFF
    ]

    if OS.mac?
      args += %W[
        -DNCNN_SYSTEM_GLSLANG=ON
        -DGLSLANG_TARGET_DIR=#{Formula["glslang"].opt_lib"cmake"}
        -DNCNN_VULKAN=ON
        -DVulkan_INCLUDE_DIR=#{Formula["molten-vk"].opt_include}
        -DVulkan_LIBRARY=#{Formula["molten-vk"].opt_libshared_library("libMoltenVK")}
      ]
    end

    inreplace "srcgpu.cpp", "glslangglslang", "glslang"
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <ncnnmat.h>

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
    system ".test"
  end
end