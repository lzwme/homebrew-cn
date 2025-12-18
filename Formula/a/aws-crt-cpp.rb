class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "5e0fcfbb90fdb6ffd7a0cb87798429ee2bf364e309d549ba7c3349bc470f8501"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "939679eb129800adc71793d257a2bba9cf0aaaf6bca66045d0d733b70e248a1b"
    sha256 cellar: :any,                 arm64_sequoia: "232cc603071ddf0c69ef09e42952054b6e601cd8a3adb0201a36274c2bbd1f7c"
    sha256 cellar: :any,                 arm64_sonoma:  "9cf5d7f75dd61735dbb900129c8af9415484bdc43cb00fd94684d398cc357496"
    sha256 cellar: :any,                 sonoma:        "8b2b6b6cdd86504efda505920c28123ed62416de74b2857019b21c5c2b2a3d98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd0c7eee7fbcb97b40c18d9c0459679cd3e5c3b367e6cb39340861c09da2d15e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09202b9d7994bd3aa051bddd921ece24c5dae9eadc27b909f0c418f1ea679117"
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