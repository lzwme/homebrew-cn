class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.33.4.tar.gz"
  sha256 "8332b823c5a7ca241482302adc5d19c3da767b3d4f5d20f936a3b4be4504c5c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "09b206122ef648ef3857b4df777d333bff867028f3b15a0eaf29ed4889d7d20e"
    sha256 cellar: :any,                 arm64_sonoma:  "bca4c34de8ad28c625f9d11a0c2843e4aa30e32a643534746a2c957c9d78a985"
    sha256 cellar: :any,                 arm64_ventura: "6c3425e70ccc462d991ae294696f3692c1c6161ad547eade65c2bb94c55c0f13"
    sha256 cellar: :any,                 sonoma:        "d7ddf00c2e839bfa68ec703af8c9f1822af64700823c85435cc8c7dffa7a0d79"
    sha256 cellar: :any,                 ventura:       "296b3d17aedfa10ef304f54ce486cd51c807ce2a2a0e8569d2c78b3123b5661c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "896dc97922eda5dbe6f64b9f94656a3e9b9aef2ad1957b3879bf4e66e426883b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33627acf14641baf553eab8fadcc221bc82c2318053ae3a070c78b2e4811deab"
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