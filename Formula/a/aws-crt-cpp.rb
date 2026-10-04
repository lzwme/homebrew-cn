class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/0.43.8.tar.gz"
  sha256 "e5488479a51a8d2f26acc4acaffb10f26cedc2fe12711b3abef5554082567df0"
  license "Apache-2.0"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "455c800d7a358205c0449ec98887467d73cc85975dd5505233b0669b963ea334"
    sha256 cellar: :any, arm64_tahoe:       "e57c936e927c41f85228c3e41ffcb5e4b67183658a4f4720d224cd05e18e06eb"
    sha256 cellar: :any, arm64_sequoia:     "ef34ee7a486e2ec273a67c45af9df35a98c11cc0489d346941979178100d3768"
    sha256 cellar: :any, arm64_linux:       "e1eb348187e17f8cdc6b52623a2626f3927155e408f55aab00a68351f4526e1b"
    sha256 cellar: :any, x86_64_linux:      "7d8e61d4c03929040f3239045fcfe710e11c8fcc5d2c1953f36b4cdec62de104"
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