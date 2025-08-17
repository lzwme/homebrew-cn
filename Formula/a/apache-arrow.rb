class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-21.0.0/apache-arrow-21.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-21.0.0/apache-arrow-21.0.0.tar.gz"
  sha256 "5d3f8db7e72fb9f65f4785b7a1634522e8d8e9657a445af53d4a34a3849857b5"
  license "Apache-2.0"
  revision 3
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "07539b37a03b02b3d45a4fdb4639f7f5a386ee86d67d27ec1c6add6f2c5cffc6"
    sha256 cellar: :any, arm64_sonoma:  "698385985a20a67400381c8520f49a1135d28b73306f9bffe491b015a60b117c"
    sha256 cellar: :any, arm64_ventura: "e5d2e7e690b7e0360479b5956bdb2efc67caa07b93a0fc43499e75af7d695e14"
    sha256 cellar: :any, sonoma:        "42caf2446c932e9e1e860b7c4e1b30804b53acd7aecc23c91069ae7e404be762"
    sha256 cellar: :any, ventura:       "55794797f517aaf8301fb26b9e5930d2dd8b3f3151650147e5eb3ec7677329e5"
    sha256               arm64_linux:   "378782df56e01e6ac91d630fe3f96a66b6f63b0167254a14de0111564f04fdda"
    sha256               x86_64_linux:  "dc1497980489ef0422bcec57f196004fd8c24f5c22c4fbb0cab34cbcba675b1b"
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
  uses_from_macos "zlib"

  # Issue ref: https://github.com/protocolbuffers/protobuf/issues/19447
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
    ]
    args << "-DARROW_MIMALLOC=ON" unless Hardware::CPU.arm?
    # Reduce overlinking. Can remove on Linux if GCC 11 issue is fixed
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{OS.mac? ? "-dead_strip_dylibs" : "--as-needed"}"
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
    ENV.method(DevelopmentTools.default_compiler).call if OS.linux?

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