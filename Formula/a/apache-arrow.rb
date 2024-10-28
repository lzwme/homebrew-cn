class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https:arrow.apache.org"
  license "Apache-2.0"
  revision 10
  head "https:github.comapachearrow.git", branch: "main"

  stable do
    url "https:www.apache.orgdyncloser.lua?path=arrowarrow-17.0.0apache-arrow-17.0.0.tar.gz"
    mirror "https:archive.apache.orgdistarrowarrow-17.0.0apache-arrow-17.0.0.tar.gz"
    sha256 "9d280d8042e7cf526f8c28d170d93bfab65e50f94569f6a790982a878d8d898d"

    # Backport support for LLVM 19
    patch do
      url "https:github.comapachearrowcommit3505457946192ef2ee0beac3356d9c0ed0d22b0f.patch?full_index=1"
      sha256 "60793569736ebc72ecddcd06443cf281342d7fa81b5d4727152247f2cb7ad58a"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0091360aca8939984ba5b15f08bc0b5cd71be67f8eca5ed23629cb36320c209"
    sha256 cellar: :any,                 arm64_sonoma:  "765ecdbe29732c0bdb3ec1a9f4161c82c9cef27dfb867ffb3fad98b97d3dcd57"
    sha256 cellar: :any,                 arm64_ventura: "acf7a350b062dd0752537e051970e9f8c0a4908bdea2ae388398babc03632e48"
    sha256 cellar: :any,                 sonoma:        "7dc87c7f997588c60fe06a58efd2bc973f7f4b0ef9a5d49cd076fef35b78d01e"
    sha256 cellar: :any,                 ventura:       "776aeab2e582b7a69b8d23f481818007326a4950587c3ced7fc11b2b15b71d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ad62c7a30b1526190fa418f58176c1a46c8073a6c23ab9f6dcf164b9d70a3b6"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gflags" => :build
  depends_on "ninja" => :build
  depends_on "rapidjson" => :build
  depends_on "xsimd" => :build
  depends_on "abseil"
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

  on_macos do
    depends_on "c-ares"
  end

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
      -GNinja
    ]

    args << "-DARROW_MIMALLOC=ON" unless Hardware::CPU.arm?

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
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