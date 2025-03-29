class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https:github.comawslabsaws-crt-cpp"
  url "https:github.comawslabsaws-crt-cpparchiverefstagsv0.31.2.tar.gz"
  sha256 "c4d5eb3fd5707e4874f922f2ffb07f78f2d2660ff02210d1f8ace8b67bb5536f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "303baf1a21f3d467f5fba001e823aef3cd9c4ba1d0e4b922f1fc8e8867950de2"
    sha256 cellar: :any,                 arm64_sonoma:  "50e67e176e6e8d5b79040a2329b76f2818601079cdfdb2ee62ab0b8a6a2a0cae"
    sha256 cellar: :any,                 arm64_ventura: "093d2af376f015e0332d73c37a01d7f1a2c7c9acc6159b0f5495ad5c9a2ce8c7"
    sha256 cellar: :any,                 sonoma:        "86f89ef414462d6cd16bec595685a5afc6f3cc2b3a331854d93b93e08a1b30a8"
    sha256 cellar: :any,                 ventura:       "8c793d1fc885369d71b3cfcdef4f25dfad5b2bae09e927f9c72da915a1c3d44f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfa41772bc811d8079004274f509d4b7cffd53fa91fe26eeabab8ac36c45ed91"
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
    # Fix to 'awscrtchecksumCRC.h' file not found
    # Issue ref: https:github.comawslabsaws-crt-cppissues725
    cp_r "includeawscrtchecksum", "includeawscrtchecksums"

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
      #include <awscrtchecksumsCRC.h>

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