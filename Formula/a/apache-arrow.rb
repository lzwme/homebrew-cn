class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-17.0.0apache-arrow-17.0.0.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-17.0.0apache-arrow-17.0.0.tar.gz"
  sha256 "9d280d8042e7cf526f8c28d170d93bfab65e50f94569f6a790982a878d8d898d"
  license "Apache-2.0"
  revision 7
  head "https:github.comapachearrow.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d3f0ff9e9407e9fac3d6ecc8ccdcdee769291b52e55c14c19adc34456de855bb"
    sha256 cellar: :any,                 arm64_sonoma:  "fd1f51ba3a37159b3461427274b434315fa218b46e4d72cb9b1b003ed69c0a4d"
    sha256 cellar: :any,                 arm64_ventura: "7ab5bd75b9801edd65f70028de6ae9238f182ef97d034f3b65fddf920a3c7a97"
    sha256 cellar: :any,                 sonoma:        "db6de98c846b157f4b0828573f8ae7c5cf6b9a384f5524d7efb524659f74924b"
    sha256 cellar: :any,                 ventura:       "d4f74e26cb6790228169d29a451b4061e8fb55c48e7d4f9f0ad07bebeb045049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f864b7ea967e82b09e5f58f5b04be541b7a199801135939eedda95ec8c030c5"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "abseil"
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "bzip2"
  depends_on "c-ares"
  depends_on "glog"
  depends_on "grpc"
  depends_on "llvm@18"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "rapidjson"
  depends_on "re2"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "utf8proc"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm.opt_lib if DevelopmentTools.clang_build_version >= 1500
    ENV.append "LDFLAGS", "-Wl,-rpath,#{llvm.opt_lib}" if OS.linux?

    # We set `ARROW_ORC=OFF` because it fails to build with Protobuf 27.0
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLVM_ROOT=#{llvm.opt_prefix}
      -DARROW_ACERO=ON
      -DARROW_COMPUTE=ON
      -DARROW_CSV=ON
      -DARROW_DATASET=ON
      -DARROW_FILESYSTEM=ON
      -DARROW_FLIGHT=ON
      -DARROW_FLIGHT_SQL=ON
      -DARROW_GANDIVA=ON
      -DARROW_HDFS=ON
      -DARROW_JSON=ON
      -DARROW_ORC=OFF
      -DARROW_PARQUET=ON
      -DARROW_PROTOBUF_USE_SHARED=ON
      -DARROW_S3=ON
      -DARROW_WITH_BZ2=ON
      -DARROW_WITH_ZLIB=ON
      -DARROW_WITH_ZSTD=ON
      -DARROW_WITH_LZ4=ON
      -DARROW_WITH_SNAPPY=ON
      -DARROW_WITH_BROTLI=ON
      -DARROW_WITH_UTF8PROC=ON
      -DARROW_INSTALL_NAME_RPATH=OFF
      -DPARQUET_BUILD_EXECUTABLES=ON
      -GNinja
    ]

    args << "-DARROW_MIMALLOC=ON" unless Hardware::CPU.arm?

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include "arrowapi.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system ".test"
  end
end