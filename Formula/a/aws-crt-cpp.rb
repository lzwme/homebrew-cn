class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.33.5.tar.gz"
  sha256 "0cdf169d43b2441ba9fe866f8bd13d8f2437b995a57a885131265df551489122"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5eace3f267134aebbe003c4a8f6573789ed2c66ae9c75b1fce2e552d94fd94a"
    sha256 cellar: :any,                 arm64_sonoma:  "e19b7e2427c33b25d55ce769e95e78005103097a7e0106294080f6b1f0a88daa"
    sha256 cellar: :any,                 arm64_ventura: "8a537d2709a000790a30862fa560b82189e0a68213e5e900d18201ca1bf8d004"
    sha256 cellar: :any,                 sonoma:        "f855aae2e8ae7f889c32edf44cdd170adac8c87de532297e0676575cbdff95e2"
    sha256 cellar: :any,                 ventura:       "5064d1b9faba91f3a194097a033a857baa137c2543bf394746d5f18c21d4714b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "951bcf16e9ce469f49e2efba29ffe9437ac7b78ed7588e390a646087c8d6cc75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16bd318c99c323a1781f68335864a937df5b8217de5852ad8e282934cf3c6b21"
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