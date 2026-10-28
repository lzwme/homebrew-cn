class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.44.2.tar.gz"
  sha256 "5d959527f1e91db1410627755fc9a2c9eb371346eb0a0a0a0debbed4bd316669"
  license "Apache-2.0"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f40dc411ba97ec3c2997fb8d885196bffd0910c64cafc94d96bb453d82e92a77"
    sha256 cellar: :any, arm64_tahoe:       "feb20057bdbf72194a5dcc9d1f4f594c5f62a30203d7653416537153d2949f70"
    sha256 cellar: :any, arm64_sequoia:     "77596f4c7b268e2a99dc7b4b256383de400b67c870a7fb5f893e0f24afea9e6f"
    sha256 cellar: :any, arm64_linux:       "bd358ee08c586bf724c35917e8373fe4183d595f64ba95a33b3779029fd5da01"
    sha256 cellar: :any, x86_64_linux:      "6c6b1a20362fad29a366313cb2687f8749b6f5e18f9e413c892cc95a01eaa5aa"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-mqtt"
  depends_on "aws-c-s3"
  depends_on "aws-c-sdkutils"
  depends_on "aws-checksums"

  deny_network_access!

  def install
    args = %W[
      -DBUILD_DEPS=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{formula_opt_lib("aws-c-common")}/cmake
    ]
    # Avoid linkage to `aws-c-compression`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <aws/crt/Allocator.h>
      #include <aws/crt/Api.h>
      #include <aws/crt/Types.h>
      #include <aws/crt/checksum/CRC.h>

      int main() {
        Aws::Crt::ApiHandle apiHandle(Aws::Crt::DefaultAllocatorImplementation());
        uint8_t data[32] = {0};
        Aws::Crt::ByteCursor dataCur = Aws::Crt::ByteCursorFromArray(data, sizeof(data));
        assert(0x190A55AD == Aws::Crt::Checksum::ComputeCRC32(dataCur));
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-laws-crt-cpp"
    system "./test"
  end
end