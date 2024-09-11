class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-17.0.0apache-arrow-17.0.0.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-17.0.0apache-arrow-17.0.0.tar.gz"
  sha256 "9d280d8042e7cf526f8c28d170d93bfab65e50f94569f6a790982a878d8d898d"
  license "Apache-2.0"
  revision 3
  head "https:github.comapachearrow.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b53b2634707f8a0da1d06e5f6773a4f8710e983533a853aacb15062a99cea83b"
    sha256 cellar: :any,                 arm64_sonoma:   "f15a4bc0a20f958e47c9a1477f73dfabe79fdabf30d6b89deb528ed733f235ad"
    sha256 cellar: :any,                 arm64_ventura:  "881e742f08c48512d08ccadbcd870f99919cbfa427ed69b4a08d829ee00859a9"
    sha256 cellar: :any,                 arm64_monterey: "8265f26c270d968665488884b6b5aa3adcacf6df93729dde6ba098441a66c9ff"
    sha256 cellar: :any,                 sonoma:         "ff50f0f8fcfc8dcc858a5b0d703f834eb8522736bb80eab15b5157f7b4342e9e"
    sha256 cellar: :any,                 ventura:        "099d1fac50d1c7baec433da4f7f0a99a52293dc487b78174ee10cb5f07cdc299"
    sha256 cellar: :any,                 monterey:       "3eb753cb5351d6d8c5208251c61531f0c50db20b80ac28631e3793d50c21fcff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5832c181b8dd8dad13e6e3fcc3ec245201cf4cb13616be8f0f99192b11474a6e"
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
  depends_on "llvm"
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

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    llvm = Formula["llvm"]
    ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm.opt_lib if DevelopmentTools.clang_build_version >= 1500

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