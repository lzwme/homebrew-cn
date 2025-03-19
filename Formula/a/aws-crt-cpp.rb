class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https:github.comawslabsaws-crt-cpp"
  url "https:github.comawslabsaws-crt-cpparchiverefstagsv0.31.1.tar.gz"
  sha256 "f6b48f2de46b8d2c476a01cf37a664356b885ca7f4f79ede31196d2beb2fa68b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b11162837987c23539960912ad192b650214e3091b6f890afe8fb302773be348"
    sha256 cellar: :any,                 arm64_sonoma:  "8c2f3d1cd89f891d92dde3d083787f5d67fba5b466e70348d74bca3292484678"
    sha256 cellar: :any,                 arm64_ventura: "8c47cab9d49246e5919a21cda4ca6f9985b812081153db2d370cf3dd285a58a1"
    sha256 cellar: :any,                 sonoma:        "0e26c82e864c762804ae5e6065a7865f34498320a46f7e33fa447d217a48d203"
    sha256 cellar: :any,                 ventura:       "b73677fdd4555d11d55e0e5bd8c6f9b11526e3e5f1912eb22211f5e4a378e617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65bf79f43f6ffaef190227b9962240511463a0286055b657c68d5c1b04a38d4e"
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
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}cmake
    ]
    # Avoid linkage to `aws-c-compression`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <awscrtAllocator.h>
      #include <awscrtApi.h>
      #include <awscrtTypes.h>
      #include <awscrtchecksumCRC.h>

      int main() {
        Aws::Crt::ApiHandle apiHandle(Aws::Crt::DefaultAllocatorImplementation());
        uint8_t data[32] = {0};
        Aws::Crt::ByteCursor dataCur = Aws::Crt::ByteCursorFromArray(data, sizeof(data));
        assert(0x190A55AD == Aws::Crt::Checksum::ComputeCRC32(dataCur));
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-laws-crt-cpp"
    system ".test"
  end
end