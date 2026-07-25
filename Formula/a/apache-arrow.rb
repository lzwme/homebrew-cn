class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-25.0.0/apache-arrow-25.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-25.0.0/apache-arrow-25.0.0.tar.gz"
  sha256 "12afc2dc8137bdd4a68876cec939f664c9d55cfc7b75f55b45163ebb4e344d81"
  license "Apache-2.0"
  revision 3
  compatibility_version 3
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "97d3c6e76eb846de0bd2b34a1e7cf3d8ae5ab5818e7086b9a205bba316069c87"
    sha256 cellar: :any, arm64_sequoia: "95f12e4cdfee2e45e355468600fda80e82d84d8c5407b56c6529af562bfef13c"
    sha256 cellar: :any, arm64_sonoma:  "4449528bcd6bde17caae8a7191fb0da050ec20b49db6edeb09e8a72b3e43ddd2"
    sha256 cellar: :any, sonoma:        "93120a2f9a34be1ae2e0e49b131de5fd0daa3e0705a4be36f748a814a6ec4568"
    sha256               arm64_linux:   "112f1fe552a3ffadb23f46cc4cdc72b164d6c9cc9d4b2892847247558bb73d2f"
    sha256               x86_64_linux:  "2f3faf18a7f5669c0290d2540cdd284684db29b281079403eec6c61a917bd2e4"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gflags" => :build
  depends_on "rapidjson" => :build
  depends_on "xsimd" => :build
  depends_on "abseil"
  depends_on "aws-crt-cpp"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc do
    version "12"
    cause "fails handling PROTOBUF_FUTURE_ADD_EARLY_WARN_UNUSED"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLVM_ROOT=#{formula_opt_prefix("llvm")}
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
    ]
    args << "-DARROW_MIMALLOC=ON" unless Hardware::CPU.arm?
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac? # Reduce overlinking
    # SVE bpacking kernel fails a static_assert; disable SVE runtime dispatch
    args << "-DARROW_RUNTIME_SIMD_LEVEL=NONE" if OS.linux? && Hardware::CPU.arm?

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "arrow/api.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end