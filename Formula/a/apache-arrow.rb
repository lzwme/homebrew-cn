class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-17.0.0apache-arrow-17.0.0.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-17.0.0apache-arrow-17.0.0.tar.gz"
  sha256 "9d280d8042e7cf526f8c28d170d93bfab65e50f94569f6a790982a878d8d898d"
  license "Apache-2.0"
  head "https:github.comapachearrow.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0445d1e1869d2f397207a734dda88c3d864f9156db8a22122b81f6f3552f53e3"
    sha256 cellar: :any,                 arm64_ventura:  "71a268fa8f11e4116def72b59b71d63ca2e75475be96f1e7f8b6206b50c77994"
    sha256 cellar: :any,                 arm64_monterey: "a96739f6a23ecb6e95af11f06e57caa3da088a86dee3362ba98e109037bcbf57"
    sha256 cellar: :any,                 sonoma:         "462b9ba5283196910774ea84847b5437f79846d3fe39957a69ad1b799fada955"
    sha256 cellar: :any,                 ventura:        "4c6150ba272575c11e6aa395d0054233f298f1e302b85eb160fc3e2fc1e9b0c1"
    sha256 cellar: :any,                 monterey:       "42aa9fe86396a58aaa41ac28d3c7b37cc745ea156395038d68c149c8b83cc970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df18a0f60b0b15533c007468299237d42f601f3d0c883e2242a080bca4bba2a3"
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