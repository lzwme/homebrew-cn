class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "bf24fdba415842654f26d36978061812e38d3485e8505d2fabf0a548fcf735c4"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "302c04a32a17e72b864d442c2d7becf4d1e96653882c735a2a70ad9fc0d804d9"
    sha256 cellar: :any, arm64_sequoia: "4c4d2b8d35e48f91ecb5430e619a0a68aa2818373db7dce677c76dbefa945dd3"
    sha256 cellar: :any, arm64_sonoma:  "7d4bdb89dbf0d37389a23294b5c852bf714be0ecaaabeaf037e29a28dbda9903"
    sha256 cellar: :any, sonoma:        "4214e720465b34a94cc6b4fa0775ec31370542ff3d9602f04e59aa44e187474d"
    sha256 cellar: :any, arm64_linux:   "852284675f887aa1b5bdd729885be84859f7d3fd2ca35cc89f6dec332af1dcfa"
    sha256 cellar: :any, x86_64_linux:  "d71f7e880ba7d4a34ac3b0ba460d9ba1b17543d76f7d58df0b6ab623f5c79200"
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