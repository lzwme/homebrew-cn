class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.33.2.tar.gz"
  sha256 "3d8e15483c6e28575f2d1a30d04f509d028fddb647c948efdb980f21f6602b51"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cbe0fd5fe17c4e9fd7ec82158b714c6716b9acf6e991def3035b7e18fdb666a6"
    sha256 cellar: :any,                 arm64_sonoma:  "b4c45f24896188926d0f44dd9580fa5b4401b5b76eda3aff59b73800f694aa49"
    sha256 cellar: :any,                 arm64_ventura: "5f19f1c32a0a15d542117e0c7ae3102937a608e11eeec07993560c02d3e7d394"
    sha256 cellar: :any,                 sonoma:        "f30de12cc06531c35a810ace0c6f6225072c3691aa67f23b9d59557123a84e96"
    sha256 cellar: :any,                 ventura:       "00553a68d7ddfb6383f7e0d759f61661375cc033184b2451b4b47252bf4caf12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bca0f43b1a2efef4649302f7060f7d5fb95ac5131dab4070a9aa4dfbc960292e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66320de353514d033e92d483c8df3390c2244d06c37526c44f150f57f147e6f8"
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