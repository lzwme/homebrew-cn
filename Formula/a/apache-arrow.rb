class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-18.1.0apache-arrow-18.1.0.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-18.1.0apache-arrow-18.1.0.tar.gz"
  sha256 "2dc8da5f8796afe213ecc5e5aba85bb82d91520eff3cf315784a52d0fa61d7fc"
  license "Apache-2.0"
  revision 6
  head "https:github.comapachearrow.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "839c246eae02896257c3ea5e21814e70dbd68f2616e08672cc901c8df2fb5128"
    sha256 cellar: :any,                 arm64_sonoma:  "91907f0fe9d62eb0d4bab3bb64997aec4774fb71998007516953b6f8376f740b"
    sha256 cellar: :any,                 arm64_ventura: "8a82c7da56b9041a92264337db3c1f99da7b5ebb84856c0d44842e3d61d226ce"
    sha256 cellar: :any,                 sonoma:        "5ef8cc307319af3054406c48db5c9ba06d4c50d9bcfa0ca185a6d802e14edf6b"
    sha256 cellar: :any,                 ventura:       "4c040f0723b9eb2cdb1fd5c9c773407fbaa7b1926d350d8fea669be86372ec3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82c50ad1238be66720786e2de996522e191a1c5939843d1c9b0d6f5f56cd92dd"
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
    ]
    args << "-DARROW_MIMALLOC=ON" unless Hardware::CPU.arm?
    # Reduce overlinking. Can remove on Linux if GCC 11 issue is fixed
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{OS.mac? ? "-dead_strip_dylibs" : "--as-needed"}"
    # ARROW_SIMD_LEVEL sets the minimum required SIMD. Since this defaults to
    # SSE4.2 on x86_64, we need to reduce level to match oldest supported CPU.
    # Ref: https:arrow.apache.orgdocscppenv_vars.html#envvar-ARROW_USER_SIMD_LEVEL
    if build.bottle? && Hardware::CPU.intel? && (!OS.mac? || !MacOS.version.requires_sse42?)
      args << "-DARROW_SIMD_LEVEL=NONE"
    end

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