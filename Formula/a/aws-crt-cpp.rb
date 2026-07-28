class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "49e112355c05505c35821994d17e500262c024d314b72ed089c52f87fe5162f5"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "34dc7603c4c238779cc5837c1714c76c9d2ef3725ea635ce5c4cff8165ac63f6"
    sha256 cellar: :any, arm64_sequoia: "a239f1f0b95f8f45cf6a2a42021095e761b910c443026098eb1dc2b52eb7cba9"
    sha256 cellar: :any, arm64_sonoma:  "d560565489fb98091d7449840c4e0dee8d1e9758bca2624161e365b6451d4aaa"
    sha256 cellar: :any, sonoma:        "d2e8ba9828774ae135298dfa65dd2a11499adc7a99865d53c55a23b7c0321141"
    sha256 cellar: :any, arm64_linux:   "1e637143eda7f871c3176bebfeb7c8ebabf2ca5e916f74503b514fcefac9ae1c"
    sha256 cellar: :any, x86_64_linux:  "c3ac92c793890e296ed2e3a0a8fc14f0a235fac6ea3457ff52eed876490fc0cd"
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