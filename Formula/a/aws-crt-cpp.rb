class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https:github.comawslabsaws-crt-cpp"
  url "https:github.comawslabsaws-crt-cpparchiverefstagsv0.30.2.tar.gz"
  sha256 "79451732f41d35a4fbaa31883c0b851609b021c1752fd309d480eeb0503bfdf3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "016c59912f22f9385cfd0f31332a38a17062807c15228f90a951356582e7b9ba"
    sha256 cellar: :any,                 arm64_sonoma:  "99dba5151237bbbba1118e4507e55924bc633321b971b45ae3bbc00651339b64"
    sha256 cellar: :any,                 arm64_ventura: "fff81c9badeb63d9261204cbfec6f3ba064366308eca175b50dca032e2146717"
    sha256 cellar: :any,                 sonoma:        "64c124ba7300aaf95119fb3968030c8e1e7757a613e6a4f88e0a3df10fe21ca5"
    sha256 cellar: :any,                 ventura:       "4e8cbcdb168744844d09cf6a937c7caa9c9644c380622adcb8a127bdb4647bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38bd3b9aae4193cdb7162c329ee72b8172eac8b01d013a4e004ea422b893f613"
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