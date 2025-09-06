class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "87dc08c4034f1547bb3a4e8c59eef3428ad34a3cd0b1cf8d764beb4caab99dae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5fdd4f2b1d8886dd7034ec97f1dc07ee903aa683ab2aafea52df945333418f6d"
    sha256 cellar: :any,                 arm64_sonoma:  "4057f6cd1f7c8a28e9ca8d68382885b52f06aa0308ffaee220498918ddb68971"
    sha256 cellar: :any,                 arm64_ventura: "e7ebbeea510d183a322c4efc0fd5307e875bcd350b8dd8f9daa54c82c6484039"
    sha256 cellar: :any,                 sonoma:        "a7ee7bcfcfe85bfdd14f2da3fc8025bd835d3d38dd519758919cee46acd864e2"
    sha256 cellar: :any,                 ventura:       "58b3518c842aa76033bfbf5368406cbc65c7df950479751c9718e79fc03bb05c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67df0710f290124f44b0d0a2074ed5ce3804c4760b989398820d5af669a0cd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3900b8d42f48474f19dc7eb09adf05b6b168c690f081f33524b555a500b21d1f"
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