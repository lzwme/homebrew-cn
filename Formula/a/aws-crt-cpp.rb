class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https:github.comawslabsaws-crt-cpp"
  url "https:github.comawslabsaws-crt-cpparchiverefstagsv0.32.2.tar.gz"
  sha256 "0969801f13344deaf6e4dc8d458798e0692d4a67dde5ccac3eda9f261ad771bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "95d6903503b8784927f9f843a8ba2f247b5f67477b2a31aa0bca89814f885634"
    sha256 cellar: :any,                 arm64_sonoma:  "88ffb0650638e986d3ccd878f7ba2cd824c6b6216b3c2e41f37fc9677287d552"
    sha256 cellar: :any,                 arm64_ventura: "2c595d810769b7b2433d206e2525ec60a57214c43c1b9aa53b3d16daa99622a2"
    sha256 cellar: :any,                 sonoma:        "bb56d2d2f892ed87afcb00695fe0a25b4631c893d058ec42a942881d8f931c32"
    sha256 cellar: :any,                 ventura:       "575c12ec6bc4053d1b0211055fad641edfaacbb21cd5cdb5f85e23751e2806e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b04b2f36121024a408204259648a0692cce20c9b7187783f476352d8fb29db0c"
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