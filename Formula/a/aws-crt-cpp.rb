class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https:github.comawslabsaws-crt-cpp"
  url "https:github.comawslabsaws-crt-cpparchiverefstagsv0.29.8.tar.gz"
  sha256 "a693b1b6a802dd8bf0210cbb9f01fd58a95c851309a10a221e1ba7496b81384c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5bbb59a04e7b8054826bb04defab3f7edd15e1e271fc9a4ab406cbd1d8bb73ce"
    sha256 cellar: :any,                 arm64_sonoma:  "97cfadd38d9947aa7e53d6c9d6a49ba7e9d384a5ef5c3b85fe61ca957e78ff1a"
    sha256 cellar: :any,                 arm64_ventura: "340fa15f049ee6708d7d6815e487aeb771d4879699c0cc788e4cf02517b0bf03"
    sha256 cellar: :any,                 sonoma:        "5c997697758a75acd684bf39457bd501d62aa29053a4d77ad4585a4ad25b9228"
    sha256 cellar: :any,                 ventura:       "a8e2bb7b3490a6bdf5eba2898debfc14de67d96f0550447132860c93ee9d8028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8308729f0abf172d241188a1311027dac56f1f012f2c25116c9f970d9dd62ee0"
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