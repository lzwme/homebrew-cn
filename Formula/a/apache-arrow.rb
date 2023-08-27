class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-13.0.0/apache-arrow-13.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-13.0.0/apache-arrow-13.0.0.tar.gz"
  sha256 "35dfda191262a756be934eef8afee8d09762cad25021daa626eb249e251ac9e6"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "99494146f6d2017bd05115099220f49a6b872220152fd2a2eb60b1ed2d5b95c7"
    sha256 cellar: :any, arm64_monterey: "376314b366a9e595b7b74d0c624053a3499e4c00597ea7942e1fa626f2451b43"
    sha256 cellar: :any, arm64_big_sur:  "bab1a70c84625d3be30629dc695ac9e8087c0149f863b3f0e9af4b4399b3b538"
    sha256 cellar: :any, ventura:        "1c107401475572ff57e21a5f5037b2323f8b524eb8087faabd2824dd6f65868d"
    sha256 cellar: :any, monterey:       "c4fb5cb9372e281bfcc061fa0958d012e1412c3f651c0efb9a1b27882fce35cb"
    sha256 cellar: :any, big_sur:        "a42f9121da72f5049386d17b0ea6180b9f89f6ebfdb283009280686eb05abe02"
    sha256               x86_64_linux:   "3e3abf379dbee14ef98a61b776333e936801e84ddb1693e95876c3124299a0ff"
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