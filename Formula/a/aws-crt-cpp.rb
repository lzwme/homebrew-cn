class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "6f1e629734dc4c1600f10e034624b6908dab3c596863a35b6364badcf662db74"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ca9e06ba5d969ba57831cb75c1bbf9db479573b3c84f9bf0cc241ca7a3afe5a"
    sha256 cellar: :any,                 arm64_sequoia: "4ead63b570598fad6cced02f8a6c9f6b4ee90b3b769731c7badf6e9733406076"
    sha256 cellar: :any,                 arm64_sonoma:  "4e2ed055064cb13d0162c010464c918a468bbe909d9361e77f9e689f141574d8"
    sha256 cellar: :any,                 sonoma:        "47b25011c3ba886477014dba198f9a37b4edb7e9f140d55c9a46a1cd848a115e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "510d0f196b3a827e2f1263f3e4ae1f9294b89c71a9e4219e40237f0c1c73809b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d2cc3188bb58b75fc7fb8ab2ee94c2e87052cf1bcda7153d97f38e8bb1b57d1"
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