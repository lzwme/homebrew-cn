class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-18.1.0apache-arrow-18.1.0.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-18.1.0apache-arrow-18.1.0.tar.gz"
  sha256 "2dc8da5f8796afe213ecc5e5aba85bb82d91520eff3cf315784a52d0fa61d7fc"
  license "Apache-2.0"
  revision 1
  head "https:github.comapachearrow.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9158e6fc07d81069c123993a446ddda39c2ec00a1b74ea02e457b95efdff4a18"
    sha256 cellar: :any,                 arm64_sonoma:  "922fb3b4cb068647b2311f0553ab77ea847076481a904abd301ce3f060c9a854"
    sha256 cellar: :any,                 arm64_ventura: "5e1b5e7add3e5eca7dfea73aa952648d38bb4c64441c6aaf75e65513211134ca"
    sha256 cellar: :any,                 sonoma:        "0551a841c14bb4dd64180836f2ca69fac7ea35a5dc78c6e44b58a4eae723244a"
    sha256 cellar: :any,                 ventura:       "d6ccf02cacfd6c1b5556c35f2627bfbbcc0304c0ce41e73f417405662ed4639a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb6d8b5f40cb6a4f3565ee03c667e666e50f498a57c08f6319a0df37c8d09e52"
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
  depends_on "c-ares"
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

  # Issue ref: https:github.comprotocolbuffersprotobufissues19447
  fails_with :gcc do
    version "12"
    cause "Protobuf 29+ generated code with visibility and deprecated attributes needs GCC 13+"
  end

  def install
    ENV.llvm_clang if OS.linux?

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
    ENV.method(DevelopmentTools.default_compiler).call if OS.linux?

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