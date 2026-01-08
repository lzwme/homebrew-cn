class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "48fdf0c308dacaf00f187e6f8ed49a8e39718a965ca627acf523f83a6f1a1a7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f64e99ce2eee1e16ba3b803c42d9dfb8510b2a9ee23c8c8735a98de87bff979"
    sha256 cellar: :any,                 arm64_sequoia: "bcc5cc5aa1817cc333700d4ccfddfbfdf4e36d7bc370e47f981b9102a0ad1c40"
    sha256 cellar: :any,                 arm64_sonoma:  "c254c87bdeac4cff41543e8740339c90404bac91ba13c92ba44da8081966bd07"
    sha256 cellar: :any,                 sonoma:        "2b6acebb421ad4769247367352859a2ff29e07f32261d9aae3946c6560d7f8c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b4eae94bd26b27d943b400e8a97f8b088b7099aac8e5129d443787aafafe1d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3be8aec0d5a50485b2183789e4fcd37c198908f2e83c6ccff4fd571c6224686"
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