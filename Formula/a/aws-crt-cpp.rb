class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "6ef0781929ef2cba0b21f1e3f585491b6a656e48acf3cab041f8f82c569ab642"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eddbe92513ce6ba4ad1883e6feab63e54464df3a539ebcef4aed9e6a1147e950"
    sha256 cellar: :any,                 arm64_sequoia: "7d6731063e3b930c954ae20de62ed7ba44e56bfea8129dacbcb5894916ae4822"
    sha256 cellar: :any,                 arm64_sonoma:  "93a4b51b9443457df2f23e821eef9bd2014318f5db73b148064b540379951ef7"
    sha256 cellar: :any,                 sonoma:        "033a909e0a3992831d6ff3b1f9e8ed6071b428aa7d90f075191c0131230917ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef7251c8f6bc49e9de4e57a60179851eb2fc04edda4449d736adaaaa419b0075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26230b4949988deb54230491c82c060e3dd577dede9ee728adbb9c847ea9c774"
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