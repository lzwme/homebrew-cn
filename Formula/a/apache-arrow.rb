class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-14.0.0/apache-arrow-14.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-14.0.0/apache-arrow-14.0.0.tar.gz"
  sha256 "4eb0da50ec071baf15fc163cb48058931e006f1c862c8def0e180fd07d531021"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "d940202aa3b2b38cc4547eb7d0beec915c0558c293b6ce1d737670416f36525e"
    sha256 cellar: :any, arm64_ventura:  "8c2f970e1d4bccc5e82da1a24efd14655bcec2f4a18ed137094fe6c1ec98f5a4"
    sha256 cellar: :any, arm64_monterey: "4e421aca88ce071ba041081c65b9b99233f2c2418842a65f343b3678a7ae0e95"
    sha256 cellar: :any, sonoma:         "002329b2326050b0c7aba5c95fea4567e223a316ca7f40689fa9867e5e87234d"
    sha256 cellar: :any, ventura:        "39efd5bc61675e23bf5d8805bc7d1378280b1c3a6e423fd483a24289b7408973"
    sha256 cellar: :any, monterey:       "a76d9e31f6123e4e46404e4418f18a8efbf72365f29776ecc868e77e0a6fa742"
    sha256               x86_64_linux:   "76081459f399cf8bd7abb1e908972ef0f8190d552e015d805d6f25f6b067151b"
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