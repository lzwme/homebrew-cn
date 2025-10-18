class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "33a4538b68c2cb58f6132fda943f83fd993f2402b57cf506deb33e99268d8e34"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9a6925f7f1e53a8cd753a2c9fa412e7170d58840a4d3475e5d6d5bbfebfee58"
    sha256 cellar: :any,                 arm64_sequoia: "b42d50b03e652f64d4a9a7e4079002d18b73a29241642dc81e4e1000a36e6891"
    sha256 cellar: :any,                 arm64_sonoma:  "c5c16ae4e924345423454bb7b19d508eaa8dabbcdd75e91d35c1c769e3d62011"
    sha256 cellar: :any,                 sonoma:        "db5e8772597cea64777ed160ad4b1147e4ab1b850301e7755c3740f1bd8af2da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c64e7bbeab4125330da4d91a7908fa68235470a16a06183e858fa65ac91d7378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ccbd1db706b3fcdbb024831d5986c03347f2a01c4bf01a4beeec3084052af4e"
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