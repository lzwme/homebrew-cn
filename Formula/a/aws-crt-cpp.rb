class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.35.4.tar.gz"
  sha256 "3deb29f816498259aa289930afdb5f37d95bba991ec224952f57f931d877e81d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2750a6d9ee3dd710969b6a364245c41e43034f803432962f9a00938ed10f5594"
    sha256 cellar: :any,                 arm64_sequoia: "6bb1f732a225b2dfc59974600344b48c2b67e4779f6ba9c9e48fdccd83daabd6"
    sha256 cellar: :any,                 arm64_sonoma:  "78a5f393f37b98d2a76c6e4c04bc77c94a070e8f321045f18bc26615aeebb4c6"
    sha256 cellar: :any,                 sonoma:        "d0235d33c7f62f4993345efb13ea24859e248c6ffd2ae91c53ccb63fb0b0424e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d074df8cbb0f0fe8f461c08acf5d99ffb0bf1de4ecc82a33c601a1ae9ab77e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fef9c1fb008ed392199b31048d43217293a93943bd5815713d03cca21a964338"
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