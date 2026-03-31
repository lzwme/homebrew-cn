class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.38.3.tar.gz"
  sha256 "9e8922d2a900f7a18644892f5c6aec8cc8f3046d1ee3fdd96714f792c310ea8b"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "896ee570163d6e84d68bc5c8f439d3138ec8f603984896371c993d5f460b37b2"
    sha256 cellar: :any,                 arm64_sequoia: "6abc252488953a6ef48e221619d0d714c87ba7ac19862ba0b6b72228ba1a66f0"
    sha256 cellar: :any,                 arm64_sonoma:  "1fdf70003977b4a861f9c1352dbf74a5fb75762f0861043345e078d79fade649"
    sha256 cellar: :any,                 sonoma:        "e5fca6a27fe13e0e18b959bcfc8cee7798e91c214df8bc6d47804997a834aec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e049da88812ee6ac579206ed6770f76c951fe51d321d894fa3cc13204bb3bf44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7de9e6a3dbd42338e5038d0eacef3e55aec91ed9ef96e3eb0c32e34e75e15cf7"
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