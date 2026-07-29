class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "5ecaabbcb994fcd902eedb3569faa6bd39049e31b6f4a448d2b159e3dd07f54c"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "274c55a2b1a604ed3ac5aa696048766ec5a9e83e4d873a2e0c195555eeaca2fd"
    sha256 cellar: :any, arm64_sequoia: "99eb07fa61a288b644e0178d2392db4b75775a378ae8dbc317df4a7ce75b788a"
    sha256 cellar: :any, arm64_sonoma:  "11cbcbffa15ce3baa1e733b508cab61a826d3fe35a3c4a4f90750da02e83bb8f"
    sha256 cellar: :any, sonoma:        "6dc2782745ceb794b0fd2e457e21a4ea4a3bfe8e2bf3b4d1af8e25c86cb511f0"
    sha256 cellar: :any, arm64_linux:   "2f266be293305bdb8ce31d7a5e26cda905f9bf9b47caaf918305347856b02a13"
    sha256 cellar: :any, x86_64_linux:  "f94365541445b51789b5f0f72384af02f5ab3dba699c62955de72696b474b75f"
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