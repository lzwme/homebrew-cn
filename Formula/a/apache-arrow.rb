class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-13.0.0/apache-arrow-13.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-13.0.0/apache-arrow-13.0.0.tar.gz"
  sha256 "35dfda191262a756be934eef8afee8d09762cad25021daa626eb249e251ac9e6"
  license "Apache-2.0"
  revision 6
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "f3b954b3af84c3e984e2a9b5f95a3f0ca98ab48f1262782d7068af14b068e557"
    sha256 cellar: :any, arm64_ventura:  "dcef7b28b3cbd3ca240b6c53cd9f764e5be8400fbb82fa56399d5d66e5661e34"
    sha256 cellar: :any, arm64_monterey: "48545780490f3e5487862f889e035351d8d982cd23d44506db6b43caeefe894e"
    sha256 cellar: :any, sonoma:         "b7ac6afda41ba35a4498722d8d27b32610c473db6488b9b61daa9f21302de464"
    sha256 cellar: :any, ventura:        "98175deb2d7c783b53af559a989479659466fbcbb22e530f67a4dbf6451e7a9b"
    sha256 cellar: :any, monterey:       "d26bc149bbdc4e07a4e721d680178ac762bcf6a97e2cd720f0c44e8e52f53f86"
    sha256               x86_64_linux:   "dcef6cead3cf7f92ee73ce40fa2c853960beb9040bc2020adb096b20c89cdbec"
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