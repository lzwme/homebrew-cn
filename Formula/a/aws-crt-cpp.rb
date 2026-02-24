class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.37.3.tar.gz"
  sha256 "8cbe1dbfa0aac9fae835f2fb1f36617c39f618f3d69445e9f504ba56ef2e8df1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b3409e029b35460f93634bbb9845cb381f93d649ee975114a8efa900f81ad7f"
    sha256 cellar: :any,                 arm64_sequoia: "ea35c3896698142286f3ad5370616345d9fb69308536a9569749cdc3856441fd"
    sha256 cellar: :any,                 arm64_sonoma:  "02e4b9b803bee9247c1aa8eb6df682ad1d33173e6a2cbb7b14310166b16e7435"
    sha256 cellar: :any,                 sonoma:        "ca89b7d8f9c2e35bde2dacb756c5c6f6222bc42ab521f2b62e284663b9c9066d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b787070ca8d5477f935db1a91ad33240a670de01877f1f5a54ce14e860fd916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "484373a5b5fab08a206feca4cf4cf1dd927d3b1c6f548348f877897d0fa238dd"
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