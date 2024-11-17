class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-18.0.0apache-arrow-18.0.0.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-18.0.0apache-arrow-18.0.0.tar.gz"
  sha256 "abcf1934cd0cdddd33664e9f2d9a251d6c55239d1122ad0ed223b13a583c82a9"
  license "Apache-2.0"
  revision 1
  head "https:github.comapachearrow.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c2ae79cb2ea4afc9f882e657e38d5673bf5baa78f89c6bfa59bdf9bbbfd390e8"
    sha256 cellar: :any,                 arm64_sonoma:  "7fae9946652f09c39dfa5ce5482b4cdac00dc51b9000dec86450cde842ef76ec"
    sha256 cellar: :any,                 arm64_ventura: "b3a45e70c9affc7621a78f4af768a4e55da4297b96c1e9feba32788ff3f79f89"
    sha256 cellar: :any,                 sonoma:        "f385ef70b1050f8f2f99f276ff1a62974bbb363123abb6d8d6b85f63910785f9"
    sha256 cellar: :any,                 ventura:       "0513be261ef9aad86f512a7ea4e612fb520fda50096d5e96daa6d6b608f32503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "171a5c23a9f1fdba9e8098dd9d367ffaf1fcf9403c9255417205487510ae39cb"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gflags" => :build
  depends_on "ninja" => :build
  depends_on "rapidjson" => :build
  depends_on "xsimd" => :build
  depends_on "abseil"
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "grpc"
  depends_on "llvm"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "utf8proc"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "c-ares"
  end

  def install
    # We set `ARROW_ORC=OFF` because it fails to build with Protobuf 27.0
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLVM_ROOT=#{Formula["llvm"].opt_prefix}
      -DARROW_DEPENDENCY_SOURCE=SYSTEM
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
    (testpath"test.cpp").write <<~CPP
      #include "arrowapi.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system ".test"
  end
end