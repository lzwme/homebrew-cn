class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-15.0.2apache-arrow-15.0.2.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-15.0.2apache-arrow-15.0.2.tar.gz"
  sha256 "abbf97176db6a9e8186fe005e93320dac27c64562755c77de50a882eb6179ac6"
  license "Apache-2.0"
  revision 3
  head "https:github.comapachearrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "744efe8f7602b219e974ec89f028b2d96522915ba30c859572aacaef9f1a72d0"
    sha256 cellar: :any, arm64_ventura:  "e0f9cd1a7fe97e0972188c3ea967b65bba4545220d5cdf08cc52edd2e610eed0"
    sha256 cellar: :any, arm64_monterey: "d93573b391d94d6287bc6cda94f641ebed61e1e13431c0703a6f44f5a8e3b17f"
    sha256 cellar: :any, sonoma:         "fbad317cc877b7f3572a563d0591c395230d739c4239e51fc29e173ffba376db"
    sha256 cellar: :any, ventura:        "effe7f0860daabf8bc4e3d557415732865fde2d341ffe85fea64531e22c33ca2"
    sha256 cellar: :any, monterey:       "68e33a1da68ad277855ccb530e3cec0e0b1e90e9b4bf93c9da207d0c9bce048c"
    sha256               x86_64_linux:   "1e474abf4a4d4cea7c9f8a6f599e836c3c0f7d9bafa86f8b9e2e28aeac91b91b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "bzip2"
  depends_on "glog"
  depends_on "grpc"
  depends_on "llvm@17"
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
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm@17"].opt_lib if DevelopmentTools.clang_build_version >= 1500

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