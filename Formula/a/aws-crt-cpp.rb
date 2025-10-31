class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "bf73e3727b623a47876a5cf225a56d1cd4508621a74a891a09402268a38521c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "53cd9573bc9b601a6c5271399e4505861002e269271085bd1801b44dbbc505ee"
    sha256 cellar: :any,                 arm64_sequoia: "0fe8fe6e72b0451549197a23e38a6e2aa69ef6166127bffac38da585ac3e0167"
    sha256 cellar: :any,                 arm64_sonoma:  "ad9f156ffec19646700b6ce7712fc7fac72947d61769b61afe72efe97e3ea0eb"
    sha256 cellar: :any,                 sonoma:        "5e573d9d98da6474c9c308158a57b1fa94d3e8c13f065339bb669529151fd761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9b877e1c23da039d99b57f3dad8caa2aabc9e00ba1d1683c085a8bcf01574f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b4bad835427301620005588f902d196e53529b45ad762fb8c0926565b53d820"
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