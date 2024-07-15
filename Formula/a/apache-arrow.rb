class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-16.1.0apache-arrow-16.1.0.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-16.1.0apache-arrow-16.1.0.tar.gz"
  sha256 "c9e60c7e87e59383d21b20dc874b17153729ee153264af6d21654b7dff2c60d7"
  license "Apache-2.0"
  revision 3
  head "https:github.comapachearrow.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c45aa9c5fb6d966510c99931bac715718bc27cc0be9c4b97c7ecff4ad4e599b5"
    sha256 cellar: :any,                 arm64_ventura:  "46cd679a58cccc4bf7052a78cf55cfd6f130be794570c67d9f9cb5624f5fa9fa"
    sha256 cellar: :any,                 arm64_monterey: "57a7f0402d5b9376837aabf9499902e169ae6554c2a6f8fb486e0150f3564b38"
    sha256 cellar: :any,                 sonoma:         "aee9d2b18db6fbc8c4b10dfd275952c15397f4b0cc81ad75ed4fa59811d2d0ff"
    sha256 cellar: :any,                 ventura:        "6b2ee5b09f665f20ff3d94476b804d263d3f1862b9dd7c2f0223bdfd7623ced0"
    sha256 cellar: :any,                 monterey:       "893dca48280ba2fe358e60ecc4c93a70bf5c29e92929282cc55e0e052f16850c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f9ab14a08a0348ff31460a9c6c306dfd4a3d16f7323334283a35e52d58f7f6c"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "abseil"
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "bzip2"
  depends_on "c-ares"
  depends_on "glog"
  depends_on "grpc"
  depends_on "llvm"
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
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    llvm = Formula["llvm"]
    ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm.opt_lib if DevelopmentTools.clang_build_version >= 1500

    # We set `ARROW_ORC=OFF` because it fails to build with Protobuf 27.0
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLVM_ROOT=#{llvm.opt_prefix}
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
    (testpath"test.cpp").write <<~EOS
      #include "arrowapi.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system ".test"
  end
end