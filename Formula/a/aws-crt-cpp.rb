class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https:github.comawslabsaws-crt-cpp"
  url "https:github.comawslabsaws-crt-cpparchiverefstagsv0.32.9.tar.gz"
  sha256 "e7450d64151038750c2c003b860164d24671d2017859599a228eed0645b071af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fbfee155450c85da8215a658b69ce596026e290c4fa52a8de01e49374eb9e057"
    sha256 cellar: :any,                 arm64_sonoma:  "e9ed1ff763c3a545663e4bf04c3ac82e5c094eac49e64f77ef0450817dc6f5b1"
    sha256 cellar: :any,                 arm64_ventura: "7b25134fd9fa8c651ae1f7d6a1327bdf504e019466a1a050d93d388c966697dc"
    sha256 cellar: :any,                 sonoma:        "869950b841accb8474a88365874d222f2c5efab90f81aca102b6b542a72fe8e3"
    sha256 cellar: :any,                 ventura:       "7a10e7f5b9fd4336cda8e08049ef5296296abeea86d81f8fb5592097b1a95751"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6bbbe9fd9cc90b1d900821cc4530f530c4f0411d3e4b4afa777699fff63b876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cf4e5d49da830296fbf794c3f40ae516dd8728eb8d89460094ca1535d86a37a"
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