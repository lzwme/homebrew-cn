class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-13.0.0/apache-arrow-13.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-13.0.0/apache-arrow-13.0.0.tar.gz"
  sha256 "35dfda191262a756be934eef8afee8d09762cad25021daa626eb249e251ac9e6"
  license "Apache-2.0"
  revision 5
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "1c21591bf695940813cf1521b1b27a1c413725321fc2699b3883ee7e883c2cc3"
    sha256 cellar: :any, arm64_monterey: "020830d3e4361a422d07d1a6b45ed3a63c3f438a2817b86655a496f75ad72b4a"
    sha256 cellar: :any, arm64_big_sur:  "176bd305a331db8a650419c4b1490e5654867dccee7841cd5e7bf8b8d9b6560e"
    sha256 cellar: :any, ventura:        "a3fbb2b0e0f90e2541d737c99f71d6c4162242787a44edffc0b3980b1bf5fe4b"
    sha256 cellar: :any, monterey:       "ca963f96717fca429603b40dfa4660cad7f8ed8d5aed70f80daa3790352e80a5"
    sha256 cellar: :any, big_sur:        "f349a0a21abb673a83feeb1a659c5b17e97e03f2cd115bd095938ae1e20a35d1"
    sha256               x86_64_linux:   "485008e97d24e1303daaf53cc97741b1297e781ad2237765f002e58d281d64ec"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "llvm@15" => :build
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "bzip2"
  depends_on "glog"
  depends_on "grpc"
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

  fails_with gcc: "5"

  def install
    # https://github.com/Homebrew/homebrew-core/issues/76537
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
      -DARROW_ORC=ON
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
    ]

    args << "-DARROW_MIMALLOC=ON" unless Hardware::CPU.arm?

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "arrow/api.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end