class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "edb3350ecabdefabee25f807816ab5ba0fb14615b267f329900a64d1c8cd4623"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "682a7cd6af661ac3fc2c5fbbbfecc0525a2208f6ed85900b90c769f1e8bb5c9f"
    sha256 cellar: :any,                 arm64_sonoma:  "eb7e686f23387c5c4a8440ff96f48e1efcff57a7502320a9d9764421b299e049"
    sha256 cellar: :any,                 arm64_ventura: "9140ee8c499b9d10d9fe22f630e82173801c56d5c7a3d1a03117f182534fbdd6"
    sha256 cellar: :any,                 sonoma:        "1514c63433d7d9b5ee9520e731398c92309644d3d0d96c9b2b957122925ccc97"
    sha256 cellar: :any,                 ventura:       "76faddd755d95063ed43be0fd9f221dc38aae3c7ccdec157b856ff50ccfc8612"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "052e3efae26ee8c9e03309844995fd02abca31f349dbb5dcb64a2c632aa447a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77bcd6aeda7cd65a2e82ae05d782aa1b2efb88626b7368f83bdda3b81deb47d6"
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