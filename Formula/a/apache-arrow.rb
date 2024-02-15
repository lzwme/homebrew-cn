class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-15.0.0apache-arrow-15.0.0.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-15.0.0apache-arrow-15.0.0.tar.gz"
  sha256 "01dd3f70e85d9b5b933ec92c0db8a4ef504a5105f78d2d8622e84279fb45c25d"
  license "Apache-2.0"
  revision 1
  head "https:github.comapachearrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "96c2b456c923785788f276b5d85b413a892ae6343e48570380078f3c70782721"
    sha256 cellar: :any, arm64_ventura:  "cf352e06bffb6b3724327150991bf2dee087dd96c05348aefdeee0a26facf6ee"
    sha256 cellar: :any, arm64_monterey: "a1814aa2019a80ada4fdf259bab917a3179521d67c79fc386484fde84cacc264"
    sha256 cellar: :any, sonoma:         "d74860dfbe8bdd44ec8e7609de0deaf303b3047c76c4bd1b078b2929add970b5"
    sha256 cellar: :any, ventura:        "a1abe546bde2c06be0a9b64c54a0512afab22c56bdeb8da7ce0f186ac91d9c68"
    sha256 cellar: :any, monterey:       "ee5656b7272e70ea8ec62ef76950a034b6d8e9b2cc3270f93661a21bd0cbaeed"
    sha256               x86_64_linux:   "befbe4d278eea0c9acbc0e9bb07c3da7717953e94edbc56739b032478003b4e5"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
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