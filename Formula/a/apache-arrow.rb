class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-14.0.1/apache-arrow-14.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-14.0.1/apache-arrow-14.0.1.tar.gz"
  sha256 "5c70eafb1011f9d124bafb328afe54f62cc5b9280b7080e1e3d668f78c0e407e"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "568cfce3d0f8aabe7a94d817eeadc255f1bcf5fb8eb2a8d9da341848b75a55a6"
    sha256 cellar: :any, arm64_ventura:  "6b5414d793ee54e70c8cb2df3da3c59710a4a4053a57048f5a1ba149997894ab"
    sha256 cellar: :any, arm64_monterey: "be49e00bc810ce675f5fc2231dda9c06885c7b4a0fe770809effa6b77023640a"
    sha256 cellar: :any, sonoma:         "2213ab5f3497900212cadd20164debc83cde123ba4385538acc7141a9eebbdab"
    sha256 cellar: :any, ventura:        "3387794e89d6d92fa9effc443411fb42ed50f3cd3b724e3071fc07f7b517a6e2"
    sha256 cellar: :any, monterey:       "162063bd1958f39a16a02394e955dbd473bf7a9608e529dabc4dcffad6dac938"
    sha256               x86_64_linux:   "e50b4e85c1c5d2199899830b0c7423362bb6b5d4f0fc3d8cbc67cbccebb4cb24"
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
    (testpath/"test.cpp").write <<~EOS
      #include "arrow/api.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end