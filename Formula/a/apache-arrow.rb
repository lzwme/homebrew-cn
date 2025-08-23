class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-21.0.0/apache-arrow-21.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-21.0.0/apache-arrow-21.0.0.tar.gz"
  sha256 "5d3f8db7e72fb9f65f4785b7a1634522e8d8e9657a445af53d4a34a3849857b5"
  license "Apache-2.0"
  revision 5
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "eba5d4c9a454c16ded50064c80bb320f90ba445eca8c77c6017eb7cde2a8c504"
    sha256 cellar: :any, arm64_sonoma:  "af749d9e8df7978ac004bcf05c38f4a6ba507f104580e2059389135a689cb011"
    sha256 cellar: :any, arm64_ventura: "fc6d23d58ccc71935689628183b3aa840c66b1ff5b9abeb3b5d7977dd542a716"
    sha256 cellar: :any, sonoma:        "507bffe11e9ae71a249e4850efe8a456460a76f10de7ad6284bd1c70f5839bba"
    sha256 cellar: :any, ventura:       "a3b31372594423387c0a0bd459742b59f0514362171bc4d3f62d0747003d3fd2"
    sha256               arm64_linux:   "f7c33c06cc5a2e7c4150bf09be9768487fa871f330205b3a9f4e711965c03ba1"
    sha256               x86_64_linux:  "daa359dbdab868134e045b05eea76d9b227cff4137bca8e615b859dbadd28c2c"
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
  depends_on "llvm@20"
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

  def install
    # We set `ARROW_ORC=OFF` because it fails to build with Protobuf 27.0
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLVM_ROOT=#{Formula["llvm@20"].opt_prefix}
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
    args << if OS.mac?
      "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" # Reduce overlinking
    else
      "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON" # Avoid versioned LLVM RPATH getting dropped
    end
    # ARROW_SIMD_LEVEL sets the minimum required SIMD. Since this defaults to
    # SSE4.2 on x86_64, we need to reduce level to match oldest supported CPU.
    # Ref: https://arrow.apache.org/docs/cpp/env_vars.html#envvar-ARROW_USER_SIMD_LEVEL
    if build.bottle? && Hardware::CPU.intel? && (!OS.mac? || !MacOS.version.requires_sse42?)
      args << "-DARROW_SIMD_LEVEL=NONE"
    end

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
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end