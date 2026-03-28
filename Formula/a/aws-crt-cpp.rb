class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "e8275e143c8e525de72d78ce75ff77e433e996ce580a3fab52607b137a71d07d"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2de74025d0b888bbca46acace229820e9e5ea7d6d3d8c005a140aa6af46e1b78"
    sha256 cellar: :any,                 arm64_sequoia: "9f11b883ea119a29ababb9da6081b8204d53c7cda0437be9b1621f62c7a4d6d8"
    sha256 cellar: :any,                 arm64_sonoma:  "739fe8a2a98971bac9f143ea9e4b9e250a7fbf821d852dacfd2a35c3d9b03da6"
    sha256 cellar: :any,                 sonoma:        "973e9626fcf0f0461b4968abae03cd20abd2a0f2dba1ff99a397e81c15bebecf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06799705e71250ddfab245abced3a9e4c5c7f232f1b09c6b6dbc53b3543c9f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "841f8d714c49de7e468762ab2ec241fe8c81609d16a86e5aff948b6278d2fe7c"
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

  def install
    args = %W[
      -DBUILD_DEPS=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake
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