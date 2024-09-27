class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-17.0.0apache-arrow-17.0.0.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-17.0.0apache-arrow-17.0.0.tar.gz"
  sha256 "9d280d8042e7cf526f8c28d170d93bfab65e50f94569f6a790982a878d8d898d"
  license "Apache-2.0"
  revision 6
  head "https:github.comapachearrow.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ce9870d3799b306981f44e96247e5e5377687169debb6eeb34fc401a60ac9042"
    sha256 cellar: :any,                 arm64_sonoma:  "1b070fe1101d0de6ddfecccea0b19ef9ccf246808d837cf11595e836cc350601"
    sha256 cellar: :any,                 arm64_ventura: "7726324d6f517cdac48e447c65b8080e855ddfb9933e5820ef9b2037a89d006e"
    sha256 cellar: :any,                 sonoma:        "3026ad54172dc439e069081fcaee1bd504a5d889c1a6bb9b2fa39d0fc180b612"
    sha256 cellar: :any,                 ventura:       "a28915d72a40995169f20df65b7176c39b0e4849147f14787e1fd218f03dac4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ae71fafff579d70558d6e8422509ed4fd28cffc59c20e8672d1d5fcf0365c98"
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