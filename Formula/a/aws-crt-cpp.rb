class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.35.2.tar.gz"
  sha256 "9d53d7018994a5f7fc879d397032b72ad88b1585a8cc07e2c8c339ae427f0577"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e60118db2e66baba29cf41ef5ffc700a99b89d212a1855d065886596f819f249"
    sha256 cellar: :any,                 arm64_sequoia: "f7e78ef5f2f0ebeb997b7f744db22b191e2b1970d85af6579acd19504901175c"
    sha256 cellar: :any,                 arm64_sonoma:  "9ec54417b3b905c7bcda2a1eff2a2501fcdef4f0ef2f1714ca824cb0738dd38e"
    sha256 cellar: :any,                 sonoma:        "e6695159cd7caf5e93decc36dc1844520ca24c833e74506714830cbb64feba09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f71fc8617a033177f7cba0076db516d719731a3d0fbb3e2b1368e915c38d04ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccfc70760e482bebf5cd979c2963f04d31575e2f68db1a9f93d0c041a0d9ebd8"
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