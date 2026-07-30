class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.43.2.tar.gz"
  sha256 "8a9066123475ccb59f2730f76240bccc7b856eeb8f3edf122c5ef8c9a15cb1c1"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f5b763e4203a66195629900116d57d9a303200c01caf42600041472e1143933a"
    sha256 cellar: :any, arm64_sequoia: "3cfa5767203fbe6775776aa3484c9f9b131a0206e42b4fdae4e619998d181680"
    sha256 cellar: :any, arm64_sonoma:  "4769d39f5586091c9650f5d7e1063607a5503cedd98a6c6bba37fb9ed4bab1ec"
    sha256 cellar: :any, sonoma:        "e4a493eb85eb0e12b90d7cb636d6609749bf7be1f74c790614449ab26b40c5d2"
    sha256 cellar: :any, arm64_linux:   "5a66d3c816d469518a2abd43201988ba173fe658f6ac540505aac2e829b06cbb"
    sha256 cellar: :any, x86_64_linux:  "a58d446428fc8309188938b69f549e263ab7878c79abfb2d7884b16ea115b0a2"
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
      -DCMAKE_MODULE_PATH=#{formula_opt_lib("aws-c-common")}/cmake
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