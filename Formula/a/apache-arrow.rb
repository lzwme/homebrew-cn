class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-15.0.2apache-arrow-15.0.2.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-15.0.2apache-arrow-15.0.2.tar.gz"
  sha256 "abbf97176db6a9e8186fe005e93320dac27c64562755c77de50a882eb6179ac6"
  license "Apache-2.0"
  revision 2
  head "https:github.comapachearrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "6af487e2c04f55015dd3275cdc89b57fe843afd2721bf0735272fef91e85c6f1"
    sha256 cellar: :any, arm64_ventura:  "eb183e1a97988fe4f095ae8dabd6bb8a657249e36ab6b9478255bbd7a95567b8"
    sha256 cellar: :any, arm64_monterey: "4d9108c2c3d2ad54ef9fb12acab525f0bae7674b09b2c4cfc360e093e8ef329e"
    sha256 cellar: :any, sonoma:         "e1254f7fb473eecbf67b8ef8fb6197725f6ed6dfb9e7ced08030db0d5c8cac2e"
    sha256 cellar: :any, ventura:        "311c9b58c7416517f5a7f2a05b418a71e6e1566d4c5d1d6690dbc875e364fa92"
    sha256 cellar: :any, monterey:       "83cd9dd8d9e19ec13e50973e68cbaca9ed6e34b4ba39a55b5f4c1eb7ee70c030"
    sha256               x86_64_linux:   "e2b4742219a35a41cd51c270c6036f2e6c89f80a6ec230e4a621444544a7f930"
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