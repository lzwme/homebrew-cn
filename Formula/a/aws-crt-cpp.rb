class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.43.6.tar.gz"
  sha256 "a02687298bb6b0ee7cb3cac8055a4dbae505ddb6242f3e33596b2c63eb3d5ec5"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9613758ce30093deba0e9b6b732991023bfce662acc4b84a39c2c5fbd087fa26"
    sha256 cellar: :any, arm64_sequoia: "f196c2923477cdb14aceda1c34369361ed36b1c8be267f470fc47177b021ffd2"
    sha256 cellar: :any, arm64_sonoma:  "62cb8e174f8b342522c4d50ae454c39e882f32a01678186241f74f08cc8e6a6b"
    sha256 cellar: :any, arm64_linux:   "cce121c33542f66dfb8f15f6145dd5e8de8fd3fcef1b630236ecba185c027cfc"
    sha256 cellar: :any, x86_64_linux:  "9147cd9868dfb2cc9c902a28681ca3d3021fce5a3681c77e4546673af286c125"
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