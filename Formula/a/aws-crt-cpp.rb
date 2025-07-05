class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.32.10.tar.gz"
  sha256 "3ae101aa7a0a62d9868575b0e07a64536da1566283a5a314a4eee0326d808295"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f1cd802d82b8782ad0aab1e623425edb629d576e7400d593ca8c02d1d948741b"
    sha256 cellar: :any,                 arm64_sonoma:  "fc53c487b002a89c156f7e6c49af0c1057f334c6c35d5e23446b08a1607e0851"
    sha256 cellar: :any,                 arm64_ventura: "2d258dec2447485ed04120c9875da1ece66abb5032aa87af73826bcd28d6bc97"
    sha256 cellar: :any,                 sonoma:        "d4423ba724cf3205a4fc6352bae0d69a353ad391733321283796c2f05b35f152"
    sha256 cellar: :any,                 ventura:       "c890a9e4d2319f3c7740c764c00671b408e8e0d817dad6ab57278737eba9defc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07e38190886550d997d88bcfe28f7c2e742b1962f24106b257663ab2ec6c9820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "145437ce9bc9ecb3e52df345eeca4bc356d629b54190f519710612aa9a4b9e80"
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