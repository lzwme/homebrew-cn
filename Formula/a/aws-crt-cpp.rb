class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "c200f18408387494ee02938b1d1a53300c17217e627c3ede9f3cec042b878139"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1d225c0172a6d3e1ebaa127030b8342dabf2df1595f8131e4af2c5eff9ab5b88"
    sha256 cellar: :any,                 arm64_sonoma:  "43ef362ea9cc87ed1f551d7ba53633186bc048f0e047e1f7b89466cb8468e906"
    sha256 cellar: :any,                 arm64_ventura: "794ce4b36a7d94677047008e71b19b4a2c7232d72e5e885d3783d4eeeff25601"
    sha256 cellar: :any,                 sonoma:        "45cdc5dcb98ddf2178b2648e037a02cd88cec7bfdfddf2c2e68dabaaf80caa9b"
    sha256 cellar: :any,                 ventura:       "150512876be3a0dff86f4bbcc24529ec1ba18d56e0e530130f2516a1c39e24ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f692620e1dee3cfec4afd0b327544a78d60255e8b280991c1787ab356972612b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a8034daa39ae8a82b0bbb93f1f3960cfa5dc6253ddd5bcbbd342849b6f526b0"
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