class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https:github.comawslabsaws-crt-cpp"
  url "https:github.comawslabsaws-crt-cpparchiverefstagsv0.31.0.tar.gz"
  sha256 "4e920a5da67f77a4e2cbceb0f8d3a279f57888cde0abeae19b58bc8374d1cb3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8dec21d534d5f98ce25447e1e40b30cf4bf2c2e77581e9046eec1f89bddd4657"
    sha256 cellar: :any,                 arm64_sonoma:  "16026c5c39d9c8e77bfaef893a3e76c4c5de0d7a3442cbdbba733831a00282c7"
    sha256 cellar: :any,                 arm64_ventura: "6fa55261bc63e8e6ea5b0fd808e68367456ee642168499ea59f7a5ec52d5a448"
    sha256 cellar: :any,                 sonoma:        "96938e45fa81f0c77d16fad7e3ced8902ad84d307b62882cfbfb7344c964b90b"
    sha256 cellar: :any,                 ventura:       "b47d735c6e46477e3e8ac924d4c52a251394515d49327c6cd2e98f435ce9c2f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a9c18350e876096879adc80a78c4fc76cd2517ddf79fb3d56916a865a862715"
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