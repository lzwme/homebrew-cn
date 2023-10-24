class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-13.0.0/apache-arrow-13.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-13.0.0/apache-arrow-13.0.0.tar.gz"
  sha256 "35dfda191262a756be934eef8afee8d09762cad25021daa626eb249e251ac9e6"
  license "Apache-2.0"
  revision 9
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "28e3301927803f55f51a9dfcfe74dd32546b16e8aa8263c8a3b54e43834d251a"
    sha256 cellar: :any, arm64_ventura:  "76b598b55f84510a98d661c95babb4dc59e699ea847159a0f7a000919d741505"
    sha256 cellar: :any, arm64_monterey: "51602553131867876f26a54953b2ef91643258db72d5a6921f99997652b8d287"
    sha256 cellar: :any, sonoma:         "16c7790dcca823405ba702e312264e787a17e90995ab3a251f88c437be9b14cd"
    sha256 cellar: :any, ventura:        "2960dcdc32d593070ba7c12717f4b1a1e201c2df767e25e8a69eb2d62a845cf8"
    sha256 cellar: :any, monterey:       "7389cefc28aafcde821bca5757048f33380eb8bda4f13405e9177898c4bcfdcd"
    sha256               x86_64_linux:   "37e9e833a58a7ad4769575183809f8959c6b2c5dbce99ba60b412e55e116a099"
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

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm@15"].opt_lib

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