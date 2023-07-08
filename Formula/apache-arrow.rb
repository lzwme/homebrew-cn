class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-12.0.1/apache-arrow-12.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-12.0.1/apache-arrow-12.0.1.tar.gz"
  sha256 "3481c411393aa15c75e88d93cf8315faf7f43e180fe0790128d3840d417de858"
  license "Apache-2.0"
  revision 3
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "0e4255b8cf645d008e003b19a4c7dd54784d2140c04deab963a8d7e324ceffc4"
    sha256 cellar: :any, arm64_monterey: "12dd824c0cf719e567951885e5308452d3a86e44a330ba82282ce2dc7bb460e4"
    sha256 cellar: :any, arm64_big_sur:  "e7c880f279a203e965d41e5257eb8ad083bb6a8ab5c5c33ca83be42f845d7c61"
    sha256 cellar: :any, ventura:        "0b833b8807d0fe83b684d333398627e389115a512e9ba49150ef5241e7624021"
    sha256 cellar: :any, monterey:       "7c554a419d30c56a5f5b42e2db9f48187b0c4f88f85290612355e2a5a48694b6"
    sha256 cellar: :any, big_sur:        "cac9d80c257f6983ea74f2607e67686ead172bf4f84f80ef79824cbcc3f9f9a8"
    sha256               x86_64_linux:   "cd0e254cd30343e81336d814cd9fb2fe110f52a5ed55ed3f4c450ea16fffe618"
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