class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.44.2.tar.gz"
  sha256 "5d959527f1e91db1410627755fc9a2c9eb371346eb0a0a0a0debbed4bd316669"
  license "Apache-2.0"
  revision 2
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "572136b6655729ce36537b2ba2581c856f090389cacbde9be8c47a8f7dc3b083"
    sha256 cellar: :any, arm64_tahoe:       "af802b0ec64934d6df5abacf75dcce2da653d2119b80c76fe5c790707c272fe5"
    sha256 cellar: :any, arm64_sequoia:     "8428ce196eae61b738a9e8a4d1686b03855645f7d2b2a72bb3b6815a5279decd"
    sha256 cellar: :any, arm64_linux:       "45d834857820da8b1dfa04e2470377b1eb0b45cf9714c8c49242bfa24291a330"
    sha256 cellar: :any, x86_64_linux:      "e48de654630beb3cccb0efbac2a9828c7b655a7a658d2ed63c515fb4199d5e40"
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

  deny_network_access!

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