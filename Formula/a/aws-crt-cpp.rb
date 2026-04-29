class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://ghfast.top/https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.38.6.tar.gz"
  sha256 "ce24b6eeacdc22f38d43707d4bc1380c0f39540d282501c6f822acce4b99d582"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b96445ac6ef00f9e65c7da89072d97f924696d89cfd9c341b4ee095bbb538d79"
    sha256 cellar: :any,                 arm64_sequoia: "1efa283318bb740bdcc0192572410dfb5e283b878dd83fc0797bd081cc90f24e"
    sha256 cellar: :any,                 arm64_sonoma:  "724f9c51a1c37da7a2e80998a11cea57af3f4ad24c3c6e346f93d5b6d33b8340"
    sha256 cellar: :any,                 sonoma:        "4eef31be1b89ef17a4ba3d6d5cec71689dec2fc91e02504cce264764376fbf71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f11759d7141434d96cc28d080a1216a4c13fa38705c7ac4eceab3dc79cb9d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03617558641ae131678023430c65f864506e03535be60eac26abb66abc0a07dc"
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