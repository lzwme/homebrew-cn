class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-16.1.0apache-arrow-16.1.0.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-16.1.0apache-arrow-16.1.0.tar.gz"
  sha256 "c9e60c7e87e59383d21b20dc874b17153729ee153264af6d21654b7dff2c60d7"
  license "Apache-2.0"
  head "https:github.comapachearrow.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "103672ff8c78fb9f3aebb1ad11135bb1769724106d3649ce3d0eeac2bf09aeae"
    sha256 cellar: :any,                 arm64_ventura:  "0b2b560b672645fa46b595732c4482944b4efbbb6f393286497d65a637c0abf7"
    sha256 cellar: :any,                 arm64_monterey: "314f72f8540aafac69ac159d2d813d0351c375c774074c9595a153ea4666158c"
    sha256 cellar: :any,                 sonoma:         "ebf666014bf6fd7ad98b4a565d3815b30a4f6eba7a584b1e52521405a09d7d08"
    sha256 cellar: :any,                 ventura:        "33d431b2ba3c66b1b37b45a490987e333d3d81ba47eaffbdbe8af295c62ba81c"
    sha256 cellar: :any,                 monterey:       "8437d1175ffb5d55ff3339dfb5233cea55cf7f43fc11a1c8b91623fceed3661c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dce891e8ce69e3b830a90e462790f77f4c8d3f5746364e502f1205274beec16"
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
    llvm = Formula["llvm"]
    ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm.opt_lib if DevelopmentTools.clang_build_version >= 1500

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