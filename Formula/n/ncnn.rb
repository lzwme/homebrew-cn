class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https:github.comTencentncnn"
  url "https:github.comTencentncnnarchiverefstags20240102.tar.gz"
  sha256 "0770b0b4ccbcb2b4e5f38574bb6f1086b07d48958b10f289251e0359faa1d9cc"
  license "BSD-3-Clause"
  revision 4
  head "https:github.comTencentncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d168191e72ba4b169197606cccefae6cce2e025fcc2e7859831f648ad401eb34"
    sha256 cellar: :any,                 arm64_ventura:  "2fc27f914c11d045cd8ba66082389b604a03087aa2bd296d20138e659860c96d"
    sha256 cellar: :any,                 arm64_monterey: "50817fa773018260bfda01234a9eb7862fcbc67943f7067e756aff76e9bd3732"
    sha256 cellar: :any,                 sonoma:         "d4572b71234f7c62dcffc4e994a5e434729bf9aabb3464392262c3fa9677ff1a"
    sha256 cellar: :any,                 ventura:        "185a1769c06a69191a295d663f55546b555eece82a5b124e28bacd8c29d2adbc"
    sha256 cellar: :any,                 monterey:       "44a49c9d04142270e70a41fbfa4210565e118b6e493cf62f9fc2446f5b172e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "149793cdfa47c3e3687530c734f70137baa44347bf284a5aea69d5a3f15b3a38"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"

  on_macos do
    depends_on "vulkan-headers" => [:build, :test]
    depends_on "glslang"
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