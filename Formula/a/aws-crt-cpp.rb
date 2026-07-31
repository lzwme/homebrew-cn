class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.43.3.tar.gz"
  sha256 "fe291d1d827ea52b46deaa7b731fc3dd9d7a5fa2a2f34e163ad6a552243beb33"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5583693fff608ba4cd21b1acd7c8bb899750d34a8362ce9adc442d2e3b6a08e9"
    sha256 cellar: :any, arm64_sequoia: "949ffd2805c462cbb350b6fc85fc66c58f0ed655afd2c2bf9653e8fbc5212e40"
    sha256 cellar: :any, arm64_sonoma:  "e20a0ef2b50ccab90d8ee06ad2e63dd091481e7e873a6c57a10d5e16c467bd92"
    sha256 cellar: :any, sonoma:        "f07261b9424d156bf333ab1b73f141a83082c7a7bbfe73bec5bb5a54abf41178"
    sha256 cellar: :any, arm64_linux:   "8ffa402781125796f0d38af6a807af4e8f783fbc5c0e4282171cf5543edc72e2"
    sha256 cellar: :any, x86_64_linux:  "ae302dc286631c599855e32ce7f26a38137db1ca337bbd5098ca819ad6fb095d"
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