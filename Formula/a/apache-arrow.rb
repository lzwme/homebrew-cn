class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-14.0.1apache-arrow-14.0.1.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-14.0.1apache-arrow-14.0.1.tar.gz"
  sha256 "5c70eafb1011f9d124bafb328afe54f62cc5b9280b7080e1e3d668f78c0e407e"
  license "Apache-2.0"
  revision 2
  head "https:github.comapachearrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "6ac14a1a1b5be3d5ba95103936cc2e1830f17972dfa1d4b5179067d616d8aa34"
    sha256 cellar: :any, arm64_ventura:  "b77aa80bf977f0949f6279d4d01151f66d71b8b6451fb64c8b416fe3a19bfb3d"
    sha256 cellar: :any, arm64_monterey: "24d57fe7a8ffa30ea5a96d09d3ee9386e196b174e7f59295ef0e3e17408b40cc"
    sha256 cellar: :any, sonoma:         "ff533359f689f2f864558bf1f24cc4bd65ca1b84584fa9ab719070c3be89bd02"
    sha256 cellar: :any, ventura:        "ec67b1bc8c3de8611d3576103b94e5e51e8094348c092a51dadab4f239fec615"
    sha256 cellar: :any, monterey:       "e83675dfa9f4003cb51f08fe1b92d4ea1d1af62fdedf2bdb79c957f2db9cd7a4"
    sha256               x86_64_linux:   "1bd40320f7c5ef048351817c7bdcd22c684c2ba7824f1cd1dce71c3211df769a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "bzip2"
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

  fails_with gcc: "5"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib if DevelopmentTools.clang_build_version >= 1500

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