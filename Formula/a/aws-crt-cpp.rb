class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.33.3.tar.gz"
  sha256 "a9b01355f0c827e3a514ca85a7f303a3bc45985c11362188a1547c613f9ccd1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "19ea7405803fff85bcd13102060947d2aa3c9af1474fb5badf945f46bffca623"
    sha256 cellar: :any,                 arm64_sonoma:  "54b704c3cb8f5affd0dc2767d8c28d0d286099f02503612f49042bda4c2c87a1"
    sha256 cellar: :any,                 arm64_ventura: "0a224beedab8bfe61c228a909afb5c2826c20f142d2b65fd42c8180a224d8a1b"
    sha256 cellar: :any,                 sonoma:        "2b6e476e5a6de872679f6622fc7f168cbb6aed0134fd5df7ebac8ab2d47f6044"
    sha256 cellar: :any,                 ventura:       "ff6726857bbf1118ccaee82703434ed343139d8c0fd446a8d6d1fba6322ef7d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed8000fc7b60dc9873774d270c884624c004c74de2f1f84a9fb477345fd53857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1938a8ebd4af0d8c1603f9f77a92e2f5f8fdd242e6d6126568fd1f30f1f1b53"
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