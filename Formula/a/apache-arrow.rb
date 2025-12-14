class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "main"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-22.0.0/apache-arrow-22.0.0.tar.gz"
    mirror "https://archive.apache.org/dist/arrow/arrow-22.0.0/apache-arrow-22.0.0.tar.gz"
    sha256 "131250cd24dec0cddde04e2ad8c9e2bc43edc5e84203a81cf71cf1a33a6e7e0f"

    # Backport fix for `ARROW_SIMD_LEVEL=NONE`
    patch do
      url "https://github.com/apache/arrow/commit/00245cc802bc3be9a9cd169017f285586483fbb5.patch?full_index=1"
      sha256 "fb692196f928401bb8aca93f9a7af7e028f65705c170f31a300728b041a07a71"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2fa06988f94fcc06f9c31a3ad785276d260776c9b9e85fac18bdbc0f1c8daffa"
    sha256 cellar: :any, arm64_sequoia: "2bc99aef0ae9f336eed981d92c5458360e402e0c3e2b842465a0b5c72d1b2a9c"
    sha256 cellar: :any, arm64_sonoma:  "d36687dcf1bb6b1f47e0144e634ffbf6e2f6efb042057a1bb42b9c7b2c6502b8"
    sha256 cellar: :any, sonoma:        "3bcfd83bdec667a867eeff99ca48ee6d25d2eed08f71a5183a87b2365009b416"
    sha256               arm64_linux:   "0130c2c6619dc43c126f0dae657c9abb31a8c48181122117c29221d2217581c8"
    sha256               x86_64_linux:  "2d1760f034a70cccde5ae05b939b79381ff92250161042f62cd2a00a058bf4b1"
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