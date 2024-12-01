class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https:github.comawslabsaws-crt-cpp"
  url "https:github.comawslabsaws-crt-cpparchiverefstagsv0.29.6.tar.gz"
  sha256 "d8ac5455517487f35137ff5b35d5130238781febb08715d1e0754b90c642f7b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f68ea81ff7f23de3ca238bfceb242f3521df773251fdf8112469c45d899ea32f"
    sha256 cellar: :any,                 arm64_sonoma:  "6e63cddb508262209cf39e02991c843814dc29aa68eedfb564b91b7b48b237fd"
    sha256 cellar: :any,                 arm64_ventura: "f0f8bdfc64ca25a9085f34ddb025c218910d9569c306bc97ae747ae57d7338d8"
    sha256 cellar: :any,                 sonoma:        "6c3bf8a46c34f1afaefb429ca968ae05337c1ccbf5c58b3d85a49b8f8456a0ee"
    sha256 cellar: :any,                 ventura:       "d3d4d7d63156c53b6ed19c97ac3219b149fd7a165ebd4bfee1fa5687d6f1bfea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "906fb2701fc44e4b78954cc29e7dbeef929cde30e13671f55f3966d938186f81"
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