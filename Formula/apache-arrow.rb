class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-11.0.0/apache-arrow-11.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-11.0.0/apache-arrow-11.0.0.tar.gz"
  sha256 "2dd8f0ea0848a58785628ee3a57675548d509e17213a2f5d72b0d900b43f5430"
  license "Apache-2.0"
  revision 2
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "1e82ceb62855281d1577da1af98ebc4f3b7752e434d64ab7770b14ba71c9f4ea"
    sha256 cellar: :any, arm64_monterey: "589f203391674714dc8e82e8ddb15f2150a38a0f49d88426e9636028967814fb"
    sha256 cellar: :any, arm64_big_sur:  "5fc70de9056612b260c325a858430affb1ae253ac97cabd77d3b1da0f194b7a9"
    sha256 cellar: :any, ventura:        "6502e207d95504789a339b6921c4a015c0baaa61988bc6c6a72f77be4e51cad3"
    sha256 cellar: :any, monterey:       "c4672c2a8f24154a60d75bcadd109dbfa7390ff6dbf54aec63cc30f18f8f9387"
    sha256 cellar: :any, big_sur:        "8fde4aa99bc619e843be7873682b80fe111898c195429e03df1f67ca9442c5aa"
    sha256               x86_64_linux:   "c91cd3ecaeb072983e16844b82a07c19b03020d81bc67d0deceebf8410cff866"
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
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "rapidjson"
  depends_on "re2"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "utf8proc"
  depends_on "z3"
  depends_on "zstd"
  uses_from_macos "python" => :build

  fails_with gcc: "5"

  def install
    # https://github.com/Homebrew/homebrew-core/issues/76537
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
      -DARROW_PLASMA=ON
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