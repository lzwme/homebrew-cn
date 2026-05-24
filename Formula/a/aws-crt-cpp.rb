class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "e8f2a47737915ec36aaab68ec7bdf783f7a903f68322d3c0888d30951483b948"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4219f12db5aa8e1f885366d4af4a41a8bbe4efa91f281b528508739cc151d29c"
    sha256 cellar: :any,                 arm64_sequoia: "be3fead089a319a08c17c40efc3529954c59845448ec1d0632f862758bc54044"
    sha256 cellar: :any,                 arm64_sonoma:  "5a5fe98606fa9975e6bec829fa41870cf432b455a6e4802ab1bde1a3588a6429"
    sha256 cellar: :any,                 sonoma:        "a2a28b8d172850c2633b55fa3cfde2bd91bcf50d56032b486c43c8cebf33f95d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef92b1ff37efcad71131cf810a5d3e392c164ee9115780181524c74fafbc42ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa1a3fb0e38e0a0a242b9e3d3d6e1775f66052e617378497f7c1dab0b5bcda2f"
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