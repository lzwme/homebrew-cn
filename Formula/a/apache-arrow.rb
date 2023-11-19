class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-14.0.1/apache-arrow-14.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-14.0.1/apache-arrow-14.0.1.tar.gz"
  sha256 "5c70eafb1011f9d124bafb328afe54f62cc5b9280b7080e1e3d668f78c0e407e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f5ed273acd2f4a60117e5e7afbdfeafb4c8ae6beb00430ec97ea9de139e34262"
    sha256 cellar: :any, arm64_ventura:  "1d6da5b02cbe031b77b72e5d82d15acea7f265c9ac3eafc9cac2b6dcdffd53fb"
    sha256 cellar: :any, arm64_monterey: "de75cb0915998d0877aae89157de80928cd3a27e8feb9f8f555326b4531fc581"
    sha256 cellar: :any, sonoma:         "da79f9b9aa85bde2250077575877d255d4c6417bcd98066bcc3384bb92724870"
    sha256 cellar: :any, ventura:        "02b4cd6fd28ec5ddf1c55810b44b61074cceb78c9c9238ea4e7395d3cfc3e85d"
    sha256 cellar: :any, monterey:       "5b7501179a9431e96a76e7669f792cc8e475c1b24a21498fe73417ae50e6ab3e"
    sha256               x86_64_linux:   "f740e4e8c09c57abeac51204ada741e72d8fee4aed4650bea3cf3fff897c56ba"
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