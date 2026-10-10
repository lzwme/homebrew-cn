class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.43.9.tar.gz"
  sha256 "5f52adf2f2b4e3038eb2a2b4eba2af961f3498d870c4e48d3f0509bad0a4e9c2"
  license "Apache-2.0"
  revision 2
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8a91c4d2da1de879502203e03a30211cd243c77f8380ebc754c70b5c01ca54d1"
    sha256 cellar: :any, arm64_tahoe:       "e71075adf64dd8a04c98ad868c464a835232bc27a3527571cdff8e7d52bcc0d7"
    sha256 cellar: :any, arm64_sequoia:     "96a522fa07df98aced5aea1c8c8b02e1c6959592d7299a2a18cfbd99d87e05ab"
    sha256 cellar: :any, arm64_linux:       "ed71b1a697041df3cc77e2ee0fda36fe82c18786e8233b11ad0c4104ebf86bc4"
    sha256 cellar: :any, x86_64_linux:      "85aeb442fca845e53aafc3894c59be3036cd3eca24b334bed7b17261fc65dfef"
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